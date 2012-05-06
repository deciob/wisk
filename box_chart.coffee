
class boxChart

  # conventions:
  #  throughout the code c stands for configuration
  #  the svg left-right margins are calculated doubbling the box margin value
  
  # typical svg structure:
  #
  #  <div id="box_chart_vis">
  #    <svg class="parent" width="140" height="500">
  #      <g>
  #        <g class="y axis" transform="translate(40, 10)">
  #        <g class="boxes" transform="translate(40, 10)">
  #          <g class="box" width="100" height="500">
  #        </g>
  #      </g>
  #    </svg>
  #  </div>
  
  constructor: (vis_id) -> 
    @vis_id = vis_id
    @min = Infinity
    @max = -Infinity
    @duration = 500


  draw: (chart) ->
    self = @
    # TODO: sort out data origins
    d3.csv("../data/life_expectancy_2010.csv", (csv) ->
      self.data = []
      data_child = []  # initial assumption: only 1 data group
      csv.forEach( (y) ->
        d = y.val
        if d != ""
          data_child.push(d)
          if (d > self.max) then self.max = d
          if (d < self.min) then self.min = d
      )
      self.data.push( data_child.sort( (a, b) -> d3.ascending(a, b) ) )
      
      # Compute the new y-scale.
      self.y1 = d3.scale.linear()
        # range inverted because svg y positions are counted from top to bottom
        .domain([self.min, self.max])  # input
        .range([self.c.height, 0])     # output 
      
      # Retrieve the old y-scale, if this is an update.
      self.y0 = self.__chart__ || d3.scale.linear()
        # input inverted because svg y positions are counted from top to bottom
        .domain([0, Infinity])   # input
        .range(self.y1.range())  # output 
      
      # Stash the new y scale.
      self.__chart__ = self.y1
 
      # Set the parent svg, with a g element that wraps everything else.
      self.svg = d3.select("##{self.vis_id}")
        .append("svg")
        .attr("class", "parent")
        .attr("width", 
          self.c.width * self.data.length + 
          (self.c.margin.left + self.c.margin.right) * 2 )
        .attr("height", 
          self.c.height + self.c.margin.bottom + self.c.margin.top)
        .append("g")
      
      # Set the axis (common to all boxes).
      if self.c.axis then self.setYAxis.call(@, self)
      
      # Set a common g element for all boxes.
      self.boxes = self.svg.append("g")
        .attr("class", "boxes")
        .attr("transform", 
          "translate(#{self.c.margin.left * 2}, #{self.c.margin.top})")
      
      # Individual boxes. Note the call to chart, a closure set as:
      #   box_chart = new boxChart(vis_id)
      #   chart = box_chart.init()
      #   box_chart.draw(chart)  # this function
      self.boxes.selectAll("g.box")
        .data(self.data)
      .enter().append("g")
        .attr("class", "box")
        .attr("width", 
          self.c.width + self.c.margin.left + self.c.margin.right)
        .attr("height", 
          self.c.height + self.c.margin.bottom + self.c.margin.top)
        .call(chart)
        
    )
    

  init: (conf) ->
    self = @
    c =
      margin: top: 10, right: 20, bottom: 20, left: 20
      axis: yes
      sub_ticks: no
    c.height = 500 - c.margin.top - c.margin.bottom
    c.width = 100 - c.margin.left - c.margin.right
    @c = $.extend(yes, c, conf)

    box = (g) -> 
      g.each( (d, i) ->
        # create a box plot for each data group
        @g = d3.select(@)
        self.setSpread.call(@, self, d, i)
        self.setMidspread.call(@, self, d, i)
        self.setMedian.call(@, self, d, i)
      )
        
    box.width = (value) ->
      return self.c.width unless arguments.length
      self.c.width = value - c.margin.left - c.margin.right
      box
      
    box.height = (value) ->
      return self.c.height unless arguments.length
      self.c.height = value - c.margin.top - c.margin.bottom
      box
      
    box.axis = (value) ->
      return self.c.axis unless arguments.length
      self.c.axis = value
      box
      
    box.subTicks = (value) ->
      return self.c.sub_ticks unless arguments.length
      self.c.sub_ticks = value
      box

    return box  ## end of init function, returns a closure
    

  setYAxis: (self) ->
    sub_ticks = if self.c.sub_ticks then 1 else 0
  
    yAxis = d3.svg.axis()
      .scale(self.y1)
      .orient("left")
      .tickSubdivide(sub_ticks)
      .tickSize(6, 3, 0) # sets major to 6, minor to 3, and end to 0

    self.svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
      .attr("transform", "translate(#{self.c.margin.left * 2}, 
        #{self.c.margin.top})")
      
      
  setSpread: (self, d, i) ->
    x = (self.c.margin.left + self.c.width) / 2
    spread = @g.selectAll("line.spread")
      .data([[d3.min(d), d3.max(d)]])
    
    spread.enter().append("svg:line")
      .attr("class", "spread")
      .attr("x1", x)
      .attr("y1", (d) -> self.y0(d[0]))
      .attr("x2", x)
      .attr("y2", (d) -> self.y0(d[1]))
    .transition()
      .duration(self.duration)
      .attr("y1", (d) -> self.y1(d[0]))
      .attr("y2", (d) -> self.y1(d[1]))
    
    spread.transition()
      .duration(self.duration)
      .attr("y1", (d) -> self.y1(d[0]))
      .attr("y2", (d) -> self.y1(d[1]))
      
    
  setMidspread: (self, d, i) ->
    #console.log self.boxQuartiles(d)
    margin = self.c.margin
    mid_data = []
    mid_data.push(self.boxQuartiles(d)[0])
    mid_data.push(self.boxQuartiles(d)[2])  # highest value (top)
    midspread = @g.selectAll("rect.midspread")
      .data([mid_data])
    
    midspread.enter().append("svg:rect")
      .attr("class", "midspread")
      # the x attribute defines the left position of the rectangle
      .attr("x", margin.left)
      # the y attribute defines the top position of the rectangle
      .attr("y", (d) -> self.y0(d[1]) )
      .attr("width", self.c.width - margin.left)
      .attr("height", (d) -> self.y0(d[0]) - self.y0(d[1]) )
    .transition(self.duration)
      .attr("y", (d) -> self.y1(d[1]) )
      .attr("height", (d) -> self.y1(d[0]) - self.y1(d[1]) )
      
    midspread.transition(self.duration)
      .attr("y", (d) -> self.y1(d[1]) )
      .attr("height", (d) -> self.y1(d[0]) - self.y1(d[1]) )
  
  
  setMedian: (self, d, i) ->
    median = self.boxQuartiles(d)[1]
    line = @g.selectAll("line.median")
      .data([median])
    
    # Note that self.y0 and self.y1 are d3.scale.linear() functions (take the median)
    line.enter().append("svg:line")
      .attr("class", "median")
      .attr("x1", self.c.margin.left)
      .attr("y1", self.y0)
      .attr("x2", self.c.width)
      .attr("y2", self.y0)
    .transition()
      .duration(self.duration)
      .attr("y1", self.y1)
      .attr("y2", self.y1)
    
    line.transition()
      .duration(self.duration)
      .attr("y1", self.y1)
      .attr("y2", self.y1)
      
      
  boxQuartiles: (d) ->
    [
      d3.quantile(d, .25),
      d3.quantile(d, .5),
      d3.quantile(d, .75)
    ]


      
try
  module.exports = boxChart
catch error

  
