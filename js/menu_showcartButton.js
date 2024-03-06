//解決拖動按鈕導致的放開點擊問題
//思路
//判斷是否移動過,來決定可不可以點擊
//建立一個判斷的flag
var isClickEnable = true;

function showcart() {
    // 變數要設在函數内,不然抓不到
    if(isClickEnable){//判斷當前狀態是否可移動
        var slideElement = document.getElementById("slideElement");
        var showcartBottom = document.getElementById("showcartBottom")
        slideElement.style.right = "0px"; // 显示元素
        showcartBottom.style.visibility = "hidden";//隱藏小圖標
    }
    return true;
}

//按鍵拖動實現
var isDragging = false;
var offsetX, offsetY;

function startDrag(event) {
    isDragging = true;
    //每次都要設定為可點擊狀態,否則移動后側邊欄就再也打不開
    isClickEnable = true;
    //取得事件發生時的當前位置 - 視圖窗口左側 = 相當于對比視窗后的滑鼠當前位置
    offsetX = event.clientX - event.target.getBoundingClientRect().left;
    offsetY = event.clientY - event.target.getBoundingClientRect().top;
    //添加事件監聽器
    document.addEventListener('mousemove', dragButton);//滑鼠移動觸發
    document.addEventListener('mouseup', stopDrag);//滑鼠放開觸發
    return true;
}

function dragButton(event) {
    if (isDragging) {
        var button = document.getElementById('showcartBottom');
        //把按鈕的位置設置爲事件位置(滑鼠位置)-視覺上才能看到按鈕跟隨滑鼠移動
        deltaX = button.style.left = (event.clientX - offsetX) + 'px';
        deltaY = button.style.top = (event.clientY - offsetY) + 'px';
        //如果移動過則設定為無法點擊
        if(deltaX !== 0 ||deltaY !== 0){
            isClickEnable = false;
        }
    }
    return true;
}

function stopDrag(event) {
    if (isDragging) {
        isDragging = false;
        //移除監聽器
        document.removeEventListener('mousemove', dragButton);
        document.removeEventListener('mouseup', stopDrag);

        var button = document.getElementById('showcartBottom');
        var newPositionX = event.clientX - offsetX;
        var newPositionY = event.clientY - offsetY;

        // 限制按钮不超出页面边界，可以根据需要调整边界值
        newPositionX = Math.min(Math.max(newPositionX, 0), window.innerWidth - button.offsetWidth);
        newPositionY = Math.min(Math.max(newPositionY, 0), window.innerHeight - button.offsetHeight);
        //把按鈕的位置設置爲事件位置(滑鼠位置)
        button.style.left = newPositionX + 'px';
        button.style.top = newPositionY + 'px';
    }
    return true;
}