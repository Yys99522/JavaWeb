<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>

<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.*" %>



<%  

String message="";
String odid=request.getParameter("orderid");

try{
    InitialContext initContext =new InitialContext();
    Context context =(Context)initContext.lookup("java:comp/env");
    DataSource ds = (DataSource)context.lookup("jdbc/mysql");
    Connection connection=ds.getConnection();
    Statement statement=connection.createStatement();
    ResultSet rs;

    
    String sql ="select memberid,ordermain.orderid,productname,orderdetal.price,categoryy from ordermain,orderdetal,products where ordermain.orderid=orderdetal.orderid and orderdetal.productid=products.productid;";
    rs= statement.executeQuery(sql); 

    while(rs.next()){  
        if(rs.getString("orderid").equals(odid)){
            message+="<tr><td>"+rs.getString("productname")+"</td><td>"+rs.getString("categoryy")+"</td><td>"+rs.getString("price")+"</td></tr>";
        }  
            
    };

    statement.close();
    connection.close();

}catch(SQLException e){ 
    System.out.println(e.getMessage());

    }
 catch(NamingException e){
     System.out.println(e.getMessage());
 }

out.print(message);
%>
