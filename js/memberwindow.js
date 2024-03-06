$(document).ready(function(){

    $("#collapse").on("click",function(){

        $("#sidebar").toggleClass("active");
        $(".fa-align-left").toggleClass("fa-chevron-right");
    })
});


function loding(){ const uid=sessionStorage.getItem("uid");
//document.getElementById("uid").innerText=uid;
alert(uid);
;}
   



function changeinfo(){
    document.querySelector(".sectiontext").innerHTML=
    '<iframe src="memberinfo.html"name="memberinfo" width="100%"marginwidth="0" height="100%"marginheight="0" scrolling="No" frameborder="0" id="memberinfo" title="banner"></iframe>';
    return false;
}

function changepasswd(){
    document.querySelector(".sectiontext").innerHTML=
    '<iframe src="changepasswd.jsp"name="memberinfo" width="100%"marginwidth="0" height="100%"marginheight="0" scrolling="No" frameborder="0" id="memberinfo" title="banner"></iframe>';
    return false;
}

function order(){
    document.querySelector(".sectiontext").innerHTML=
    '<iframe src="memberorder.jsp"name="memberinfo" width="100%"marginwidth="5px" height="100%"marginheight="5px"  frameborder="0" id="memberinfo" title="banner"></iframe>';
    return false;
}