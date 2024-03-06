<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" style="height: 100%;">
<head style="height: 150%;">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style-menu.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC&display=swap" rel="stylesheet">
    <title>私教課程</title>
    <script src="js/menu.js"></script>
    <script src="js/menu_showcartButton.js"></script>
    <script src="js/createMenu.js"></script>
    
    
</head>
<body onload="checkOnline()">

    <button class="showcartBottom" onclick="showcart()" id="showcartBottom" onmousedown="startDrag(event)" style="display: none;">
    <div class="redcircle" id="redcircle">0</div>
    </button>
    <div class="cartcover" id="slideElement">
        <h2>購物車<%= session.getAttribute("uid") %></h2>
        <ul>
            <!-- 用js技術在點擊後產生元素-innerHtml<> -->
        </ul>
        <!--這邊用innertext技術,counttotal后放進去-->
        <p id="totalCost">總計: $0</p>
        <button class="backBottom" onclick="backBottom()" id="backBottom">返回頁面</button>
        <button class="payBottom" onclick="paybtn()" id="payBottom">結帳</button>
    </div>

    <div class="sheld" style="height: 100%;">
        <div class="header">
            <div class="header-left">
                <div class="header-left-img">
                    <img src="img/icons4.png" alt="顯示異常" style="width: 100%;">
                </div>
                <div class="header-left-text">
                    <a id="link" href="index.html">健身鐵工廠</a>
                </div>
            </div>  
            <div class="header-right">
                <div class="header-right-img">
                    <img id="member-icon" src="img/icons1.png" alt="" width="24px" height="28px" id="member" style="visibility: hidden;">
                </div>
                <div class="header-right-text">
                    <a id="member-link" href="memberwindow.jsp" aria-disabled="true" style="visibility: hidden;">會員中心</a>
                </div>
                <div class="header-right-img">
                    <img src="img/icons6.png" alt="">
                </div>
                <div class="header-right-text">
                    <a id="login-link" href="login.html">會員登入</a>
                </div>
            </div> 
        </div>
        <div class="navbar" id="navbar">
            <div class="navbar1">公開課</div>
            <div class="navbar2"><a id="link" href="menu.jsp">私教課程</a></div>
            <div class="navbar3">預約體驗</div>
        </div>
        <div class="menu">
            <h2>私教課程</h2>
            <!--  call-fuction 調用資料庫信息,然後生成元素及課程框架-->
            <!-- 使用js連結資料庫,跑回圈生成課程-->
        </div>
        <footer class="footer">
            <p>健身鐡工廠</p>
            <div class="social-icons">
                <a href="#" target="_blank">加入我们<i class="fab fa-facebook"></i></a>
                <a href="#" target="_blank">機不可失<i class="fab fa-twitter"></i></a>
                <a href="#" target="_blank">失不再来<i class="fab fa-instagram"></i></a>
                 

                <!--  測試回傳
                <div id="message" ></div>
				-->
            </div>
        </footer>
    </div>
    <script>
    //給視窗添加監聽,讓視窗加載后叫用function
     window.addEventListener('load', createClass);
    </script>
    <script type="text/javascript">
	    // var uid = <%= session.getAttribute("uid") %>;
	    //     if (uid===null) {
	    //         // 获取元素并设置样式
	    //         document.getElementById("showcartBottom").style.display = "none";
	    //     }
            
        function checkOnline(){
            var membericon=document.getElementById("member-icon");
            var memberlink=document.getElementById("member-link");

            if (sessionStorage.getItem("online")=='1'){
                    document.getElementById("login-link").outerHTML="<a id='login-link' href='index.html' onclick='logout()'>登出</a>";
                    membericon.style.visibility= "visible";
                    memberlink.style.visibility= "visible";
                    document.getElementById("showcartBottom").style.display = "flex";
            }else{
                    document.getElementById("login-link").outerHTML="<a id='login-link' href='login.html'>會員登入</a>";
                    membericon.style.visibility= "hidden";
                    emberlink.style.visibility= "hidden";
                    document.getElementById("showcartBottom").style.display = "none";
            }
        }
        function logout(){
            sessionStorage.setItem("online","0");
            membericon.style.visibility= "hidden";
            emberlink.style.visibility= "hidden";
            document.getElementById("showcartBottom").style.display = "none";
        }
	</script>
</body>
</html>
