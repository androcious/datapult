<!DOCTYPE html>
<html>

<head>
  <title>Candidate Summary</title>
  <link rel="stylesheet" type="text/css" href="./style.css">
  <link rel="stylesheet" type="text/css" href="./style2.css">
</head>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="com.datapult.util.Constants" %>

<%

try
{
Class.forName("org.mariadb.jdbc.Driver");
String query="SELECT first_name, last_name, delegate_count FROM candidate";
Connection conn=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(query);
ResultSetMetaData rsmd = rs.getMetaData();
int columnCount = rsmd.getColumnCount();
int rowCount=0;
%>



<body>

<div class="header">
  <h1>2020 Democratic Primary Google Trends</h1>
</div>

<div class="topnav">
  <a href="index.html">Home</a>
  <a href="howto.html">How To</a>
  <a href="inspiration.html">Inspiration</a>
  <a href="candidates.html">Candidate Summary</a>
  <a href="country.html">Country Summary</a>
  <a href="investigate.html">Investigate</a>
</div>

<div class="row">
  <div class="column left2">

    <h3>Candidate Summary</h3>

    <table>
      <thead>
        <tr>
          <th>No.</th>
          <th>First Name</th>
          <th>Last Name</th>
          <th>Estimated Delegate Count</th>
        </tr>
      </thead>

      <tbody>
      <% 
        while(rs.next())
        {
          rowCount++; %>
          <tr>
            <td><%=rowCount%></td>
          <% for(int j=1; j<=columnCount; j++) { %>
            <td><%=rs.getString(j)==null?"":rs.getString(j).substring(0, 1).toUpperCase() + rs.getString(j).substring(1)%></td>
          <%}%>
          </tr>
        <%}
        
      %>
     </tbody>
    </table>

  </div>

  <div class="column right2">
    <h3>Queries per Candidate Over Time</h3>
    <p>Visualization</p>
    <p>SQL Query: TBD</p>

    
    <svg width="960" height="500"></svg>
    <script src="//d3js.org/d3.v4.min.js"></script>
    <script src="scripts/summary_chart.js"></script>

  </div>
</div>

<div class="footer">
  <a href="references.html">References</a>
  <a href="contactus.html">Contact Us</a>
</div>

<%
    rs.close();
    stmt.close();
    conn.close();
    }
catch(Exception e)
{
    e.printStackTrace();
    }

%>

</body>
</html>
