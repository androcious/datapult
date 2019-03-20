<html>
<head>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.sql.Statement" %>
<title>Sample Application JSP Page</title>
</head>
<body bgcolor=white>

<table border="0">
<tr>
<td align=center>
<img src="images/tomcat.gif">
</td>
<td>
<h1>Hello! Welcome to the CS411 class team DATAPULT's page</h1>
This is the output of a JSP page that prints data from our database hosted on our designated VM
</td>
</tr>
</table>
<br>
<font color="red">
<%= new String("Hello! The below data shows what resides in our State table") %>

</font>
<br><br>

<form method="post">


<%

try
{
Class.forName("org.mariadb.jdbc.Driver");
String url="jdbc:mariadb://sp19-cs411-09.cs.illinois.edu:3306/gtep_test";
String username="sairao2";
String password="sairao2";
String query="select * from state";
Connection conn=DriverManager.getConnection(url,username,password);
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(query);
ResultSetMetaData rsmd = rs.getMetaData();
int columnCount = rsmd.getColumnCount();
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

</body>
</html>
