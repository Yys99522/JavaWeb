

//返回商品頁按鈕
function backBottom(){
    var slideElement = document.getElementById("slideElement");
    var showcartBottom = document.getElementById("showcartBottom")
    slideElement.style.right = "-999px"; // 隱藏元素
    showcartBottom.style.visibility = "visible";//顯示小圖標
    return true;
}

//---------------------------------------購物車顯示功能-----------------------------
var count = 0;
var key;//用於數據存入跟刪除map時的精確定位
function addToCart(classBtnEle) {
	remindlogin();//檢視是否登入,並提供提示信息
    // 创建一个新购物车项目元素
    var cartItem = document.createElement("li");
    /*添加的商品信息需要動態變化!!!!!
        使用丟入this物件找上下元素的技巧
        動態取得商品的各項信息丟入inner HTML
    */
   //獲取丟入的物件
    var btn = classBtnEle;
   //取得商品名稱<先拿到父元素>-再取子元素
    var productName = btn.parentNode.children[1].innerText;
   //取得商品價格
   var productCost = btn.parentNode.children[3].innerText;
   
   key = btn.value;

    //onclick(this),使用this直接傳遞自身物件
    cartItem.innerHTML = productName +"<p style='margin:0; padding:0;'>"+productCost+"</p>"+"<button onclick='delFromCart(this)' value='"+ key +"'>-</button>";

    // 查找购物车元素
    var cartList = document.querySelector(".cartcover ul");

    // 将新购物车项添加到购物车(appendChild-延續添加"子"項目)
    cartList.appendChild(cartItem);

    //叫用實際存放數據的fanction
    putincart(classBtnEle)

    // 更新总计
    updateTotal(productCost);

    count++;
    document.getElementById("redcircle").innerText = count;
    return true;
}

function delFromCart(buttonElement) {
    // 先獲取刪除紐的物件
    var btn = buttonElement;
    
    //獲取當前刪除紐的父輩(li)
    var cartItem = btn.parentNode;

    //先抓取商品價格
    var costRemove = cartItem.children[0].innerText;
    // 然后调用 updateTotal(丟入商品價格) 更新总计
    updateTotal("-"+costRemove);

    // 再向外获取父元素并从购物车中删除相应的项目
    var cartList = document.querySelector(".cartcover ul");

    //鎖定刪除紐的父輩(也就是li)丟到()中執行刪除動作
    cartList.removeChild(cartItem);

    //叫用實際刪除數據的方法
    takeoutcart(buttonElement);

    //切換商品頁按鈕disabled狀態
    var strr = 'proc'+btn.value;
    document.getElementById(strr).disabled=false;

    count--;
    document.getElementById("redcircle").innerText = count;
    return true;
}

var totalMoney = 0;
function updateTotal(costChange) {
    // 在这里更新购物车总计的逻辑
    //接上每次丟入的productCost,
    //把字串處理成數字(且把錢字符去掉)
    var changeDig = parseInt(costChange.replace('$',''));

    //加總后用innerText技巧處理
    totalMoney += changeDig;

    //取得總計元素 - 設定值隨著操作變動
    var totalElement = document.getElementById("totalCost");
    totalElement.innerText = "总计: $"+totalMoney;
    return true;
}

//<----------------------------------------------實際存放數據--------------------------------------------->
var cart = new Map();//先建立一個購物車map,用來儲存
function putincart(classBtnEle){
    //獲取丟入的物件
    var btn = classBtnEle;
   //取得商品名稱<先拿到父元素>-再取子元素
    var productName = btn.parentNode.children[1].innerText;
   //取得商品價格
   var productCost = btn.parentNode.children[3].innerText;

   /*除了顯示購物車外,要有實際的記錄功能,所以需要一個儲存課程資料的空間
    **目前已經能取到商品名稱及價格
    **建個空間存放即可
    **較佳的方案是每個商品做一個物件,再存入數組管理
    */
    var cartObject = {
        cartPName : productName,
        cartPCost : productCost
    }
    //做一個鍵給丟入的物件,在刪除不需要的商品時可以直接精確定位項目
    cart.set(btn.value,cartObject);


    //遍歷map
    // cart.forEach(function(value, key) {
     //    console.log('Key: ' + key +'Avalue: ' + value.cartPName+'Bvalue: ' + value.cartPCost);
     //});
     return true;
}

function takeoutcart(buttonElement){
    // 先獲取刪除紐的物件
    var btn = buttonElement;
    //取value的值
    var takekey = btn.value;
    cart.delete(takekey);
    //遍歷map
    // cart.forEach(function(value, key) {
    //     console.log('Key: ' + key +'Avalue: ' + value.cartPName+'Bvalue: ' + value.cartPCost);
    // });
    return true;
}

//把map送出去給到結賬頁面
// 結賬按鈕
var dataToSend = [];//建立存放數據的數組<是json可以接受的資料類型>
var xmlHTTP;
var str;

function paybtn(){
    
    //把map序列化成JSON
    //json最外層要[],不能直接塞map,要foreach把物件放入
    cart.forEach(function(value, key) {
         dataToSend.push({key:key,value:value});
     });
    var jsonData = JSON.stringify(dataToSend);

    //開始配置ajax
    
    if(window.ActiveXObject)
          {
              xmlHTTP=new ActiveXObject("Microsoft.XMLHTTP");
          }
          else if(window.XMLHttpRequest)
          {
          	//建立xml物件
              xmlHTTP=new XMLHttpRequest();
          }
    		//確認是使用什麽傳輸方式,然後給定servlet路徑
          xmlHTTP.open("Post","http://localhost:8080/gym/Menuservlet",true);
    		
    		//確認連綫請求的狀態
          xmlHTTP.onreadystatechange=function get_data()
          {
              if(xmlHTTP.status == 200)
              {
                  if(xmlHTTP.readyState == 4)
                  {
                  	//接收Menuservlet回傳字串
                      //str=xmlHTTP.responseText;
                      //document.getElementById("message").innerHTML="<span style='font-size:1cm;color:blue'>"+str+"</span>";
                  	//如果放在外面會異步傳輸,servlet的session還沒設定好,就跳轉頁面,導致
          			window.location.href = "payment.jsp";
                  }
              }
          }
          //把准備好的json檔送出
          xmlHTTP.send(jsonData);
          //跳轉到結賬頁面
          //window.location.href = "payment.jsp";
          return true;
}
// <---------------------------------------------------------------------------------->

function remindlogin(){
	if (sessionStorage.getItem("online")=='0') alert("登入會員後即可購買課程");
}


