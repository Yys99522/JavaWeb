function savechange(){
    var regex_phone=/^[0][9][0-9]{8}$/;
    var regex_name=/^[\u4E00-\u9FA5]+$/;
    var regex_address=/^[\u4E00-\u9FA50-9]+$/;
    var regex_username=/^[A-Za-z0-9]{6,12}$/;
    var regex_passwd=/^[A-Za-z0-9]{8,12}$/;
    var regex_email=/(^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$)|([0][9][0-9]{8})/;
    var membername=document.register.membername.value;
    var username=document.register.username.value;
    var userpasswd=document.register.userpasswd.value;
    var passwd=document.register.passwd.value;
    var phone=document.register.phone.value;
    var address=document.register.address.value;
    var birth=document.register.birthdate.value;
    var sex=document.register.sex.value;
    var email=document.register.email.value;
    var checkOK=true;

    if(!regex_name.test(membername)){
        alert("姓名格式錯誤");
        checkOK=false;
    }
    if(!regex_username.test(username)){
        alert("帳號格式錯誤");
        checkOK=false;
    }
    if(!regex_passwd.test(userpasswd)){
        alert("密碼格式錯誤");
        checkOK=false;
    }
    if(passwd!=userpasswd){
        alert("兩次密碼輸入不同");
        checkOK=false;
    }
    if(!regex_phone.test(phone)){
        alert("手機格式錯誤");
        checkOK=false;
    }
    if(!regex_address.test(address)){
        alert("地址格式錯誤");
        checkOK=false;
    }
    if(birth.length==0){
        alert("請填寫生日");
        checkOK=false;
    }
    if(sex.length ==0){
        alert("請填寫性別");
        checkOK=false;
    }
    if(!regex_email.test(email)){
        alert("email格式錯誤");
        checkOK=false;
    }
    if(checkOK){
        document.register.submit();
    }
    return false;
}