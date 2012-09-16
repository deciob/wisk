
define(["js/wisk"], function(Wisk) {
    buster.testCase("some test", {
        //"test that fails" : function() {
        //    assert.match(Wisk, {name: "wrong name"});
        //},
        "test that succeeds" : function() {
            console.log('jjjj', Wisk)
            assert.equals(true, true);
        }
    });
});

//require(['wisk'], function (Wisk) {




/*


//buster.spec.expose(); // Make some functions global

var assert = buster.assertions.assert;
var refute = buster.assertions.refute;

require.config({
  baseUrl: 'js/' //MUST be the same as the modules you're testing
});


//describe('single backbone dependency', function(run) {
//  require(['Widget'], function(widget) {
//    run(function() {
//      it('should load', function() {
//        expect(true).toEqual(true); // nothing but test execution
//      });
//    });
//  });
//});

//var initWisk = function (Wisk) {
//    var wisk = new Wisk("box_chart");//,
    //    dataset = sample_data,
    //    chart;

    //chart = wisk.init()
//
    //.out_margin({top: 150, right: 20, bottom: 20, left: 40})
    //.in_margin({top: 0, right: 10, bottom: 0, left: 10})
    //.axis(true)
    //.subTicks(true)
    //.height(400)
    //.width(600)
    //.dataset(dataset);
//
    //wisk.draw(chart);

//    return wisk;

//};

var genRandom = function (factor, base) {
    var factor = factor || 60;
    var base = base || 2;
    return Math.floor((Math.random()*factor)+base);
}

var genRandomDimensions = function (boxes) {
    //var width = Math.floor((Math.random()*1000)+1);
    var height = genRandom(800, 200);
    var out_margin = {
        top: genRandom(),
        right: genRandom(), 
        bottom: genRandom(), 
        left: genRandom()
    };
    var in_margin = {
        top: genRandom(),
        right: genRandom(), 
        bottom: genRandom(), 
        left: genRandom()
    };
    // width must depend on both the number of boxes and the margin values
    var base = out_margin.right + out_margin.left + (in_margin.left * boxes) +
      (in_margin.right * boxes) + 100;
    width = genRandom(1000, base);
    return {
        w: width, 
        h: height, 
        im: in_margin, 
        om: out_margin};
};



buster.testCase("Checking dimensions", {
    setUp: function () {
        console.log(1)
        var self = this;
        define(['wisk'], function (Wisk) {
            console.log(2)
            self.wisk = new Wisk("box_chart");
            // sample_data is a global variable from 'examples/data/sample_data.js'
            self.boxes = sample_data.data.length;
            self.chart = self.wisk.init();
            console.log(3);
        });
    },
 
    "states the obvious 1": function () {
         assert.equals(true, true);
    },

    "states the obvious": function () {
        define(['wisk'], function (Wisk) {
        console.log(4);
        for (var i = 0; i < 100; i++) {
            var d = genRandomDimensions(self.boxes);
            this.chart
              .out_margin({top: d.om.top, right: d.om.right, 
                bottom: d.om.bottom, left: d.om.left})
              .in_margin({top: d.im.top, right: d.im.right, 
                bottom: d.im.bottom, left: d.im.left})
              .height(d.h)
              .width(d.w)
              .dataset(sample_data);
            //assert.equals(true, this.wisk.box_width.in > 0);
            //console.log(this.wisk.box_width.out, this.wisk.box_width.out > 0);
            //assert.equals(true, this.wisk.box_width.out > 0);
            assert.equals(true, true);
            
        }
        //assert.equals({ name: "Professor Chaos" }, { name: "Professor Chaos" }); // Passes
        //assert.equals({ name: "Professor Chaos" }, { name: "Dr Evil" });         // Fails
        assert.equals.message = "${0} expected to be equal to ${1}";
    });
    }
});



describe("A module 3", function (run) {
  console.log(5);
  require(['wisk'], function (Wisk) {
    console.log(6);
    run(function() {

      it("states the obvious", function () {

        console.log(7);
        assert.equals(true, true);
        
      });
    });
  });
});

*/
