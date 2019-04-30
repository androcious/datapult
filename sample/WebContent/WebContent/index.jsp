<html>

<head>
  
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.4.0/dist/leaflet.css" integrity="sha512-puBpdR0798OZvTTbP4A8Ix/l+A4dHDD0DGqYW6RQ+9jxkRFclaxxQb/SJAWZfWAkuyeQUytO7+7N4QKrDh+drA==" crossorigin=""/>
  <link rel="stylesheet" href="style.css"/>

  <script src="https://unpkg.com/leaflet@1.4.0/dist/leaflet.js"></script>
  <script src="https://d3js.org/d3.v4.min.js"></script>
  <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

  <%@ page import="java.sql.Connection" %>
  <%@ page import="java.sql.DriverManager" %>
  <%@ page import="java.sql.ResultSet" %>
  <%@ page import="java.sql.ResultSetMetaData" %>
  <%@ page import="java.sql.Statement" %>
  <%@ page import="java.util.List" %>
  <%@ page import="java.util.ArrayList" %>
  <%@ page import="com.datapult.util.Constants"%>
  <%@ page import="java.io.FileWriter"%>
  <%@ page import="java.text.DateFormat"%>
  <%@ page import="java.text.SimpleDateFormat"%>

  <title>2020 Democratic Primary Trends Predictor</title>

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

  <div style="padding-left: 5px; padding-top: 10px">
    <% DateFormat df = new SimpleDateFormat("dd/MM/yyyy"); %>
    <b>Current Date:</b> <%= df.format(new java.util.Date()).toString()%>
  </div>

  <%

  try
  {
    Class.forName(Constants.MARIA_DRIVER);

    String query="SELECT CONCAT(first_name,' ', last_name), color FROM candidate WHERE delegate_count = (SELECT MAX(delegate_count) FROM candidate)";
    Connection conn=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
    Statement stmt=conn.createStatement();
    ResultSet rs=stmt.executeQuery(query);

  %>
  <h1>
  
  <% 
  while(rs.next())
  {%>
      <p>The Current Projected WINNER IS::  <font color=<%=rs.getString(2).toUpperCase()%>> <%=rs.getString(1).toUpperCase()%> </font></p>
   <% } %> 

  </h1>


  <%
    query="SELECT state_code as code, name as state, 'state' as category, cid, concat(first_name,' ', last_name) as flname, type_of_primary as typeprim, delegates_at_play as delegates, population FROM state LEFT JOIN (SELECT cid, first_name, last_name FROM candidate) c ON state.current_winner = c.cid";
    stmt=conn.createStatement();
    rs=stmt.executeQuery(query);
    ResultSetMetaData rsmd = rs.getMetaData();
    int columnCount = rsmd.getColumnCount();
    int rowCount=0;

    //String saveFile="/Users/sairao/take2/sample/WebContent/WINNER.csv";

    String saveFile="..\\WebContent\\WINNER.csv";

    FileWriter sb = new FileWriter(saveFile);
    StringBuilder fw = new StringBuilder();
    List<String> resultSetArray=new ArrayList<>();
    String temp="";

    for(int h=1;h<=columnCount;h++) {
      
      fw.append(rsmd.getColumnLabel(h).toLowerCase());
      if(h<columnCount)fw.append(",");
      } 
      fw.append("\n"); 
    while(rs.next())
    {
    rowCount++;

    for(int j=1;j<=columnCount;j++) {
      temp=rs.getString(j);
      fw.append(temp);
      if(j<columnCount)fw.append(",");
      } 
      fw.append("\n"); 

    }
    sb.write(fw.toString());

    sb.flush();
    sb.close();
    //System.out.println("Successfully Created Csv file.");

  
    String queryCand= "select first_name, last_name, delegate_count, color from candidate order by delegate_count desc";  
    Connection conn2=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
    Statement stmt2=conn2.createStatement();
    ResultSet rs2=stmt2.executeQuery(queryCand);
    ResultSetMetaData rsmd2 = rs2.getMetaData();
    int columnCount2 = rsmd2.getColumnCount();
    int rowCount2=0;

  %>

  <div class="row">

    <div class="column left">
      <table border="0" width="100%">
        <tr style="text-align:center; background: linear-gradient(#a3a3a3, #777777); font-weight: bold; color: #fff; font-size: 10pt">
          <td width="20%">Legend</td>
          <td width="25%">First Name</td>
          <td width="30%">Last Name</td>
          <td width="25%">Delegate Count</td>
        </tr>

        <% 
        while(rs2.next())
        {
        rowCount2++;
        %>

        <tr style="text-align: center">
          <td id="legend_color" style="background-color:<%=rs2.getString(4)==null?"#fff":rs2.getString(4)%>; opacity: 0.8">&nbsp;</td>
          <td id="firstname"><%=rs2.getString(1)==null?"":rs2.getString(1).substring(0, 1).toUpperCase() + rs2.getString(1).substring(1)%></td>
          <td id="lastname"><%=rs2.getString(2)==null?"":rs2.getString(2).substring(0, 1).toUpperCase() + rs2.getString(2).substring(1)%></td>
          <td id="delegate_count"><%=rs2.getString(3)==null?"":rs2.getString(3).substring(0, 1).toUpperCase() + rs2.getString(3).substring(1)%></td>        
        </tr>
      
        <%}%>
      </table>

    </div>

    <div class="column right">
      <div id="myDiv" style="margin-left: 2%"></div>
    </div>  

  </div>

  <script type="text/javascript" src="scripts/us-states2.js"></script>
  <script type="text/javascript" src="scripts/map-plotting.js"></script>  

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

  <div class="footer">
    <a href="references.html">References</a>
    <a href="contactus.html">Contact Us</a>
  </div>
 
</body>

</html>



