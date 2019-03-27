<html>
<head>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="com.datapult.util.Constants"%>
<title>Sample Application JSP Page</title>
</head>
<body bgcolor=white>

<table border="0">
<tr>
<td align=center>
<img src="images/democrat.jpg" height=200 width = 300>
</td>
<td>
<h1>Hello! Welcome to the CS411 class team DATAPULT's page</h1>
This is the output of a JSP page that prints data from our database hosted on our designated VM
</td>
</tr>
</table>
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
    <p>THE WINNER IS::<%=rs.getString(1)%> </p>
 <% } %> 
</h1>
 <div class="column right">
    <img src="images/Winners.png" width= 400 height=200 />
    <p>Current Winner SQL Query:</p>
    <p>SELECT first_name, last_name
       FROM candidate
       WHERE delegate_count = (SELECT MAX(delegate_count)
                               FROM candidate)</p>
    <h4>Select a state to see more information.</h4>
    <p>Map Data SQL Query:</p>
    <p>In order to make chloropleth map need state and winner.</p>
    <p>This will also give data for map popup when the state is selected.</p>
   
    <img src="images/MapPlaceholder.png" width="100%"/>
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
<center><embed type="text/html" src="footer.html"></center>
</form>
 
</body>
</html>



