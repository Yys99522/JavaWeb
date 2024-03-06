var xmlHTTP;
var str;
function check(){
    var regex_name=/^[A-Za-z0-9]{6,12}$/;
    var regex_passwd=/^[A-Za-z0-9]{8,12}$/;
    var username=document.login.username.value;
    var userpasswd=document.login.userpasswd.value;
    var checkOK=true;
    if(username.length==0){
        alert("請輸入帳號");
        document.login.username.focus();
        checkOK=false;
    }else{
        if(!regex_name.test(username)){
            alert("帳號格式錯誤");
            checkOK=false;
        }
    }
    if(userpasswd.length==0){
        alert("請輸入密碼");
        document.login.userpasswd.focus();
        checkOK=false;
    }else{
        if(!regex_passwd.test(userpasswd)){
            alert("密碼格式錯誤");
            checkOK=false;
        }
    }

    if(window.ActiveXObject)
    {
        xmlHTTP=new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if(window.XMLHttpRequest)
    {
        xmlHTTP=new XMLHttpRequest();
    }

    xmlHTTP.open("POST","http://localhost:8080/gym/login", true);

    xmlHTTP.onreadystatechange=function get_data()
    {
        if(xmlHTTP.status == 200)
        {
            if(xmlHTTP.readyState == 4)
            {
                str=xmlHTTP.responseText;
                if(str=="<h1>帳號或密碼錯誤</h1>"){
                    document.getElementById("message").innerHTML="<span style='color:red'>"+str+"</span>";
                }
                else{
                    
                    window.location.href = "/gym/memberwindow.jsp";
                }

            }
        }
    }
    if(checkOK){
        data={
            "username":username,
            "userpasswd":userpasswd
        }
        json=JSON.stringify(data);
        xmlHTTP.send(json);
    }else{
        document.login.reset();
        document.login.username.focus();
    }

    return false;
};