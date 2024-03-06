function preload(){
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

    xmlHTTP.open("POST","http://localhost:8080/gym/member", true);

    xmlHTTP.onreadystatechange=function get_data()
    {
        if(xmlHTTP.status == 200)
        {
            if(xmlHTTP.readyState == 4)
            {
            str=xmlHTTP.responseText;
            var jsonData=JSON.parse(str);
                
                
            //document.getElementById("uid").innerText=jsonData.uid;
            // document.getElementById("membername").outerHTML=
            //         "<input type='text' name='membername' id='membername'' value='"+jsonData.membername+"' size='10' disabled>";
            document.getElementById("phone").outerHTML=
                    "<input type='text' name='phone' id='phone'' value='"+jsonData.phone+"' disabled>";
            document.getElementById("birthdate").outerHTML=
                    "<input type='date' name='birthdate' id='birthdate'' value='"+jsonData.birthdate+"' disabled>";
            document.getElementById("email").outerHTML=
                    "<input type='text' name='email' id='email'' value='"+jsonData.email+"' disabled>";
            document.getElementById("county_box").innerHTML=
                    "<option value='"+jsonData.county+"'>"+jsonData.county+"</option>";
            document.getElementById("district_box").innerHTML=
                    "<option value='"+jsonData.district+"'>"+jsonData.district+"</option>"
            document.getElementById("address").outerHTML=
                    "<input type='text' name='address' id='address'' value='"+jsonData.address+"' disabled>";
            if(jsonData.sex==1){
                document.getElementById("male").outerHTML="<input type='radio' name='sex' id='male' value='1' checked disabled>";
            }else if(jsonData.sex==2){
                document.getElementById("female").outerHTML="<input type='radio' name='sex' id='female' value='2' checked disabled>";
            }
                        
            }
        }
    }
    xmlHTTP.send();
    return false;
};	
var checkOK=true;
var regex_phone=/^[0][9][0-9]{8}$/;
var regex_name=/^[\u4E00-\u9FA5]+$/;
var regex_address=/^[\u4E00-\u9FA5]{3,}[\u4E00-\u9FA50-9]+$/;
var regex_passwd=/^[A-Za-z0-9]{8,12}$/;




function modify(){   
    // document.getElementById("membername").disabled=false;
    phone=document.getElementById("phone").disabled=false;
    birthdate=document.getElementById("birthdate").disabled=false;
    document.getElementsByName("sex")[0].disabled=false;
    document.getElementsByName("sex")[1].disabled=false;
    document.getElementById("county_box").disabled=false;
    document.getElementById("district_box").disabled=false;
    address=document.getElementById("address").disabled=false;
    email=document.getElementById("email").disabled=false;
    
    return false;
}

function checkmodify(){
	checkOK=true;
    // var membername=document.getElementById("membername").value;
    var phone=document.getElementById("phone").value;
    var birthdate=document.getElementById("birthdate").value;
    var address=document.getElementById("address").value;
    var email=document.getElementById("email");
    var county=document.getElementById("county_box").value;
    var district=document.getElementById("district_box").value;

    // if(!regex_name.test(membername)){
    //     alert("姓名格式錯誤");
    //     checkOK=false;
    // }
    if(!regex_phone.test(phone)){
        alert("手機格式錯誤");
        checkOK=false;
    }
    if(!regex_address.test(address)){
        alert("地址格式錯誤");
        checkOK=false;
    }
    if(county==""){
		alert("請選擇縣市");
        checkOK=false;
	}
	if(district==""){
		alert("請選擇鄉鎮市區");
        checkOK=false;
	}

//    return false;

}
function savechange(){
    checkmodify();
    if(checkOK){
		// var membername=document.getElementById("membername").value;
	    var phone=document.getElementById("phone").value;
	    var birthdate=document.getElementById("birthdate").value;
	    var address=document.getElementById("address").value;
	    var email=document.getElementById("email").value;
	    var county=document.getElementById("county_box").value;
	    var district=document.getElementById("district_box").value;
        var sex=document.getElementsByName("sex");

        var selectedSex=null;
        for(i=0;i<2;i++){
            if(sex[i].checked){
                selectedSex=sex[i].value;
            }
        }

        var data={
            // "membername":membername,
            "phone":phone,
            "birthdate":birthdate,
            "sex":selectedSex,
            "county":county,
            "district":district,
            "address":address,
            "email":email
        };
        var jsonData=JSON.stringify(data);
        
        // document.getElementById("membername").disabled=true;
        phone=document.getElementById("phone").disabled=true;
        birthdate=document.getElementById("birthdate").disabled=true;
        document.getElementsByName("sex")[0].disabled=true;
        document.getElementsByName("sex")[1].disabled=true;
        document.getElementById("county_box").disabled=true;
        document.getElementById("district_box").disabled=true;
        address=document.getElementById("address").disabled=true;
        email=document.getElementById("email").disabled=true; 

        
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
    
        xmlHTTP.open("POST","http://localhost:8080/gym/savechange", true);
    
        xmlHTTP.onreadystatechange=function get_data()
        {
            if(xmlHTTP.status == 200)
            {
                if(xmlHTTP.readyState == 4)
                {
                    str=xmlHTTP.responseText;
                                       
                }
            }
        }
        xmlHTTP.send(jsonData); 
        return false;
    };
}