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
<body>

<div class="header">
  <h1>2020 Democratic Primary Google Trends</h1>
  <h1>Hello! Welcome to the CS411 class team DATAPULT's page</h1>
This is the output of a JSP page that prints data from our database hosted on our designated VM

</div>

<div class="topnav">
  <a href="index.jsp">Home</a>
  <a href="howto.html">How To</a>
  <a href="inspiration.html">Inspiration</a>
  <a href="candidateList.jsp">Candidate Summary</a>
  <a href="country.html">Country Summary</a>
  <a href="investigate.html">Investigate</a>
</div>

<br>
<font color="red">
<%= new String("Hello! The below data shows what resides in our State table") %>

</font>
<br><br>

<form method="post">


<%
//Define the schema for the page in env variable
String env = Constants.TEST_SCHEMA;
		

try
{
Class.forName(Constants.MARIA_DRIVER);


String username=Constants.USERNAME;
String password=Constants.PWD; 
System.out.println(" UID is datapult_app");
String query="select * from state";
Connection conn=DriverManager.getConnection(Constants.DBURL,username,password);
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
</form>
<center><embed type="text/html" src="footer.html"></center>
</body>
</html>
