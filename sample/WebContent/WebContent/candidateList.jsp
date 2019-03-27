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
</form>
<center><embed type="text/html" src="footer.html"></center>
</body>
</html>
