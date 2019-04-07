<html>
<head>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="com.datapult.util.Constants"%>
<title>Sample Application JSP Page</title>
<link rel="stylesheet" href="style.css">
</head>
<body bgcolor=white>

<table border="0">
<tr>
<td>
<img src="images/democrat.jpg" height=200 width = 300>
</td>
<td>
<h1>2020 Democratic Primary Trends Predictor </h1>
<p>This Project is brought to you by team Datapult
</td>
<td><img src="images/DemocratRun2020.png" height="200" width="600"></td>


</tr>

<tr></tr>
</table>
<div class="topnav">
  <a href="index.jsp">Home</a>
  <a href="howto.html">How To</a>
  <a href="inspiration.html">Inspiration</a>
  <a href="candidateList.jsp">Candidate Summary</a>
  <a href="dataloader2.jsp">Country Summary</a>
  <a href="investigate.html">Investigate</a>
</div>

<table>
<tr><td><font color="blue"><b>Current Date:</b></font></td><td><p id="date"></p></td></tr>
</table>



<script type="text/javascript">
        n =  new Date();
y = n.getFullYear();
m = n.getMonth() + 1;
d = n.getDate();
document.getElementById("date").innerHTML = m + "/" + d + "/" + y;
    </script>
<br>
<font color="red">
<%= new String("Hello! The Current Projected winner is....") %>

</font>
<br><br>

<form method="post">

<%

try
{
Class.forName(Constants.MARIA_DRIVER);

String query="SELECT CONCAT(first_name,' ', last_name) FROM candidate WHERE delegate_count = (SELECT MAX(delegate_count) FROM candidate)";
Connection conn=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(query);

%>
<h1>
 <% 
while(rs.next())
{%>
    <p>The Current Projected WINNER IS::  <font color = red> <%=rs.getString(1).toUpperCase()%> </font></p>
 <% } %> 
</h1>


<p>To prove that they work, you can execute either of the following links:
<ul>
<li>To a <a href="candidateList.jsp">List of Candidates followed by the Datapult Team</a>.</li>
<li>To a <a href="index.jsp">Check Current Winner</a>.
<!-- <li>To a <a href="country.jsp">Check Overall Status of the Country </a>.
<li>To a <a href="map.jsp">List Choropleth Map page from static file</a>. -->
<li>To a <a href="map-final.jsp">List Choropleth Map page from Current data in database </a>.
<!-- <li>To a <a href="dataloader.jsp">Initialize data</a>.
<li>To a <a href="dataloader2.jsp">Initialize data download</a>. -->


</ul>


<hr>



<jsp:include page="map-embed.jsp"></jsp:include>
 <div class="column right">
   <!--  <img src="images/Winners.png" width= 400 height=200 /> -->
    <p><font color=blue>Current Winner SQL Query that computes the current projection from Collected Data Points is :</font></p>
    <p>SELECT first_name, last_name
       FROM candidate
       WHERE delegate_count = (SELECT MAX(delegate_count)
                               FROM candidate)</p>
    <h4>Select a state to see more information.</h4>
    <p>Map Data SQL Query:</p>
    <p>In order to make chloropleth map need state and winner.</p>
    <p>This will also give data for map popup when the state is selected.</p>
   
<!--     <img src="images/MapPlaceholder.png" width="100%"/> -->
  </div>
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

<p>The below links were introduced as part of Project Milestone 1</p>
<ul>
<li>To a <a href="state.jsp">List State Data JSP page</a>.</li>
<li>To a <a href="query.jsp">List Query Data JSP page</a>.</li>
</ul>
<center><embed type="text/html" src="footer.html"></center>
</form>
 
</body>
</html>



