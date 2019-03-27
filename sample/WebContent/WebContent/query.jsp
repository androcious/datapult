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
<%= new String("Hello! The below data shows what resides in our Query table") %>

</font>
<br><br>

<form method="post">

<%

try
{
Class.forName(Constants.MARIA_DRIVER);

String query="select * from query";
Connection conn=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(query);
ResultSetMetaData rsmd = rs.getMetaData();
int columnCount = rsmd.getColumnCount();
int rowCount=0;
%>



<table border="2">
<tr>
  <%for(int h=1;h<=columnCount;h++) {%>  
    <td><%=rsmd.getColumnName(h) %></td>
  <%} %>

</tr>
<% 
while(rs.next())
{
rowCount++;
%>


    <tr>
  <%for(int j=1;j<=columnCount;j++) {%>  
    <td><%=rs.getString(j) %></td>
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
<center><embed type="text/html" src="footer.html"></center>
</form>
 
</body>
</html>
