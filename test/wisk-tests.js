buster.spec.expose(); // Make some functions global

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

var initWisk = function (Wisk) {
    var wisk = new Wisk("box_chart");//,
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

    return wisk;

};

var genRandomMargin = function () {
    return Math.floor((Math.random()*200)+1);
}

var genRandomDimensions = function () {
    var width = Math.floor((Math.random()*1000)+1);
    var height = Math.floor((Math.random()*800)+1);
    var margin = Math.floor((Math.random()*200)+1);
    var out_margin = {
        top: genRandomMargin(),
        right: genRandomMargin(), 
        bottom: genRandomMargin(), 
        left: genRandomMargin()
    };
    var in_margin = {
        top: genRandomMargin(),
        right: genRandomMargin(), 
        bottom: genRandomMargin(), 
        left: genRandomMargin()
    };
    return {
        w: width, 
        h: height, 
        im: in_margin, 
        om: out_margin};
};




describe("A module", function (run) {
  require(['wisk'], function (wisk) {
    run(function() {

      it("states the obvious", function () {

        var wisk = initWisk(Wisk),
        dataset = sample_data,
        number_of_boxes = dataset.lenght,
        chart;

        for (var i = 0; i < 100; i++) {
            var d = genRandomDimensions();
            chart = wisk.init()
              .out_margin({top: d.om.top, right: d.om.right, 
                bottom: d.om.bottom, left: d.om.left})
              .in_margin({top: d.im.top, right: d.im.right, 
                bottom: d.im.bottom, left: d.im.left})
              .height(d.h)
              .width(d.w)
              .dataset(dataset);

            //var box_width = wisk.setBoxWidth();
            var case_a = wisk.box_width.in > 0;
            var case_b = wisk.box_width.out > 0;
            //var case_c = box_width.in > 0;
            //var case_d = box_width.out > 0;
            console.log(
                "width: ", d.w, ", height: ", 
                d.h, ", inner_margin: ", d.im, ", outer_margin: ", d.om);
            console.log("wisk.box_width: ", wisk.box_width)
            expect(true).toEqual(case_a);  
            expect(true).toEqual(case_b);
            //expect(true).toEqual(case_b);
            //expect(true).toEqual(case_c);
            //expect(true).toEqual(case_d);
        }

        
        
      });
    });
  });
});