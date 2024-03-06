function modifypasswd(){
	var checkOK =true;
	var regex_passwd=/^[A-Za-z0-9]{8,12}$/;
    var userpasswd=document.getElementById("userpasswd").value;
    var newpasswd=document.getElementById("newpasswd").value;
    var passwd=document.getElementById("passwd").value;

    if(!regex_passwd.test(newpasswd)){
        alert("密碼格式錯誤");
        checkOK=false;
    }
    if(passwd!=newpasswd){
        alert("兩次密碼輸入不同");
        checkOK=false;
    }
    if(checkOK){
		document.textpasswd.submit();
	}
    return false;

}
