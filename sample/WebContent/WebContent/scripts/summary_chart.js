// REF: https://gist.github.com/mbostock/3884955
// AUTHOR: mbostock/.block

var svg = d3.select("svg"),
      margin = {top: 20, right: 80, bottom: 30, left: 50},
      width = svg.attr("width") - margin.left - margin.right,
      height = svg.attr("height") - margin.top - margin.bottom,
      g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var parseTime = d3.timeParse("%Y%m%d");

var x = d3.scaleTime().range([0, width]),
    y = d3.scaleLinear().range([height, 0]),
    color = d3.scaleOrdinal(d3.schemeCategory20);

var line = d3.line()
    .curve(d3.curveBasis)
    .x(function(d) { return x(d.date); })
    .y(function(d) { return y(d.delegate_count); });

d3.tsv("data/candidate_summary.tsv", type, function(error, data) {
  if (error) throw error;

var candidates = data.columns.slice(1).map(function(id) {
  return {
    id: id,
    values: data.map(function(d) {
      return {date: d.date, delegate_count: d[id]};
    })
  };
});

x.domain(d3.extent(data, function(d) { return d.date; }));

y.domain([
  d3.min(candidates, function(c) { return d3.min(c.values, function(d) { return d.delegate_count; }); }),
  d3.max(candidates, function(c) { return d3.max(c.values, function(d) { return d.delegate_count; }); })
]);

color.domain(candidates.map(function(c) { return c.id; }));

g.append("g")
    .attr("class", "axis axis--x")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x));

g.append("g")
    .attr("class", "axis axis--y")
    .call(d3.axisLeft(y))
  .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", "0.71em")
    .attr("fill", "#000")
    .text("delegate_count");

var city = g.selectAll(".city")
  .data(candidates)
  .enter().append("g")
    .attr("class", "city");

// Define the div for the tooltip
var div = d3.select("body").append("div") 
    .attr("class", "tooltip")       
    .style("opacity", 0);

city.append("path")
    .attr("class", "line")
    .attr("d", function(d) { return line(d.values); })
    .style("stroke", function(d) { return candidateColor(d.id); })
    .on("mouseover", function(d){
      d3.select(this).classed('lineon', true);
      div.transition()    
        .duration(200)    
        .style("opacity", .9);    
      div.html(d.id)  
        .style("left", (d3.event.pageX) + "px")   
        .style("top", (d3.event.pageY - 28) + "px");

    })
    .on("mouseout", function(d){
      d3.select(this).classed('lineon', false);
      div.transition()    
                .duration(500)    
                .style("opacity", 0); 
    });

city.append("text")
    .datum(function(d) { return {id: d.id, value: d.values[d.values.length - 1]}; })
    .attr("transform", function(d) { return "translate(" + x(d.value.date) + "," + y(d.value.delegate_count) + ")"; })
    .attr("x", 3)
    .attr("dy", "0.35em")
    .style("font", "10px sans-serif")
    .text(function(d) { return d.id; });
});

function type(d, _, columns) {
  d.date = parseTime(d.date);
  for (var i = 1, n = columns.length, c; i < n; ++i) d[c = columns[i]] = +d[c];
  return d;
}
