<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>修改密碼</title>
    <link rel="stylesheet" href="css/style-memberinfo.css">
    <script src="js/changepasswd.js"></script>
    <style type="text/css">
	    #message{
			font-size: small;
			color: red;
		}
    </style>
    <script>
        function success(){
          var message='<%= session.getAttribute("success")%>';
          if(message!="null"){
            alert(message);
            <% session.removeAttribute("success"); %>;
          }

        }
    </script>
</head>
<body onload="success()">
    
    <div class="sectiontext">
        <form action="/gym/passwdchange" method="post" name="textpasswd">
            <p>目前密碼：<input type="password" name="userpasswd" id="userpasswd" value="" placeholder="請輸入目前密碼">
            <span id='message'><%if(request.getAttribute("error")!=null){out.print(request.getAttribute("error"));} %></span></p>
            <p>新密碼：<input type="password" name="newpasswd" id="newpasswd" value="" placeholder="請輸入8~12碼英數字"></p>
            <p>密碼確認：<input type="password" name="passwd" id="passwd" value="" placeholder="請再次輸入密碼"></p>
            <p><input type="reset" value="清除">&nbsp;&nbsp;<input type="button"value="送出"  onclick="modifypasswd()"></p></form>
    </div>

    <script>
        document.getElementById("passwd").addEventListener("keyup",function(event){
            if(event.key ==="Enter"){
                modifypasswd();
            }
        });

    </script>
</body>
</html>