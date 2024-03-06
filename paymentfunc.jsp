<% //設定頁面的材料形式為文字/靜態網頁,編碼為UTF-8%>
<%request.setCharacterEncoding("utf-8");%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList, java.util.List, org.json.JSONArray" %>

<script>
var flag = true;

//驗證卡號
function validateCardNumber() {
    // 获取输入的卡号
    var cardNumber = document.getElementById("cardNumber").value;

    // 设卡号必须是 16 位数字
	if(flag){
		if (/^\d{16}$/.test(cardNumber)) {
		   document.myform.submit();
			return true;
		} else {
			alert("请输入16位数字卡号");
			reload();
			document.getElementById("insrand").value = "";
			document.getElementById("cardNumber").focus();
			return false
		}
	}
}
// 刷新驗證碼圖像
function reload(){
    var img = document.getElementById("checkpic");
    // 做個時間戳,硬轉換鏈接,達到刷新效果
    var time = new Date().getTime();
    img.src = "createImage_temp.jsp?"+time;
}
</script>

<script>
// 如果點擊了現金繳費,隱藏卡號欄位
//取現金繳費的物件,並設置監聽器
var payByCash = document.getElementById("payByCash");
// 監控到的同時執行function
payByCash.addEventListener("change",function(){
	if(payByCash.checked){
    document.getElementById("cardNumber").style.display = "none";
	document.getElementById("cardNumberLabel").style.display = "none";
	document.getElementById("cardNumber").value = "";
    document.getElementById("cvc").style.display = "none";
	document.getElementById("cvcLabel").style.display = "none";
    document.getElementById("cvc").value = "";
    document.getElementById("expdateLabel").style.display = "none";
	document.getElementById("expmonth").style.display = "none";
    document.getElementById("expyear").style.display = "none";
    document.getElementById("expmonth_txt").style.display = "none";
    document.getElementById("expyear_txt").style.display = "none";
	flag = false;
	return true;
	}
})

//點擊了另外的紐則再把卡號欄位顯示
var craditCard = document.getElementById("craditCard");
//監控到的同時執行function
craditCard.addEventListener("change",function(){
	if(craditCard.checked){
    document.getElementById("cardNumber").style.display = "flex";
	document.getElementById("cardNumberLabel").style.display = "flex";
	document.getElementById("cardNumber").focus();
    document.getElementById("cvc").style.display = "flex";
	document.getElementById("cvcLabel").style.display = "flex";
    document.getElementById("expdateLabel").style.display = "flex";
	document.getElementById("expmonth").style.display = "inline";
    document.getElementById("expyear").style.display = "inline";
    document.getElementById("expmonth_txt").style.display = "inline";
    document.getElementById("expyear_txt").style.display = "inline";
	flag = true;
	return true;
	}
})
</script>

<%
	//取得session屬性
	String curID = ""+session.getAttribute("curID");

  	//確認接收到session的屬性,建立連綫跟資料庫要資料
    // 建立数据库连接
    Connection conn = null;
    PreparedStatement prepStmt = null;
    ResultSet res = null;
    
    String jdbcUrl = "jdbc:mysql://localhost:3306/gym";
    String username = "user";
    String password = "1234";
    
    List<String> list = new ArrayList<>(); 
    String productName="";
    //String productID="";
    String productPrice="";
    String productImg="";
    
    JSONArray jarray=new JSONArray();
    
    //SQL
    String sql = "SELECT * FROM gym.orderdetal ord LEFT JOIN gym.products pro on ord.productid=pro.productid where orderid=?";
    
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
                productImg = res.getString("image");
                //productID = res.getString("productid");
                productName = res.getString("productname");
                productPrice = res.getString("price");
                // 在页面上显示查询结果或进行其他操作
                list.add(productImg);
                //list.add(productID);
                list.add(productName);
                list.add(productPrice);
            }
            //list存入json
            jarray = new JSONArray(list);            
            // 关闭数据库连接
            res.close();
            prepStmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } else {
        System.out.println("无法建立数据库连接");
    }
    %>
    
    <script>
			/*因爲jarray是陣列的文字形態,script直接識別他是陣列*/
		    var info = <%= jarray.toString() %>;

            var i = 0;
            let count=1;
            let img;
            let name;
            let cost;
            let costAll=0;
            while(i<info.length){
            	img=info[i++];
                name=info[i++];
                cost=info[i++];
                createcard(img,name,cost);  
            }
		    
            function createcard(img, name, cost) {
                var li = document.createElement("li");
                document.getElementById("orderlist").appendChild(li);
                // li.innerHTML = 
                // `
                // <img src="${img}" alt="圖片未載入">
                // <span>${name}</span>
                // <span>$${cost}</span>
                // `

                li.innerHTML = 
                "<img src='"+img+"' alt='圖片未載入'> <span>"+name+"</span> <span>$"+cost+"</span>";
                costAll+=parseInt(cost);
                document.getElementById("totalCost").innerHTML = 
                "<span>總計: $ "+costAll+"</span>";
                return true;
            }
            
            document.getElementById("orderid").value = <%= curID %>;
		</script>
