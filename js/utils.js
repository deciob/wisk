// Generated by CoffeeScript 1.3.3

define([], function() {
  'use strict';

  var Utils;
  return Utils = {
    getInChartWidth: function() {
      return this.c.width - this.c.out_margin.left - this.c.out_margin.right;
    },
    getOutBoxWidth: function(in_chart_width, boxes) {
      return Math.floor(in_chart_width / boxes) - this.c.stroke_width * 2 - 1;
    },
    getInBoxWidth: function(out_box_width) {
      return out_box_width - this.c.in_margin.left - this.c.in_margin.right;
    },
    setBoxWidth: function() {
      var boxes, in_box_width, in_chart_width, out_box_width;
      boxes = this.c.dataset.data.length;
      in_chart_width = this.getInChartWidth();
      out_box_width = this.getOutBoxWidth(in_chart_width, boxes);
      in_box_width = this.getInBoxWidth(out_box_width);
      if (in_box_width < 0) {
        in_box_width = 1;
      }
      return this.box_width = {
        out: out_box_width,
        "in": in_box_width
      };
    },
    setScales: function(dataset) {
      var margin_bottom, margin_top, self;
      self = this;
      margin_bottom = self.c.out_margin.bottom + self.c.in_margin.bottom;
      margin_top = self.c.out_margin.top + self.c.in_margin.top;
      this.y1 = d3.scale.linear().domain([dataset.min, dataset.max]).rangeRound([self.c.height - margin_bottom - margin_top, 0]);
      this.y0 = self.__chart__ || d3.scale.linear().domain([0, Infinity]).rangeRound(self.y1.range());
      return this.__chart__ = this.y1;
    },
    yAxisGenerator: function() {
      var sub_ticks;
      sub_ticks = this.c.sub_ticks ? 1 : 0;
      return d3.svg.axis().scale(this.y1).orient("left").tickSubdivide(sub_ticks).tickSize(6, 3, 0);
    },
    getVerticalDelta: function() {
      return this.c.out_margin.top + this.c.in_margin.top;
    },
    setXAxis: function(self) {},
    getXMidBoxPos: function(i) {
      var w;
      w = this.box_width.out;
      return Math.floor(this.c.out_margin.left + (w * (i + 1)) - (w / 2));
    },
    getXLeftBoxPos: function(i) {
      var w;
      w = this.box_width.out;
      return Math.floor(this.c.out_margin.left + (w * i) + this.c.in_margin.left);
    },
    getTopBoxPos: function() {},
    boxQuartiles: function(d) {
      return [d3.quantile(d, .25), d3.quantile(d, .5), d3.quantile(d, .75)];
    }
  };
});
