<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.Thread" %>
<!DOCTYPE html>
<html>

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="Cache-Control" content="no-cache">
  <meta http-equiv="Expires" content="0">
  <title>認證結果</title>
  <link rel="stylesheet" type="text/css" href="css/style-check.css">
</head>

<body>
  <div class="info-box" >
    <%
      String rnd = (String)session.getAttribute("rnd");
      String input = (String)request.getParameter("insrand");
    %>
    系統產生的認證碼： <%= rnd %><br>
    輸入的認證碼： <%= input %><br>
    <br>
    <%
    	String path = "";
       try{
           if(rnd.equals(input)){
               out.print("<p class='success'>輸入相同, 認證成功！</p>"); 
               path="./qrcode.jsp";
           }
           else{
	            out.print("<p class='failure'>輸入不同, 回原頁面！</p>");
	           	path="./payment.jsp";
           }
       }
       catch(Exception e){}
   %>
   <a href="<%= path %>" id="goQrcode">頁面將在3秒後跳轉</a>
  </div>
  
  <script>
  			setTimeout(function(){
  			   window.location.href = "<%= path %>";
  			}, 3000); // 3000毫秒，即3秒
  </script>
  
  <script>
    var count = 2;
    // 使用setInterval函數每一秒更新innerHTML
    setInterval(function() {
        var goQrcode = document.getElementById('goQrcode');
        if(count===0)return false;
        goQrcode.innerText = "頁面將在"+count--+"秒後跳轉";
    }, 1000); // 1000毫秒，即1秒
</script>
<jsp:include page="checkfunc.jsp"/>  
</body>

</html>
