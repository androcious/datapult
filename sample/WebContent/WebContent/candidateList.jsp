<!DOCTYPE html>
<html>

<head>
  <title>Team Datapult - Candidate Summary</title>
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="style2.css">
</head>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="com.datapult.util.Constants" %>

<%

try
{
Class.forName("org.mariadb.jdbc.Driver");
String query="SELECT first_name, last_name, delegate_count,color FROM candidate ORDER BY delegate_count DESC";
Connection conn=DriverManager.getConnection(Constants.DBURL,Constants.USERNAME,Constants.PWD);
Statement stmt=conn.createStatement();
ResultSet rs=stmt.executeQuery(query);
ResultSetMetaData rsmd = rs.getMetaData();
int columnCount = rsmd.getColumnCount();
int rowCount=0;
%>



<body>

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
    
  </table>

  <div class="topnav">
    <a href="index.jsp">Home</a>
    <a href="howto.html">How To</a>
    <a href="inspiration.html">Inspiration</a>
    <a href="candidateList.jsp">Candidate Summary</a>
    <a href="dataloader2.jsp">Country Summary</a>
    
  </div>

  <div class="row">
    <div class="column left">

      <h3 style="text-align: center; padding-right: 15%">Candidate Summary</h3>

      <table>
        <thead>
          <tr style="text-align:center; background: linear-gradient(#a3a3a3, #777777); font-weight: bold; color: #fff; font-size: 10pt">
            <th width="15%">No.</th>
            <th width="20%">First Name</th>
            <th width="20%">Last Name</th>
            <th width="45%">Estimated Delegate Count</th>
          </tr>
        </thead>

        <tbody>
        <% 
          while(rs.next())
          {
            rowCount++; %>
            <tr style="text-align: center">
              <td id="rownumber<%=rowCount%>" style="background: <%=rs.getString(4)==null?"#fff":rs.getString(4)%>;opacity: 0.8;"><%=rowCount%></td>
              <td id="firstname"><%=rs.getString(1)==null?"":rs.getString(1).substring(0, 1).toUpperCase() + rs.getString(1).substring(1)%></td>
              <td id="lastname"><%=rs.getString(2)==null?"":rs.getString(2).substring(0, 1).toUpperCase() + rs.getString(2).substring(1)%></td>
              <td id="delegate_count"><%=rs.getString(3)==null?"":rs.getString(3).substring(0, 1).toUpperCase() + rs.getString(3).substring(1)%></td>        
            </tr>
          <%}
          
        %>
       </tbody>
      </table>

    <!-- Beautification: convert foreground color depends on bgColor -->
    <script type="text/javascript">

      for(i=1;i<=<%=rowCount%>;i++){
        var bgColor = document.getElementById("rownumber"+i).style.background;
        if (bgColor !== null && bgColor !== "undefined") {
          document.getElementById("rownumber"+i).style.color = getContrastYIQ(bgColor);        
        }
      }
      
      function getContrastYIQ(RGB){
        if (RGB === 'undefined') return 'black';
        var rgbArray = RGB.split(',');        
        var r = (rgbArray[0]).replace(/\D/g, "");
        var g = (rgbArray[1]).replace(/\D/g, "");
        var b = (rgbArray[2]).replace(/\D/g, "");
        var yiq = ((r*299)+(g*587)+(b*114))/1000;
        return (yiq >= 128) ? 'black' : 'white';
      }
    </script>


    </div>

    <div class="column right2" style="text-align: left;">
      <h3 style="text-align: center; padding-right: 20%">Estimated Delegates Won Over Time</h3>  
      <svg width="800" height="500"></svg>
      <script src="//d3js.org/d3.v4.min.js"></script>
      <script src="scripts/candidate_chart_color.js"></script>
      <script src="scripts/summary_chart.js"></script>

    </div>
  </div>

  <div class="footer">
    <a href="references.html">References</a>
    <a href="contactus.html">Contact Us</a>
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

</body>
</html>
