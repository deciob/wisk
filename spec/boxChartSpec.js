describe("Box Chart", function() {
    
    var box_chart,
        dataset,
        chart;
    
    beforeEach(function() {
        box_chart = new BoxChart("box_chart");
        dataset = sample_data;
        chart = box_chart.init();
    });
    
    it("does something", function() {
    
        expect(box_chart.c.height).toEqual(500);
    });
});
