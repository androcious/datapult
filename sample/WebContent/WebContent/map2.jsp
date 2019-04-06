        <head>
<!-- Plotly.js -->
        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
        </head>
        <body>
        <!-- Plotly chart will be drawn inside this DIV -->
        <div id="myDiv"></div>
        <script>
        <!-- Plotly.d3.csv('https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv', function(err, rows){
        	
        	Plotly.d3.csv("sample.csv", function(err, rows){
        	-->
        	
    
        		
        	
        	Plotly.d3.csv("sampleCandidate.csv", function(err, rows){
       
        	function unpack(rows, key) {
                return rows.map(function(row) { return row[key]; });
            }
        
       var data = [{
                    type: 'choropleth',
                    locationmode: 'USA-states',
                    locations: unpack(rows, 'code'),
                    z: unpack(rows, 'total exports'),
                    text: unpack(rows, 'state'),
                    zmin: 0,
                    zmax: 35,
                    colorscale: [
                      [0, 'rgb(242,240,247)'], [0.2, 'rgb(218,218,235)'],
                      [0.4, 'rgb(188,189,220)'], [0.6, 'rgb(158,154,200)'],
                      [0.8, 'rgb(117,107,177)'], [1, 'rgb(84,39,143)']
                    ],
                  colorbar: {
                    title: 'Delegates',
                    thickness: 0.8
                  },
                  marker: {
                    line:{
                      color: 'rgb(255,255,255)',
                      width: 2
                    }
                  }
                }];

      console.log(data.locations);
        var layout = {
                title: '2019 Democratic Primary leaders by state',
                geo:{
                  scope: 'usa',
                  showlakes: true,
                  lakecolor: 'rgb(255,255,255)'
                }
            };
            Plotly.plot(myDiv, data, layout, {showLink: false});
        })
        </script>
        <embed type="text/html" src="footer.html">
        </body>