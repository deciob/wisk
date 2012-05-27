// Generated by CoffeeScript 1.3.3
var BoxChart,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

BoxChart = (function() {

  function BoxChart(vis_id) {
    this.getTopBoxPos = __bind(this.getTopBoxPos, this);

    this.getXLeftBoxPos = __bind(this.getXLeftBoxPos, this);

    this.getXMidBoxPos = __bind(this.getXMidBoxPos, this);
    this.vis_id = vis_id;
    this.duration = 1000;
  }

  BoxChart.prototype.setScales = function(dataset) {
    var margin_bottom, margin_top, self;
    self = this;
    margin_bottom = self.c.out_margin.bottom + self.c.in_margin.bottom;
    margin_top = self.c.out_margin.top + self.c.in_margin.top;
    self.y1 = d3.scale.linear().domain([dataset.min, dataset.max]).rangeRound([self.c.height - margin_bottom - margin_top, 0]);
    self.y0 = self.__chart__ || d3.scale.linear().domain([0, Infinity]).rangeRound(self.y1.range());
    return self.__chart__ = self.y1;
  };

  BoxChart.prototype.draw = function(chart) {
    var dataset, self;
    self = this;
    dataset = self.c.dataset;
    this.setScales(dataset);
    self.svg = d3.select("#" + self.vis_id).append("svg").attr("class", "parent").attr("width", this.c.width).attr("height", this.c.height);
    if (self.c.axis) {
      self.setYAxis.call(this, self);
    }
    self.boxes = self.svg.append("g").attr("class", "boxes").attr("transform", "translate(" + (self.c.in_margin.left * 2) + ", " + self.c.in_margin.top + ")");
    return self.b = self.boxes.selectAll("g.box").data(dataset.data).enter().append("g").attr("class", "box").attr("width", self.c.width + self.c.in_margin.left + self.c.in_margin.right).attr("height", self.c.height + self.c.in_margin.bottom + self.c.in_margin.top).call(chart);
  };

  BoxChart.prototype.update = function(chart) {
    var getData, self;
    self = this;
    getData = function(d, i) {
      return self.c.dataset.data[i];
    };
    this.setScales(self.c.dataset);
    if (self.c.axis) {
      self.updateYAxis.call(this, self);
    }
    return this.b.datum(getData).call(chart);
  };

  BoxChart.prototype.extend = function(o, p) {
    var prop, _i, _len;
    for (_i = 0, _len = p.length; _i < _len; _i++) {
      prop = p[_i];
      o[prop] = p[prop];
    }
    return o;
  };

  BoxChart.prototype.setBoxWidth = function() {
    var boxes, inbox_width, inside_width, out_box_width;
    boxes = this.c.dataset.data.length;
    inside_width = this.c.width - this.c.out_margin.left - this.c.out_margin.right;
    out_box_width = Math.floor(inside_width / boxes) - this.c.stroke_width * 2 - 1;
    inbox_width = out_box_width - this.c.in_margin.left - this.c.in_margin.right;
    if (inbox_width < 0) {
      inbox_width = 1;
    }
    return this.box_width = {
      out: out_box_width,
      "in": inbox_width
    };
  };

  BoxChart.prototype.getVerticalDelta = function() {
    return this.c.out_margin.top + this.c.in_margin.top;
  };

  BoxChart.prototype.init = function(conf) {
    var box, c, self;
    self = this;
    c = {
      out_margin: {
        top: 10,
        right: 20,
        bottom: 20,
        left: 20
      },
      in_margin: {
        top: 10,
        right: 20,
        bottom: 20,
        left: 20
      },
      axis: true,
      sub_ticks: false,
      dataset: {
        data: [[0]],
        min: 0,
        max: 0
      },
      stroke_width: 1
    };
    c.height = 500;
    c.width = 600;
    if (conf) {
      this.c = this.extend(c, conf);
    } else {
      this.c = c;
    }
    this.setBoxWidth();
    box = function(g) {
      return g.each(function(d, i) {
        this.g = d3.select(this);
        self.setSpread.call(this, self, d, i);
        self.setMidspread.call(this, self, d, i);
        return self.setMedian.call(this, self, d, i);
      });
    };
    box.in_margin = function(value) {
      if (!arguments.length) {
        return self.c.in_margin;
      }
      self.c.in_margin = value;
      return box;
    };
    box.out_margin = function(value) {
      if (!arguments.length) {
        return self.c.out_margin;
      }
      self.c.out_margin = value;
      return box;
    };
    box.width = function(value) {
      if (!arguments.length) {
        return self.c.width;
      }
      self.c.width = value;
      return box;
    };
    box.height = function(value) {
      if (!arguments.length) {
        return self.c.height;
      }
      self.c.height = value;
      return box;
    };
    box.axis = function(value) {
      if (!arguments.length) {
        return self.c.axis;
      }
      self.c.axis = value;
      return box;
    };
    box.subTicks = function(value) {
      if (!arguments.length) {
        return self.c.sub_ticks;
      }
      self.c.sub_ticks = value;
      return box;
    };
    box.dataset = function(value) {
      if (!arguments.length) {
        return self.c.dataset;
      }
      self.c.dataset = value;
      self.setBoxWidth();
      return box;
    };
    box.stroke_width = function(value) {
      if (!arguments.length) {
        return self.c.stroke_width;
      }
      self.c.stroke_width = value;
      return box;
    };
    return box;
  };

  BoxChart.prototype.yAxisGenerator = function() {
    var sub_ticks;
    sub_ticks = this.c.sub_ticks ? 1 : 0;
    return d3.svg.axis().scale(this.y1).orient("left").tickSubdivide(sub_ticks).tickSize(6, 3, 0);
  };

  BoxChart.prototype.setYAxis = function(self) {
    var yAxis;
    yAxis = self.yAxisGenerator.call(self);
    return self.svg.append("g").attr("class", "y axis").call(yAxis).attr("transform", "translate(" + (self.c.out_margin.left * 1) + ",           " + (self.c.out_margin.top + self.c.in_margin.top) + ")");
  };

  BoxChart.prototype.updateYAxis = function(self) {
    var t, yAxis;
    yAxis = self.yAxisGenerator.call(self);
    t = self.svg.transition().duration(self.duration);
    return t.select(".y.axis").call(yAxis);
  };

  BoxChart.prototype.setXAxis = function(self) {};

  BoxChart.prototype.getXMidBoxPos = function(i) {
    var w;
    w = this.box_width.out;
    return Math.floor(this.c.out_margin.left + (w * (i + 1)) - (w / 2));
  };

  BoxChart.prototype.getXLeftBoxPos = function(i) {
    var w;
    w = this.box_width.out;
    return Math.floor(this.c.out_margin.left + (w * i) + this.c.in_margin.left);
  };

  BoxChart.prototype.getTopBoxPos = function() {};

  BoxChart.prototype.setSpread = function(self, d, i) {
    var delta, spread, x;
    delta = self.getVerticalDelta();
    x = self.getXMidBoxPos(i);
    spread = this.g.selectAll("line.spread").data([[d3.min(d), d3.max(d)]]);
    spread.enter().append("svg:line").attr("class", "spread").style("stroke-width", self.c.stroke_width).attr("x1", x).attr("y1", function(d) {
      return self.y0(d[0]) + delta;
    }).attr("x2", x).attr("y2", function(d) {
      return self.y0(d[1]) + delta;
    }).transition().duration(self.duration).attr("y1", function(d) {
      return self.y1(d[0]) + delta;
    }).attr("y2", function(d) {
      return self.y1(d[1]) + delta;
    });
    return spread.transition().duration(self.duration).attr("y1", function(d) {
      return self.y1(d[0]) + delta;
    }).attr("y2", function(d) {
      return self.y1(d[1]) + delta;
    });
  };

  BoxChart.prototype.setMidspread = function(self, d, i) {
    var delta, mid_data, midspread, x;
    delta = self.getVerticalDelta();
    x = self.getXLeftBoxPos(i);
    mid_data = [];
    mid_data.push(self.boxQuartiles(d)[0]);
    mid_data.push(self.boxQuartiles(d)[2]);
    midspread = this.g.selectAll("rect.midspread").data([mid_data]);
    midspread.enter().append("svg:rect").attr("class", "midspread").style("stroke-width", self.c.stroke_width).attr("x", x).attr("y", function(d) {
      return self.y0(d[1]) + delta;
    }).attr("width", self.box_width["in"]).attr("height", function(d) {
      return self.y0(d[0]) - self.y0(d[1]);
    }).transition().duration(self.duration).attr("y", function(d) {
      return self.y1(d[1]) + delta;
    }).attr("height", function(d) {
      return self.y1(d[0]) - self.y1(d[1]);
    });
    return midspread.transition(self.duration).duration(self.duration).attr("y", function(d) {
      return self.y1(d[1]) + delta;
    }).attr("height", function(d) {
      return self.y1(d[0]) - self.y1(d[1]);
    });
  };

  BoxChart.prototype.setMedian = function(self, d, i) {
    var delta, line, median, x1;
    delta = self.getVerticalDelta();
    x1 = self.getXLeftBoxPos(i);
    median = self.boxQuartiles(d)[1];
    line = this.g.selectAll("line.median").data([median]);
    line.enter().append("svg:line").attr("class", "median").style("stroke-width", self.c.stroke_width).attr("x1", x1).attr("y1", function(d) {
      return self.y0(d) + delta;
    }).attr("x2", x1 + self.box_width["in"]).attr("y2", function(d) {
      return self.y0(d) + delta;
    }).transition().duration(self.duration).attr("y1", function(d) {
      return self.y1(d) + delta;
    }).attr("y2", function(d) {
      return self.y1(d) + delta;
    });
    return line.transition().duration(self.duration).attr("y1", function(d) {
      return self.y1(d) + delta;
    }).attr("y2", function(d) {
      return self.y1(d) + delta;
    });
  };

  BoxChart.prototype.boxQuartiles = function(d) {
    return [d3.quantile(d, .25), d3.quantile(d, .5), d3.quantile(d, .75)];
  };

  return BoxChart;

})();
