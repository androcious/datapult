    <html> 
        <head>
<!-- Plotly.js -->
        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
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
        
        
        <script>
     
        	
    
        		
        	
        	Plotly.d3.csv("WINNER.csv", function(err, rows){
       
        	function unpack(rows, key) {
                return rows.map(function(row) { return row[key]; });
            }
        
       var data = [{
                    type: 'choropleth',
                    locationmode: 'USA-states',
                    locations: unpack(rows, 'code'),
                    z: unpack(rows, 'delegates'),
                    text: unpack(rows, 'flname'),
                    zmin: 0,
                    zmax: 100,
                    colorscale: [
                      [0, 'rgb(242,240,247)'], [0.2, 'rgb(218,218,235)'],
                      [0.4, 'rgb(188,189,220)'], [0.6, 'rgb(158,154,200)'],
                      [0.8, 'rgb(117,107,177)'], [1, 'rgb(84,39,143)']
                    ],
                  colorbar: {
                    title: 'Delegates',
                    thickness: 10
                  },
                  marker: {
                    line:{
                      color: 'rgb(255,255,255)',
                      width: 5
                    }
                  }
                }];

      console.log(data.locations);
        var layout = {
                title: '2019 Democratic Primary leaders by state',
                geo:{
                  scope: 'usa',
                  showlakes: true,
                  lakecolor: 'rgb(100,255,255)'
                }
            };
            Plotly.plot(myDiv, data, layout, {showLink: true});
        });
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