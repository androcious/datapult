<html>
<head>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
String filename="sample2.csv";
String query="SELECT state_code, name, 'state', cid, first_name, last_name, type_of_primary, delegates_at_play, population FROM state LEFT JOIN (SELECT cid, first_name, last_name FROM candidate) c ON state.current_winner = c.cid";
Connection conn=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(query);
ResultSetMetaData rsmd = rs.getMetaData();
int columnCount = rsmd.getColumnCount();
int rowCount=0;
List<String> resultSetArray=new ArrayList<>();
String temp="";
%>



<table border="2">
<tr bgcolor="cyan">
  <%for(int h=1;h<=columnCount;h++) {%>  
    <td><b> <font color="blue"><%=rsmd.getColumnName(h).toUpperCase() %></font></b></td>
  <%} %>

</tr>
<% 
while(rs.next())
{
rowCount++;
StringBuilder sb = new StringBuilder();

%>


    <tr>
  <%for(int j=1;j<=columnCount;j++) {
  temp=rs.getString(j);%>  
  <td>
  <%=temp==null?"":temp.toUpperCase()%>
    </td>
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
 
</body>
</html>



