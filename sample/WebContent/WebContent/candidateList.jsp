<!DOCTYPE html>
<html>

<head>
  <title>Candidate Summary</title>
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="style2.css">
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
String query="SELECT first_name, last_name, delegate_count FROM candidate ORDER BY delegate_count DESC";
Connection conn=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(query);
ResultSetMetaData rsmd = rs.getMetaData();
int columnCount = rsmd.getColumnCount();
int rowCount=0;
%>



<body>

  <div class="divTable" style="width: 100%;">
    <div class="divTableBody">
      <div class="divTableRow">
        <div class="divTableCell" style="width: 20%; padding-left: 3px; padding-top: 3px;">
            <img src="images/democrat.jpg" height=200 width = 300>
        </div>
        <div class="divTableCell" style="width: 80%; text-align: left; 
              padding-bottom: 5px; padding-left: 4px; vertical-align: middle;">
          <h1>2020 Democratic Primary Trends Predictor </h1>
          <p>This Project is brought to you by team Datapult</p>
        </div>
      </div>
    </div>
  </div>

  <div id="header">
    <div></div>
    <div></div>
  </div>

  <div class="topnav">
    <a href="index.jsp">Home</a>
    <a href="howto.html">How To</a>
    <a href="inspiration.html">Inspiration</a>
    <a href="candidateList.jsp">Candidate Summary</a>
    <a href="dataloader2.jsp">Country Summary</a>
    
  </div>

  <div class="row">
    <div class="column left2">

      <h3 style="text-align: center; padding-right: 15%">Candidate Summary</h3>

      <table class="cstable">
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

    <div class="column right2" style="text-align: left;">
      <h3 style="text-align: center; padding-right: 20%">Estimated Delegates Won Over Time</h3>  
      <svg width="960" height="600"></svg>
      <script src="//d3js.org/d3.v4.min.js"></script>
      <script src="scripts/candidate_chart_color.js"></script>
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
