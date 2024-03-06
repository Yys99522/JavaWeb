<% //設定頁面的材料形式為文字/靜態網頁,編碼為UTF-8%>

<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%request.setCharacterEncoding("utf-8");%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList, java.util.List, org.json.JSONArray" %>

<%@ page import="java.awt.Color" %>
<%@ page import="java.awt.Graphics" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.io.File" %>
<%@ page import="java.nio.file.Path" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="com.google.zxing.BarcodeFormat" %>
<%@ page import="com.google.zxing.EncodeHintType" %>
<%@ page import="com.google.zxing.MultiFormatWriter" %>
<%@ page import="com.google.zxing.client.j2se.MatrixToImageWriter" %>
<%@ page import="com.google.zxing.common.BitMatrix" %>
<%@ page import="com.google.zxing.qrcode.decoder.ErrorCorrectionLevel" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.util.Base64" %>


<!-- 上一個表單使用form送出,因此這張表單直接一個request接即可 -->
<!-- 安插QRcode的java語句 -->
	<%
  	//確認接收到session的屬性,建立連綫跟資料庫要資料
    // 建立数据库连接
    Connection conn = null;
    PreparedStatement prepStmt = null;
    PreparedStatement prepStmt2 = null;
    //ResultSet res = null;
    
    String jdbcUrl = "jdbc:mysql://localhost:3306/gym";
    String username = "user";
    String password = "1234";
    
    //取得付款方式//訂單ID
    String payMethod=request.getParameter("paymMthod");
    String curID = request.getParameter("orderid");
    
    //SQL
    String sql = "UPDATE gym.orderdetal SET paymentmethod=? WHERE orderid=?;";
    String sqlget = "SELECT * FROM gym.ordermain om INNER JOIN gym.orderdetal od ON om.orderid=od.orderid WHERE om.orderid=?";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, username, password);
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    if (conn != null) {
        // 执行数据库查询
        try {
        	System.out.print("payment.connect建立成功");
            prepStmt = conn.prepareStatement(sql);
            prepStmt2 = conn.prepareStatement(sqlget);
			prepStmt.setString(1, payMethod);
			prepStmt.setString(2, curID);
            prepStmt.execute();
                  
            // 关闭数据库连接
            prepStmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } else {
        out.println("无法建立数据库连接");
    }
    %>

	<%
	// 宽度和高度
	int width = 300;
	int height = 300;
	// 图片的格式
	String format = "gif";
	// 内容
	String contents = "報告結束,感謝老師指導,感謝我的組員,也謝謝同學的互相互助!";
	
	HashMap<EncodeHintType, Object> hints = new HashMap<EncodeHintType, Object>();
	hints.put(EncodeHintType.CHARACTER_SET, "utf-8");
	hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
	hints.put(EncodeHintType.MARGIN, 3); // 留白
	
	try {
	    MultiFormatWriter writer = new MultiFormatWriter();
	    BitMatrix bitMatrix = writer.encode(contents, BarcodeFormat.QR_CODE, width, height, hints);
	
	    ByteArrayOutputStream outStream = new ByteArrayOutputStream();
	    MatrixToImageWriter.writeToStream(bitMatrix, format, outStream);
	
	    byte[] imageBytes = outStream.toByteArray();
	    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
		//try的結尾}放在另一段jsp區段中所以這中間的任何jsp區段都視爲包含在try中
	%>
    

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style-qrcode.css">
    <title>訂單二維碼</title>
    <style>
        a{
            text-decoration: none;
            color: black;
        }
        a:hover{
            color: blue;
        }
    </style>
</head>
<body>
    <div class="qr-order">
        <h2>訂單二維碼</h2>
        <div class="order-details">
            <p>訂單號：<%=session.getAttribute("curID") %></p>
            <p id="orderdate">訂單日期：2023-11-05</p>
        </div>
        <%// 将QR码以Base64编码的方式嵌入到HTML中 %>
        <img src="data:image/<%=format%>;base64,<%=base64Image%>" alt="订单二维码">
        <p>櫃檯掃描並完成支付</p>
        <a  href="index.html">回首頁</a>
    </div>

</body>
</html>

<%
} catch (Exception e) {
    e.printStackTrace();
}
%>

<jsp:include page="qrcodefunc.jsp"/>
