<html>
<head>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="com.datapult.util.Constants"%>

<title>Team Datapult</title>
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
<br>
<font color="red">
<%= new String("Hello! Listed Below are the candidates that we are tracking currently") %>

</font>
<br><br>

<form method="post">

<%

try
{
Class.forName(Constants.MARIA_DRIVER);
String url=Constants.DBURL;
String username=Constants.USERNAME;
String password=Constants.PWD;
String query="select * from candidate";
Connection conn=DriverManager.getConnection(url,username,password);
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(query);
ResultSetMetaData rsmd = rs.getMetaData();
int columnCount = rsmd.getColumnCount();
int rowCount=0;
%>



<table border="2">
<tr bgcolor="cyan">
  <%for(int h=2;h<=columnCount-1;h++) {%>  
    <td><b> <font color="blue"><%=rsmd.getColumnName(h).toUpperCase() %></font></b></td>
  <%} %>

</tr>
<% 
while(rs.next())
{
rowCount++;
%>


    <tr>
  <%for(int j=2;j<=columnCount-1;j++) {%>  
    <td><%=rs.getString(j)==null?"":rs.getString(j).toUpperCase() %></td>
  <%} %>
    
    </tr>
    
        <%

}
%>
    </table>
    
<font color="green">Number of Rows Currently in Table: <%=rowCount %></font>
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
<br><br>
<font color="red">
<%= new String("The below infographic once complete will display candidate trends over time based on historical search data points that we have been tracking as part of this project") %>

</font>

<div class="row">
  <div class="column left2">
    <h3>Candidate Summary</h3>
    <p>Candidate Table SQL Query: </p>
    <p>SELECT first_name, last_name, delegate_count
       FROM candidate;</p>
    <img src="images/CandidateTable.png" width="100%"/>
  </div>
  <div class="column right2">
    <h3>Queries per Candidate Over Time</h3>
    <p>Visualization</p>
    <p>SQL Query: TBD</p>
    <img src="images/CandidateLineGraph.png" width = "100%"/>
  </div>
</div>
<div class="footer">
  <a href="references.html">References</a>
  <a href="contactus.html">Contact Us</a>
</div>
</form>
<center><embed type="text/html" src="footer.html"></center>
</body>
</html>
