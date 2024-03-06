<% //設定頁面的材料形式為文字/靜態網頁,編碼為UTF-8%>
<%request.setCharacterEncoding("utf-8");%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList, java.util.List, org.json.JSONArray" %>
<!DOCTYPE html>
<html lang="en">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <link rel="stylesheet" href="css/style-payment.css">
	    <title>結帳</title>
        
	</head>
	<body>
	
	    <div class="checkout">
	        <h2>購物車結帳</h2>
	        <ul id="orderlist">
	            <!-- 根据訂單内容动态生成更多项目 -->
	        </ul>
            <script>
                
            </script>
	        <p id="totalCost">金額計算出了點問題</p>
	        <form action="./check.jsp" method="post" name="myform">
                <!-- for=id 讓label具有鎖定屬性,點擊到label也可以直接鎖定id所在元素 -->
	            <label>付款方式：</label>
                <!-- required屬性將元素設定爲必填 -->
                <ul>
                    <li>
                    <label for="craditCard">信用卡</label>
                        <input type="radio" id="craditCard" name="paymMthod" value="craditCard" required checked>
                    </li>
                    
                    <li>
					<label for="payByCash">現金繳費</label>
                        <input type="radio" id="payByCash" name="paymMthod" value="payByCash" required>
                    </li>
                </ul>

	            <label for="cardNumber" id="cardNumberLabel">卡號：</label>
	            <input type="text" id="cardNumber" name="cardNumber" placeholder="請輸入16位數字卡號" maxlength="16">
				<label for="cvc" id="cvcLabel">CVC(安全碼)：</label>
				<input type="password" id="cvc" name="cvc" size="4" maxlength="3">
				<label for="expmonth" id="expdateLabel">有效日期：</label>
				<select name="expmonth" id="expmonth"><% for(int i=1;i<=12;i++){%> <option value="<% out.print(i); %>"><% out.print(i); }%></option></select> <span id="expmonth_txt">月</span>
				<select name="expyear" id="expyear"><% for(int i=25;i<=30;i++){%> <option value="<% out.print(i); %>"><% out.print(i); }%></option></select> <span id="expyear_txt">年</span>
	            <label for="insrand">輸入認證碼：</label>
	            <img src="createImage_temp.jsp" alt="Random_Number" id="checkpic"/>
                <img src="./img/icons5.gif" alt="reload" onclick="reload()" style="width: 3%;"><br>
	            <input type="text" id="insrand" name="insrand" required  maxlength="4">
	            <button class="payButton" onclick="return validateCardNumber()" name="orderid" id="orderid">確認支付</button>
	        </form>
	    </div>
	    
        	<!-- 引入的jsp與原本頁面有順序關係,如果在前面就引入,會抓不到後面生成的元素 -->
		    <jsp:include page="paymentfunc.jsp"/>
		    
	</body>
</html>
