    <html> 
        <head>
<!-- Plotly.js -->
        <script src="https://d3js.org/d3.v4.min.js"></script>
        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.4.0/dist/leaflet.css" integrity="sha512-puBpdR0798OZvTTbP4A8Ix/l+A4dHDD0DGqYW6RQ+9jxkRFclaxxQb/SJAWZfWAkuyeQUytO7+7N4QKrDh+drA==" crossorigin=""/>
        <link rel="stylesheet" href="style.css"/>
        <script src="https://unpkg.com/leaflet@1.4.0/dist/leaflet.js"></script>

        <%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.datapult.util.Constants"%>
<%@ page import="java.io.FileWriter"%>
        <title>Team Datapult</title>

</head>
<body bgcolor=white>

        <!-- Plotly chart will be drawn inside this DIV -->
        
        <form method="post">

<%

try
{
Class.forName(Constants.MARIA_DRIVER);
String query="SELECT state_code as code, name as state, 'state' as category, cid, concat(first_name,' ', last_name) as flname, type_of_primary as typeprim, delegates_at_play as delegates, population FROM state LEFT JOIN (SELECT cid, first_name, last_name FROM candidate) c ON state.current_winner = c.cid";
Connection conn=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(query);
ResultSetMetaData rsmd = rs.getMetaData();
int columnCount = rsmd.getColumnCount();
int rowCount=0;

//String saveFile="/Users/sairao/take2/sample/WebContent/WINNER.csv";

String saveFile="..\\WebContent\\WINNER.csv";

FileWriter sb = new FileWriter(saveFile);
StringBuilder fw = new StringBuilder();
List<String> resultSetArray=new ArrayList<>();
String temp="";

for(int h=1;h<=columnCount;h++) {
  
  fw.append(rsmd.getColumnLabel(h).toLowerCase());
  if(h<columnCount)fw.append(",");
  } 
  fw.append("\n"); 
while(rs.next())
{
rowCount++;

for(int j=1;j<=columnCount;j++) {
  temp=rs.getString(j);
  fw.append(temp);
  if(j<columnCount)fw.append(",");
  } 
  fw.append("\n"); 

}
sb.write(fw.toString());

sb.flush();
sb.close();
System.out.println("Successfully Created Csv file.");
%>
   
    
<%-- <font color="green">Number of Rows Currently in Table: <%=rowCount %></font> --%>
    <%
    rs.close();
    stmt.close();
    conn.close();
    }
catch(Exception e)
{
    e.printStackTrace();
    }



String queryCand= "select first_name, last_name, delegate_count, color from candidate ";  
Connection conn2=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
Statement stmt2=conn2.createStatement();
ResultSet rs2=stmt2.executeQuery(queryCand);
ResultSetMetaData rsmd2 = rs2.getMetaData();
int columnCount2 = rsmd2.getColumnCount();
int rowCount2=0;



%>



</form>
   
   
   
        
        <div id="myDiv" ></div>
        
        
      <script type="text/javascript" src="scripts/us-states2.js"></script>

      <script type="text/javascript">

        var map = L.map('myDiv').setView([37.8, -96], 4);

        L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
          maxZoom: 18,
          attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> ' +
            'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
          id: 'mapbox.light'
        }).addTo(map);


        // control that shows state info on hover
        var info = L.control();

        info.onAdd = function (map) {
          this._div = L.DomUtil.create('div', 'info');
          this.update(); 
          return this._div;
        };

        info.update = function (feat) {
          this._div.innerHTML = (feat ?
            '<b>' + feat.properties.name + '</br>' +
            'Leader: ' + feat.flname + '</br>' +
            'Delegates at play: ' + feat.delegates + '</br>' +
            'Type of primary: ' + feat.typeprim + '</br>' +
            'Population: ' + feat.population
            : 'Hover over a state');
        };

        info.addTo(map);

        function style(feature) {
          return {
            weight: 2,
            opacity: 1,
            color: 'white',
            dashArray: '3',
            fillOpacity: 0.7,
            fillColor: getColor(feature.cid)
          };
        }

        function highlightFeature(e) {
          var layer = e.target;

          layer.setStyle({
            weight: 5,
            color: '#666',
            dashArray: '',
            fillOpacity: 0.7
          });

          if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
            layer.bringToFront();
          }

          info.update(layer.feature);
        }

        var geojson;

        function resetHighlight(e) {
          geojson.resetStyle(e.target);
          info.update();
        }

        function zoomToFeature(e) {
          map.fitBounds(e.target.getBounds());
        }

        function onEachFeature(feature, layer) {
          layer.on({
            mouseover: highlightFeature,
            mouseout: resetHighlight,
            click: zoomToFeature
          });
        }

        geojson = L.geoJson(statesData, {
          style: style,
          onEachFeature: onEachFeature
        }).addTo(map);

      </script>

        
        <table border="0">
<tr bgcolor="cyan">
  <%for(int h=1;h<columnCount2;h++) {%>  
    <td><b> <font color="blue"><%=rsmd2.getColumnName(h).toUpperCase() %></font></b></td>
  <%} %>

</tr>
<% 
while(rs2.next())
{
rowCount2++;
%>


    <tr>
  <%for(int j=1;j<columnCount2;j++) {
     if(j==columnCount2){
    	 %>  
    	    <td><font color="<%=rs2.getString(j)%>"><%=rs2.getString(j)==null?"":rs2.getString(j)  %></font></td>
    	  <%
     }else{
  %>  
  
    <td><font color="<%=rs2.getString(columnCount2)%>"><%=rs2.getString(j)==null?"":rs2.getString(j).toUpperCase()  %></font></td>
  <%}
     } %>
    
    </tr>
    
        <%

}
%>
    </table>
        </body>
        </html>  