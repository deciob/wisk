#define [], () ->
'use strict'

class Wisk

  # Inspired by:
  # -- "Show me the numbers" by Stephen Few
  # -- https://github.com/mbostock/d3/tree/master/examples/box
  # -- http://bost.ocks.org/mike/chart/

  # conventions:
  #   c == configuration
  
  # typical implementation
  #    box_chart = new Wisk("box_chart")
  #    dataset = sample_data
  #    chart = box_chart.init()
  #      .out_margin(
  #        top: 150, right: 20, bottom: 20, left: 40)
  #      .in_margin(
  #        top: 0, right: 10, bottom: 0, left: 10)
  #      .axis(true)
  #      .subTicks(true)
  #      .height(400)
  #      .width(600)
  #      .dataset(dataset)
  #    box_chart.draw(chart)
  
  # typical svg output structure:
  #
  #  <div id="box_chart_vis">
  #    <svg class="parent" width="600" height="400">
  #      <g>
  #        <g class="y axis" transform="translate(40, 10)">
  #        <g class="boxes" transform="translate(40, 10)">
  #          <g class="box" width="100" height="400">
  #        </g>
  #      </g>
  #    </svg>
  #  </div>
  
  
  constructor: (vis_id) ->
    @vis_id = vis_id
    #@duration = 1000
    
  
  draw: (chart) ->
    self = @
    dataset = self.c.dataset
    @setScales(dataset)
    
    # Set the parent svg, with a g element that wraps everything else.
    self.svg = d3.select("##{self.vis_id}")
      .append("svg")
      .attr("class", "parent")
      .attr("width", @c.width)
      .attr("height", @c.height)

    # Set the axis (common to all boxes).
    if self.c.axis then self.setYAxis.call(@, self)

    # Set a common g element for all boxes.
    self.boxes = self.svg.append("g")
      .attr("class", "boxes")
      .attr("transform",
        "translate(#{self.c.in_margin.left * 2}, #{self.c.in_margin.top})")

    # Individual boxes. Note the call to chart 
    # a closure returned by the init function
    self.b = self.boxes.selectAll("g.box")
      .data(dataset.data)
    .enter().append("g")
      .attr("class", "box")
      .attr("width",
        self.c.width + self.c.in_margin.left + self.c.in_margin.right)
      .attr("height",
        self.c.height + self.c.in_margin.bottom + self.c.in_margin.top)
      .call(chart)
      
      
  update: (chart) ->
    self = @
    getData = (d, i) ->
      self.c.dataset.data[i]
    @setScales(self.c.dataset)
    # Set the axis (common to all boxes).
    if self.c.axis then self.updateYAxis.call(@, self)
    @b.datum(getData).call(chart)


  init: (conf) ->  
    # returnes box
  
    self = @
    
    # default configuration, only dataset is required, because defaults to 0
    c =
      out_margin:
        top: 10, right: 20, bottom: 20, left: 20
      in_margin:
        top: 10, right: 20, bottom: 20, left: 20
      axis: yes
      sub_ticks: no
      dataset:
        data:[[0]], min:0, max:0
      stroke_width: 1
      duration: 1000  # animation millisecs

    # height and width refer to the outer container 
    c.height = 500
    c.width = 600

    if conf
      @c = @extend(c, conf) 
    else 
      @c = c

    #console.log "@setBoxWidth() 1"
    #@setBoxWidth()

    box = (g) ->
      g.each( (d, i) ->
        # create a box plot for each data group
        @g = d3.select(@)
        self.setSpread.call(@, self, d, i)
        self.setMidspread.call(@, self, d, i)
        self.setMedian.call(@, self, d, i)
      )
        
    box.in_margin = (value) ->
      return self.c.in_margin unless arguments.length
      self.c.in_margin = value
      box
      
    box.out_margin = (value) ->
      return self.c.out_margin unless arguments.length
      self.c.out_margin = value
      box
    
    box.width = (value) ->
      return self.c.width unless arguments.length
      self.c.width = value
      box
      
    box.height = (value) ->
      return self.c.height unless arguments.length
      self.c.height = value
      box
      
    box.axis = (value) ->
      return self.c.axis unless arguments.length
      self.c.axis = value
      box
      
    box.subTicks = (value) ->
      return self.c.sub_ticks unless arguments.length
      self.c.sub_ticks = value
      box
      
    box.dataset = (value) ->
      return self.c.dataset unless arguments.length
      self.c.dataset = value
      # set the box width once you know about the dataset (how many boxes?)
      self.setBoxWidth()
      box

    box.stroke_width = (value) ->
      return self.c.stroke_width unless arguments.length
      self.c.stroke_width = value
      box

    return box  ## end of init function, returns a closure


  setSpread: (self, d, i) ->
    delta = self.getVerticalDelta()
    x = self.getXMidBoxPos(i)
    spread = @g.selectAll("line.spread")
      .data([[d3.min(d), d3.max(d)]])
    
    spread.enter().append("svg:line")
      .attr("class", "spread")      
      .style("stroke-width", self.c.stroke_width)
      .attr("x1", x)
      .attr("y1", (d) -> self.y0(d[0]) + delta )
      .attr("x2", x)
      .attr("y2", (d) -> self.y0(d[1]) + delta )
    .transition()
      .duration(self.c.duration)
      .attr("y1", (d) -> self.y1(d[0]) + delta)
      .attr("y2", (d) -> self.y1(d[1]) + delta)
    
    spread.transition()
      .duration(self.c.duration)
      .attr("y1", (d) -> self.y1(d[0]) + delta)
      .attr("y2", (d) -> self.y1(d[1]) + delta)
      
    
  setMidspread: (self, d, i) ->
    delta = self.getVerticalDelta()
    x = self.getXLeftBoxPos(i)
    mid_data = []
    mid_data.push(self.boxQuartiles(d)[0])
    mid_data.push(self.boxQuartiles(d)[2])  # highest value (top)
    midspread = @g.selectAll("rect.midspread")
      .data([mid_data])
    
    midspread.enter().append("svg:rect")
      .attr("class", "midspread")
      .style("stroke-width", self.c.stroke_width)
      # the x attribute defines the left position of the rectangle
      .attr( "x", x)
      # the y attribute defines the top position of the rectangle
      .attr("y", (d) -> self.y0(d[1]) + delta )
      .attr( "width", self.box_width.in )
      .attr("height", (d) -> self.y0(d[0]) - self.y0(d[1]) )
    .transition()
      .duration(self.c.duration)
      .attr("y", (d) -> self.y1(d[1]) + delta )
      .attr("height", (d) -> self.y1(d[0]) - self.y1(d[1]) )
      
    midspread.transition(self.c.duration)
      .duration(self.c.duration)
      .attr("y", (d) -> self.y1(d[1]) + delta )
      .attr("height", (d) -> self.y1(d[0]) - self.y1(d[1]) )
  
  
  setMedian: (self, d, i) ->    
    delta = self.getVerticalDelta()
    x1 =  self.getXLeftBoxPos(i)
    median = self.boxQuartiles(d)[1]
    line = @g.selectAll("line.median")
      .data([median])
    
    line.enter().append("svg:line")
      .attr("class", "median")
      .style("stroke-width", self.c.stroke_width)
      .attr( "x1", x1)
      .attr("y1", (d) -> self.y0(d) + delta )
      .attr( "x2", x1 + self.box_width.in )
      .attr("y2", (d) -> self.y0(d) + delta )
    .transition()
      .duration(self.c.duration)
      .attr("y1", (d) -> self.y1(d) + delta )
      .attr("y2", (d) -> self.y1(d) + delta )
    
    line.transition()
      .duration(self.c.duration)
      .attr("y1", (d) -> self.y1(d) + delta )
      .attr("y2", (d) -> self.y1(d) + delta )
      
      
  setYAxis: (self) -> 
    yAxis = self.yAxisGenerator.call(self)
    self.svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
      .attr("transform", "translate(#{self.c.out_margin.left * 1}, 
          #{self.c.out_margin.top + self.c.in_margin.top})")
        
        
  updateYAxis: (self) -> 
    yAxis = self.yAxisGenerator.call(self)
    t = self.svg.transition().duration(self.c.duration)
    t.select(".y.axis").call(yAxis)


  ### HELPER FUNCTIONS ###
  # TODO some of these could go out and be generalised
  
  extend: (o, p) ->
    # copied from: https://github.com/davidflanagan/javascript6_examples/
    for prop in p         # For all props in p.
      o[prop] = p[prop]   # Add the property to o.
    o


  setScales: (dataset) ->
    self = @
    margin_bottom = self.c.out_margin.bottom + self.c.in_margin.bottom
    margin_top = self.c.out_margin.top + self.c.in_margin.top
    # Compute the new y-scale.
    @y1 = d3.scale.linear()
      # range inverted because svg y positions are counted from top to bottom
      .domain([dataset.min, dataset.max])                              # input
      .rangeRound([self.c.height - margin_bottom - margin_top, 0])     # output 
    # Retrieve the old y-scale, if this is an update.
    @y0 = self.__chart__ || d3.scale.linear()
      # input inverted because svg y positions are counted from top to bottom
      .domain([0, Infinity])                                           # input
      .rangeRound(self.y1.range())                                     # output 
    # Stash the new y scale.
    @__chart__ = @y1
    
    
  yAxisGenerator: () ->
    sub_ticks = if @c.sub_ticks then 1 else 0 
    d3.svg.axis()
      .scale(@y1)
      .orient("left")
      .tickSubdivide(sub_ticks)
      .tickSize(6, 3, 0) # sets major to 6, minor to 3, and end to 0
       

  setBoxWidth: () ->
    boxes = @c.dataset.data.length
    inside_width = @c.width - @c.out_margin.left - @c.out_margin.right
    out_box_width = Math.floor(inside_width / boxes) - @c.stroke_width * 2 - 1
    inbox_width = out_box_width - @c.in_margin.left - @c.in_margin.right
    if inbox_width < 0 then inbox_width = 1
    @box_width = 
      out: out_box_width
      in: inbox_width


  getVerticalDelta: () ->
    @c.out_margin.top + @c.in_margin.top    
      
      
  setXAxis: (self) ->


  getXMidBoxPos: (i) =>
    w = @box_width.out
    Math.floor( @c.out_margin.left + (w * (i + 1) ) - (w / 2) )


  getXLeftBoxPos: (i) =>
    w = @box_width.out
    Math.floor( @c.out_margin.left + (w * i) + @c.in_margin.left )


  getTopBoxPos: () =>
        

  boxQuartiles: (d) ->
    [
      d3.quantile(d, .25),
      d3.quantile(d, .5),
      d3.quantile(d, .75)
    ]


if typeof define is "function" and define.amd
  define "Wisk", [], ->
    Wisk

  
