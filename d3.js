var colors = {p0: '#8dd3c7', p1: '#ffffb3', p2: '#bebada', p3: '#fb8072',
              p4: '#80b1d3', p5: '#fdb462', p6: '#b3de69', p7: '#fccde5',
              p8: '#d9d9d9', p9: 'bc80bd'}

var svg = d3.select("svg");

var path = d3.geoPath();

d3.json("https://unpkg.com/us-atlas@1/us/10m.json", function(error, us) {
  if (error) throw error;

  svg.append("path")
      .attr("stroke-width", 0.7)
      .attr("d", path(topojson.mesh(us, us.objects.states, function(a, b) {
        return a !== b; })));

  svg.append("path")
      .attr("d", path(topojson.feature(us, us.objects.nation)));
});
