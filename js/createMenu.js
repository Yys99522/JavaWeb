// 生成menu頁面的function,調用方式是onload
var xmlHTTP;
var str;

function createClass()
{  
    connect();
    return true;
}
  

var strArray;
function connect(){
    if(window.ActiveXObject)
    {
        xmlHTTP=new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if(window.XMLHttpRequest)
    {
        xmlHTTP=new XMLHttpRequest();
    }
    xmlHTTP.open("POST","http://localhost:8080/gym/CreateMenuServlet", true);
    
    xmlHTTP.onreadystatechange=function get_data(){
    if(xmlHTTP.status == 200)
        {
            if(xmlHTTP.readyState == 4)
            {//檢測到有回傳就創造商品框
            
            //接收字串
            str=xmlHTTP.responseText;
            //接收到的字串切分後存成陣列
            strArray = str.split("=");

            //創建卡片
            card();
            //document.getElementById("message").innerHTML="<span style='font-size:1cm;color:red'>"+strArray.toString()+"</span>";
            }
        }
    }
    xmlHTTP.send();
    return true;
}

var index = 0;
function card(){

while(index<strArray.length-1){

    //商品框架(然後每建兩個course-item就建一個course這樣才會換行)
            
    //建一個course,作爲大框架
    var newCourse = document.createElement("div");
    newCourse.className="course";
    document.querySelector(".menu").appendChild(newCourse);
    
    
    //直接建立兩個内框(初始class名稱設定為初始樣板,且套用初始css)
    var newEle1 = document.createElement("div");
    newEle1.className="course-item";
    newCourse.appendChild(newEle1);
    
    var newEle2 = document.createElement("div");
    newEle2.className="course-item";
    newCourse.appendChild(newEle2);
    //塞入框架中間内容

/*
陣列中的順序
productid	VARCHAR(10) NOT NULL,
image		VARCHAR(20),
productname	VARCHAR(10),
descript	TEXT,
price		DOUBLE(10,2),
*/

//用來放在button中,送給購物車的時候傳值(productID)過去
var id1 = strArray[index++];
if(id1>0){
	newEle1.innerHTML = 
		`
		<img src="${strArray[index++]}" alt="圖片未加載...">
	    <h3>${strArray[index++]}</h3>
	    <p>${strArray[index++]}</p>
	    <span class="course-price">$${strArray[index++]}</span>
	    <button class="add-to-cart" onclick="addToCart(this);this.disabled=true;" value="${id1}" id="proc${id1}">加入購物車</button>
	`;
}

var id2 = strArray[index++];
if(id2>0){
	newEle2.innerHTML = 
		`
		<img src="${strArray[index++]}" alt="圖片未加載...">
	    <h3>${strArray[index++]}</h3>
	    <p>${strArray[index++]}</p>
	    <span class="course-price">$${strArray[index++]}</span>
	    <button class="add-to-cart" onclick="addToCart(this);this.disabled=true;" value="${id2}" id="proc${id2}">加入購物車</button>
	`;
}

}
return true;

}
