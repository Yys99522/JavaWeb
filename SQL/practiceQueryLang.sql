
CREATE SCHEMA if not EXISTS gym

CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci; 

use gym;
 
CREATE TABLE if not EXISTS memberinfo(
memberid	BIGINT NOT NULL AUTO_INCREMENT,
membername 	VARCHAR(10),
email		VARCHAR(30),
phone		VARCHAR(10),
birthdate	DATE,
sex        	ENUM('1','2'),
county		VARCHAR(10),
district	VARCHAR(10),
address		VARCHAR(30),
img			varchar(50),
deleted		boolean,
PRIMARY KEY(memberid)
);

CREATE TABLE if not EXISTS account(
username    VARCHAR(12),
userpasswd	VARCHAR(12),
uid			BIGINT auto_increment,
identity	VARCHAR(3),
PRIMARY KEY(username),
FOREIGN KEY(uid) references memberinfo(memberid)
);

CREATE TABLE if not EXISTS ordermain(
orderid 	BIGINT NOT NULL AUTO_INCREMENT,
orderdate 	DATETIME,
memberid 	BIGINT NOT NULL,
cardnumber	VARCHAR(16),
foreign key (memberid) 
references gym.memberinfo (memberid),
PRIMARY KEY(orderid)
);

CREATE TABLE if not EXISTS orderdetal(
orderid		BIGINT,
productid 	VARCHAR(10),
price		DOUBLE(10,2),
quantity	INT,
paymentmethod	VARCHAR(10),
paymentstatus	VARCHAR(10),
foreign key (orderid) references ordermain(orderid)
);

CREATE TABLE IF NOT EXISTS products (
  productid BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  productname VARCHAR(10),
  descript TEXT,
  price DOUBLE(10,2),
  categoryy VARCHAR(10),
  image VARCHAR(20),
  isavailable BOOLEAN
);

CREATE TABLE cart(
cartID BIGINT PRIMARY KEY AUTO_INCREMENT,
memberid BIGINT,
statustype VARCHAR(10) NOT NULL,
FOREIGN KEY (memberid) 
REFERENCES gym.memberinfo (memberid)
);


CREATE TABLE cartdetal(
cartID BIGINT,
productid	BIGINT,
price	DOUBLE,
quantity	INT,
statustype	VARCHAR(10),

FOREIGN KEY(cartID)
REFERENCES gym.cart(cartID),
FOREIGN KEY (productid) 
REFERENCES gym.products (productid)
);



INSERT INTO gym.products 
(productname,descript,price,categoryy,image,isavailable) 
VALUES(
"高强度重訓課",
"全面的瑜伽課程，強調靈活性、核心肌群訓練和壓力紓解，幫助實現身體健康、內心平靜和精神平衡，達到身心靈的完美協調。",
499,
'瑜伽',
'./img/menu1.jpg',
0
);

INSERT INTO gym.products 
(productname,descript,price,categoryy,image,isavailable)
VALUES(
'暴打渣男拳擊',
'擊退渣男，釋放壓力，鍛煉身體，自信大增！暴打渣男拳擊，專注自我防衛和健康，享受挑戰和成長',
1200,
'拳擊',
'./img/menu2.jpg',
0
),
(
'嬾骨頭體操課',
'嬾骨頭體操課，針對關節靈活性、肌肉強度和平衡性進行設計。適合各年齡層，增進體能，改善姿勢，提升生活質量',
250,
'體操',
'./img/menu3.jpg',
0
),
(
'轉大人夏令營',
'參加轉大人夏令營，探索新技能，結識新朋友，挑戰自我，學習生活技巧，並在有趣的環境中度過難忘的暑假。',
9999,
'露營',
'./img/menu4.jpg',
0
),
(
'隨波逐流衝浪課',
'
在「隨波逐流衝浪課」，我們教你如何像海豚一樣舞動，像狂烈激浪般跳舞。讓波浪成為你的伙伴，一同搭乘冒險的巔峰，享受大自然的幽默。',
88,
'流浪',
'./img/menu5.jpg',
0
),
(
'懼高症克服班',
'
信仰之躍，極限挑戰結合心理療法，化恐懼為力量，啟發勇氣，突破極限，讓每一次飛躍都成為人生的奇蹟。',
666,
'零差評',
'./img/menu6.jpg',
0
);


delimiter $$
create procedure login (acc varchar(20))
begin
select username,userpasswd,uid from account where username=acc;
end
$$
delimiter ;


delimiter $$
create procedure member (id bigint)	
begin
select membername,phone,sex,email,birthdate,county,district,address,identity from memberinfo,account where memberid=id and uid=id;
end
$$
delimiter ;

delimiter $$
create procedure forget (acc varchar(20))	
begin
select username,email,uid,phone from account,memberinfo where username=acc and uid=memberid;
end
$$
delimiter ;


delimiter $$
create procedure updatemember (name varchar(10),mail varchar(30),tel varchar(10),birth date, gender enum('1','2'),county_ varchar(10),district_ varchar(10),address_ varchar(30),id bigint)	
begin
update memberinfo set membername=name,email=mail,phone=tel,birthdate=birth,sex=gender,county=county_,district=district_,address=address_ where memberid=id;
select * from memberinfo;
end
$$
delimiter ;

