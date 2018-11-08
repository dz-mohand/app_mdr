<!--all credit goes to Mike Bostock http://bl.ocks.org/4063318-->
  <!--only subtle changes made to accept the data from R and Shiny-->
  
  
  <style>
  
  body {
    font: 10px sans-serif;
    shape-rendering: crispEdges;
  }

.day {
  fill: #fff;
    stroke: #ccc;
}

.month {
  fill: none;
  stroke: #000;
    stroke-width: 2px;
}

.RdYlGn .q0-11{fill:rgb(165,0,38)}
.RdYlGn .q1-11{fill:rgb(215,48,39)}
.RdYlGn .q2-11{fill:rgb(244,109,67)}
.RdYlGn .q3-11{fill:rgb(253,174,97)}
.RdYlGn .q4-11{fill:rgb(254,224,139)}
.RdYlGn .q5-11{fill:rgb(255,255,191)}
.RdYlGn .q6-11{fill:rgb(217,239,139)}
.RdYlGn .q7-11{fill:rgb(166,217,106)}
.RdYlGn .q8-11{fill:rgb(102,189,99)}
.RdYlGn .q9-11{fill:rgb(26,152,80)}
.RdYlGn .q10-11{fill:rgb(0,104,55)}

</style>
  
  <script src="http://d3js.org/d3.v3.min.js"></script>
  <script>
  
  
  var networkOutputBinding = new Shiny.OutputBinding();
$.extend(networkOutputBinding, {
  find: function(scope) {
    return $(scope).find('.shiny-network-output');
  },
  renderValue: function(el, data) {
    //remove the old graph
    var svg = d3.select(el).selectAll("svg");
    
    svg.remove();
    
    $(el).html("");      
    
    
    
    var width = 960,
    height = 136,
    cellSize = 17; // cell size
    
    var day = d3.time.format("%w"),
    week = d3.time.format("%U"),
    percent = d3.format(".1%"),
    format = d3.time.format("%Y-%m-%d");
    
    var color = d3.scale.quantize()
    .domain([-.05, .05])
    .range(d3.range(11).map(function(d) { return "q" + d + "-11"; }));
    
    //append a new one
    svg = d3.select(el).selectAll("svg")  
    .data(d3.range(2007, 2013))
    .enter().append("svg")
    .attr("width", width)
    .attr("height", height)
    .attr("class", "RdYlGn")
    .append("g")
    .attr("transform", "translate(" + ((width - cellSize * 53) / 2) + "," + (height - cellSize * 7 - 1) + ")");
    
    svg.append("text")
    .attr("transform", "translate(-6," + cellSize * 3.5 + ")rotate(-90)")
    .style("text-anchor", "middle")
    .text(function(d) { return d; });
    
    var rect = svg.selectAll(".day")
    .data(function(d) { return d3.time.days(new Date(d, 0, 1), new Date(d + 1, 0, 1)); })
    .enter().append("rect")
    .attr("class", "day")
    .attr("width", cellSize)
    .attr("height", cellSize)
    .attr("x", function(d) { return week(d) * cellSize; })
    .attr("y", function(d) { return day(d) * cellSize; })
    .datum(format);
    
    rect.append("title")
    .text(function(d) { return d; });
    
    svg.selectAll(".month")
    .data(function(d) { return d3.time.months(new Date(d, 0, 1), new Date(d + 1, 0, 1)); })
    .enter().append("path")
    .attr("class", "month")
    .attr("d", monthPath);
    
    //d3.csv("dji.csv", function(error, csv) {
      var rdata = d3.nest()
      .key(function(d) { return d.Date; })
      .rollup(function(d) { return (d[0].Close - d[0].Open) / d[0].Open; })
      .map(data);
      
      rect.filter(function(d) { return d in rdata; })
      .attr("class", function(d) { return "day " + color(rdata[d]); })
      .select("title")
      .text(function(d) { return d + ": " + percent(rdata[d]); });
      //});
    
    function monthPath(t0) {
      var t1 = new Date(t0.getFullYear(), t0.getMonth() + 1, 0),
      d0 = +day(t0), w0 = +week(t0),
      d1 = +day(t1), w1 = +week(t1);
      return "M" + (w0 + 1) * cellSize + "," + d0 * cellSize
      + "H" + w0 * cellSize + "V" + 7 * cellSize
      + "H" + w1 * cellSize + "V" + (d1 + 1) * cellSize
      + "H" + (w1 + 1) * cellSize + "V" + 0
      + "H" + (w0 + 1) * cellSize + "Z";
    }
    
    d3.select(self.frameElement).style("height", "2910px");
    
    
