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
<title>Team Datapult - Country Summary</title>
<link rel="stylesheet" href="style.css">
</head>
<body bgcolor=white>


  <table border="0" >
    <tr>
      <td>
        <img src="images/democrat.jpg" height=100 width = 150>
      </td>
      <td>
        <h1>2020 Democratic Primary Trends Predictor </h1>
        <p>This Project is brought to you by team Datapult
      </td>
        <td>&nbsp;&nbsp;</td>
        <td><img src="images/DemocratRun2020.png" height="100" width="300"></td>
    </tr>
    <tr></tr>
  </table>

<div class="topnav">
  <a href="index.jsp">Home</a>
  <a href="howto.html">How To</a>
  <a href="inspiration.html">Inspiration</a>
  <a href="candidateList.jsp">Candidate Summary</a>
  <a href="dataloader2.jsp">Country Summary</a>
</div>
<br>
<font>
<%= new String("<b>Hello!</b> The Current Status in the US according to trends observed by Google searches/trends is....") %>

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

String saveFile="..\\WebContent\\WINNER.csv";

FileWriter sb = new FileWriter(saveFile);
StringBuilder fw = new StringBuilder();
List<String> resultSetArray=new ArrayList<>();
String temp="";
%>


<div style="height: 500; scroll-behavior: smooth;overflow: scroll;">
<table>
  <tr style="text-align:center; background: linear-gradient(#a3a3a3, #777777); font-weight: bold; color: #fff; font-size: 10pt">
  <%for(int h=1;h<=columnCount;h++) {
  
  fw.append(rsmd.getColumnLabel(h).toLowerCase());
  if(h<columnCount)fw.append(",");
  %>  
    <td><%=rsmd.getColumnLabel(h)==null?"":rsmd.getColumnLabel(h).substring(0, 1).toUpperCase() + rsmd.getColumnLabel(h).substring(1)%></td>
  <%} 
  fw.append("\n");%>

  </tr>
<% 
while(rs.next())
{
rowCount++;


%>


    <tr style="text-align: center">
  <%for(int j=1;j<=columnCount;j++) {
  temp=rs.getString(j);
  fw.append(temp);
  if(j<columnCount)fw.append(",");
  %>  
  <td>
  <%=temp==null?"":temp.substring(0, 1).toUpperCase() + temp.substring(1)%>
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

</div>

<br>
    
Number of Rows Currently in Table: <%=rowCount %>
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

  <div class="footer">
    <a href="references.html">References</a>
    <a href="contactus.html">Contact Us</a>
  </div>
 
</body>
</html>



