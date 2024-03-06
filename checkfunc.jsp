<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="java.sql.*" %>

<%
	//取得session屬性
	String curID = ""+session.getAttribute("curID");

	//取得卡號(form傳輸,直接getparam)
	String cardNumber = ""+request.getParameter("cardNumber");
	
	//取得付款方式 
	String paymentmethod = ""+request.getParameter("paymMthod");

  	//確認接收到session的屬性,建立連綫跟資料庫要資料
    // 建立数据库连接
    Connection conn = null;
    PreparedStatement prepStmt = null;//寫入付款方式/支付狀態
    PreparedStatement prepStmt2 = null;//寫入卡號
    
    String jdbcUrl = "jdbc:mysql://localhost:3306/gym";
    String username = "user";
    String password = "1234";
    
    
    //SQL
    String sql = "UPDATE gym.orderdetal SET paymentmethod = ? , paymentstatus = 'true' WHERE orderid = ?";
    String sql2 = "UPDATE gym.ordermain SET cardnumber = ? WHERE orderid = ?";
    
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
			prepStmt.setString(1,paymentmethod);
			prepStmt.setString(2, curID);
			prepStmt.execute();
			
            prepStmt2 = conn.prepareStatement(sql2);
			prepStmt2.setString(1, cardNumber);
			prepStmt2.setString(2, curID);
            prepStmt2.execute();
                    
            // 关闭数据库连接
			prepStmt.close();
            prepStmt2.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } else {
        System.out.print("無法建立數據庫連接");
    }
    %>