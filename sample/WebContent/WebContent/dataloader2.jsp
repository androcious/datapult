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
<%@ page import="java.io.FileWriter"%>
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
<br>
<font color="red">
<%= new String("Hello! The Current Status in the US according to trends observed by Google searches/trends is....") %>

</font>
<br><br>

<form method="post">

<%

try
{
Class.forName(Constants.MARIA_DRIVER);
String query="SELECT state_code as code, name as state, 'state' as category, cid, first_name as fname, last_name as lname, type_of_primary as typeprim, delegates_at_play as delegates, population FROM state LEFT JOIN (SELECT cid, first_name, last_name FROM candidate) c ON state.current_winner = c.cid";
Connection conn=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(query);
ResultSetMetaData rsmd = rs.getMetaData();
int columnCount = rsmd.getColumnCount();
int rowCount=0;

String saveFile="/Users/sairao/take2/sample/WebContent/WINNER.csv";

FileWriter sb = new FileWriter(saveFile);
StringBuilder fw = new StringBuilder();
List<String> resultSetArray=new ArrayList<>();
String temp="";
%>



<table border="2">
<tr bgcolor="cyan">
  <%for(int h=1;h<=columnCount;h++) {
  
  fw.append(rsmd.getColumnLabel(h).toLowerCase());
  if(h<columnCount)fw.append(",");
  %>  
    <td><b> <font color="blue"><%=rsmd.getColumnLabel(h).toUpperCase()%></font></b></td>
  <%} 
  fw.append("\n");%>

</tr>
<% 
while(rs.next())
{
rowCount++;


%>


    <tr>
  <%for(int j=1;j<=columnCount;j++) {
  temp=rs.getString(j);
  fw.append(temp);
  if(j<columnCount)fw.append(",");
  %>  
  <td>
  <%=temp==null?"":temp.toUpperCase()%>
    </td>
  <%} 
  fw.append("\n"); 
  %>
    
    </tr>
    
        <%
        
}
sb.write(fw.toString());
sb.flush();
sb.close();
System.out.println("Successfully Created Csv file.");
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



