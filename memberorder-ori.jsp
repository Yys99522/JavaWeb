<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>

<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>課程管理</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h2>訂單查詢</h2>
    <% 
        String uid=(String)session.getAttribute("uid");
        
        try{
        InitialContext initContext =new InitialContext();
        Context context =(Context)initContext.lookup("java:comp/env");
        DataSource ds = (DataSource)context.lookup("jdbc/mysql");
        Connection connection=ds.getConnection();
        Statement statement=connection.createStatement();
        ResultSet rs;
    %>

<table>
    <tr>
        <th>訂單編號</th>
        <th>訂單日期</th>
        <th>訂單金額</th>
        <th>付款狀態</th>
        <th></th>
    </tr>
    <!-- 這裡插入動態生成的訂單數據 -->
    <% 
    String main="select ma.orderid,orderdate,sum(price) total,paymentstatus from ordermain ma left join orderdetal de on ma.orderid=de.orderid where memberid="+uid+" group by ma.orderid,orderdate,paymentstatus;";
    rs=statement.executeQuery(main);
    String orderid="";
    while(rs.next()){
        orderid=rs.getString("orderid");
        out.print("<tr><td>"+orderid+"</td>");
        out.print("<td>"+rs.getString("orderdate")+"</td>");
        out.print("<td>"+rs.getString("total")+"</td>");
        out.print("<td>"+rs.getString("paymentstatus")+"</td>");
        out.print("<td><button onclick='showOrderDetails("+orderid+")'>查看明細</button></td></tr>");

        
    }
       
    statement.close();
    connection.close();
    }catch(SQLException e){ 
        System.out.println(e.getMessage());
        return;
        }
     catch(NamingException e){
         System.out.println(e.getMessage());
     }
    %>
    <!-- 更多訂單數據... -->
</table>

<!-- 訂單明細彈窗 -->

<div id="orderDetailsModal" style="display: none;">
    <h3>訂單明細</h3>
    <!-- 這裡插入動態生成的訂單明細內容 -->
    <p>訂單編號: <span id="modalOrderId"></span></p>

    <div id="message"></div>
    <!-- 更多明細內容... -->
    <button onclick="closeOrderDetailsModal()">關閉</button>
</div>
<script>
    function showOrderDetails(orderId) {
        // 在這裡加載訂單明細數據並將其填充到彈窗中
        // 這裡只是一個簡單的例子，實際上你可能需要從後端獲取數據
        document.getElementById("modalOrderId").innerText = orderId;
        // 假設商品和總金額也是動態生成的
        // ...
        
        // 顯示彈窗
        document.getElementById("orderDetailsModal").style.display = "block";

        var xmlHTTP;
        var str;
        if(window.ActiveXObject)
        {
            xmlHTTP=new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if(window.XMLHttpRequest)
        {
            xmlHTTP=new XMLHttpRequest();
        }

        xmlHTTP.open("GET","http://localhost:8080/gym/orderdetal.jsp?orderid="+orderId, true);

        xmlHTTP.onreadystatechange=function get_data()
        {
            if(xmlHTTP.status == 200)
            {
                if(xmlHTTP.readyState == 4)
                {                      
                    str=xmlHTTP.responseText;
                    document.getElementById("message").innerHTML="<table id='message'>"+str+"</table>";
                }
            }
        }

        xmlHTTP.send();
    }

    function closeOrderDetailsModal() {
        // 關閉彈窗
        document.getElementById("orderDetailsModal").style.display = "none";
    }

</script>


</body>
</html>