<% //設定頁面的材料形式為文字/靜態網頁,編碼為UTF-8%>
<%request.setCharacterEncoding("utf-8");%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList, java.util.List, org.json.JSONArray" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>

<%
	//取得session屬性
	String curID = ""+session.getAttribute("curID");

	//取得卡號(form傳輸,直接getparam)
	String cardNumber = ""+request.getParameter("cardNumber");

  	//確認接收到session的屬性,建立連綫跟資料庫要資料
    // 建立数据库连接
    Connection conn = null;
    PreparedStatement prepStmt = null;
    ResultSet res = null;
    
    String jdbcUrl = "jdbc:mysql://localhost:3306/gym";
    String username = "user";
    String password = "1234";
    
    List<String> list = new ArrayList<>(); 
    String orderdate="";

    
    JSONArray jarray=new JSONArray();
    
    //SQL
    String sql = "SELECT * FROM gym.ordermain where orderid=?";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, username, password);
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    if (conn != null) {
        // 执行数据库查询
        try {
        	System.out.println("payment.connect建立成功");
            prepStmt = conn.prepareStatement(sql);
			prepStmt.setString(1, curID);
            res = prepStmt.executeQuery();
            
            while (res.next()) {
                // 处理查询结果
                orderdate = res.getString("orderdate");
            }         
            // 关闭数据库连接
            res.close();
            prepStmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } else {
        System.out.print("無法建立數據庫連接");
    }
    %>
    
    <script>
    document.getElementById("orderdate").innerText = "訂單日期：<%= orderdate %>";
    </script>

</body>
</html>

