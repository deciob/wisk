define [
], () ->
  'use strict'

  Utils =

    getInChartWidth: () ->
      @c.width - @c.out_margin.left - @c.out_margin.right

    getOutBoxWidth: (in_chart_width, boxes) ->
      Math.floor(in_chart_width / boxes) - @c.stroke_width * 2 - 1

    getInBoxWidth: (out_box_width) ->
      out_box_width - @c.in_margin.left - @c.in_margin.right

    setBoxWidth: () ->
      boxes = @c.dataset.data.length
      in_chart_width = @getInChartWidth()
      out_box_width = @getOutBoxWidth in_chart_width, boxes
      in_box_width = @getInBoxWidth out_box_width
      if in_box_width < 0 then in_box_width = 1
      @box_width = 
        out: out_box_width
        in: in_box_width

    setScales: (dataset) ->
      self = @
      margin_bottom = self.c.out_margin.bottom + self.c.in_margin.bottom
      margin_top = self.c.out_margin.top + self.c.in_margin.top
      # Compute the new y-scale.
      @y1 = d3.scale.linear()
        # range inverted because svg y positions are counted from top to bottom
        .domain([dataset.min, dataset.max])                             # input
        .rangeRound([self.c.height - margin_bottom - margin_top, 0])    # output 
      # Retrieve the old y-scale, if this is an update.
      @y0 = self.__chart__ || d3.scale.linear()
        # input inverted because svg y positions are counted from top to bottom
        .domain([0, Infinity])                                          # input
        .rangeRound(self.y1.range())                                    # output 
      # Stash the new y scale.
      @__chart__ = @y1
      
      
    yAxisGenerator: () ->
      sub_ticks = if @c.sub_ticks then 1 else 0
      d3.svg.axis()
        .scale(@y1)
        .orient("left")
        .tickSubdivide(sub_ticks)
        .tickSize(6, 3, 0) # sets major to 6, minor to 3, and end to 0
  
  
    getVerticalDelta: () ->
      @c.out_margin.top + @c.in_margin.top    
        
        
    setXAxis: (self) ->
  
  
    getXMidBoxPos: (i) ->
      w = @box_width.out
      Math.floor( @c.out_margin.left + (w * (i + 1) ) - (w / 2) )
  
  
    getXLeftBoxPos: (i) ->
      w = @box_width.out
      Math.floor( @c.out_margin.left + (w * i) + @c.in_margin.left )
  
  
    getTopBoxPos: () ->
          
  
    boxQuartiles: (d) ->
      [
        d3.quantile(d, .25),
        d3.quantile(d, .5),
        d3.quantile(d, .75)
      ]