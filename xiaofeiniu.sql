SET NAMES UTF8;
DROP DATABASE IF EXISTS xiaofeiniu;
CREATE DATABASE xiaofeiniu CHARSET=UTF8;
USE xiaofeiniu;

/*管理员*/
CREATE TABLE xfn_admin(
	aid 		INT		PRIMARY KEY AUTO_INCREMENT,
	aname 	VARCHAR(32) UNIQUE,
	apwd		VARCHAR(64)
);
INSERT INTO xfn_admin VALUES
(NULL,'admin',PASSWORD('123456'));

/*全局设置表*/
CREATE TABLE xfn_settings(
	sid				INT		PRIMARY KEY AUTO_INCREMENT,
	appName 	VARCHAR(32),
	apiUrl		VARCHAR(64),
	adminUrl  VARCHAR(64),
	appUrl		VARCHAR(64),
	icp				VARCHAR(64),
	copyright	VARCHAR(128)
);
INSERT INTO xfn_settings VALUES
(NULL,'小肥牛','http://127.0.0.1:8090','http://127.0.0.1:8091','http://127.0.0.1:8092','京ICP备12003709号-3','Copyright © 北京达内金桥科技有限公司版权所有');

/*桌台信息*/
CREATE TABLE xfn_table(
	tid			INT		PRIMARY KEY AUTO_INCREMENT,
	tname 	VARCHAR(32),
	type 		VARCHAR(16),
	status 	BIGINT
);
INSERT INTO xfn_table VALUES
(1, '金镶玉', '2人桌', 3),
(2, '玉如意', '2人桌', 2),
(3, '齐天寿', '6人桌', 1),
(4, '888', '8人桌', 1),
(5, '福临门', '4人桌', 1),
(6, '全家福', '6人桌', 1),
(7, '展宏图', '2人桌', 1),
(8, '万年长', '8人桌', 1),
(9, '百事通', '4人桌', 1),
(10, '满堂彩', '10人桌', 1),
(11, '鸿运头', '8人桌', 1),
(12, '福满堂', '12人桌', 1),
(13, '高升阁', '4人桌', 1),
(15, '乐逍遥', '2人桌',1);

/*桌台预定信息*/
CREATE TABLE xfn_reservation(
  rid INT PRIMARY KEY AUTO_INCREMENT,
  contactName VARCHAR(32),
  phone VARCHAR(16) NOT NULL UNIQUE,
	customerCount 	INT,
  contactTime BIGINT,  /*联系时间*/
  dinnerTime BIGINT,	/*就餐时间*/
  tableId INT NOT NULL UNIQUE,
  FOREIGN KEY(tableId) REFERENCES xfn_table(tid) ON DELETE CASCADE ON UPDATE CASCADE
);


/*菜品类别*/
CREATE TABLE xfn_category(
	cid				INT		PRIMARY KEY AUTO_INCREMENT,
	cname 		VARCHAR(32)
);
INSERT INTO xfn_category VALUES
(1, '肉类'),
(2, '海鲜河鲜'),
(3, '丸滑类'),
(4, '蔬菜豆制品'),
(5, '菌菇类');


/*菜品*/
CREATE TABLE xfn_dish(
	did				INT		PRIMARY KEY AUTO_INCREMENT,
	title 		VARCHAR(32),
	imgUrl		VARCHAR(128),
	price 		DECIMAL(6,2),
	detail		VARCHAR(128),
	categoryId	INT,
	FOREIGN KEY(categoryId) REFERENCES xfn_category(cid) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO xfn_dish VALUES
(1,'草鱼片','rl1.jpg',35,'选鲜活草鱼，切出鱼片冷鲜保存。锅开后再煮1分钟左右即可食用。',1),
(2,'脆皮肠','rl2.jpg',12,'锅开后再煮3分钟左右即可食用。',1),
(3,'酥肉','rl3.jpg',20,'选用冷鲜五花肉，加上鸡蛋，淀粉等原料炸制，色泽黄亮，酥软醇香，肥而不腻。锅开后再煮3分钟左右即可食用。',1),
(4,'千层毛肚','rl4.jpg',20,'选自牛的草肚，加入葱、姜、五香料一起煮熟后切片而成。五香味浓、耙软化渣。锅开后再煮3分钟左右即可食用。',1),
(5,'澳洲肥牛','rl5.jpg',48,'百分百澳洲牛肉的前胸部位，口感香嫩，汁浓味厚。锅开后涮30秒即可食用。',1),
(6,'草原羔羊肉','rl6.jpg',48,'选自内蒙锡林郭勒大草原10月龄以下羔羊，经过排酸、切割、冷冻而成。锅开后涮30秒左右即可食用。',1),
(7,'鸭肠','rl7.jpg',38,'火锅三宝之一。鸭肠，具有韧性。口感脆爽有嚼劲，是火锅中经常用到的食材。鸭肠口感自然脆爽，下锅涮食20-25秒左右即可食用。',1),
(8,'冻虾','hx1.jpg',40,'将活虾冷冻而成。肉质脆嫩，锅开后再煮4分钟左右即可食用。',2);



/*订单*/
CREATE TABLE xfn_order(
	oid				INT		PRIMARY KEY AUTO_INCREMENT,
	startTime BIGINT,
	endTime		BIGINT,
	customerCount 	INT,
	tableId		INT NOT NULL UNIQUE,
	FOREIGN KEY(tableId) REFERENCES xfn_table(tid) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO xfn_order VALUES
(1, '1547800000000', '1547814918000', '2','3'),
(2, '1557800000000', '1557814918000', '6','1'),
(3, '1567800000000', '1567814918000', '4','9'),
(4, '1577800000000', '1577814918000', '3','13'),
(5, '1587800000000', '1587814918000', '2','15');

/*订单详情*/
CREATE TABLE xfn_order_detail(
	did				INT		PRIMARY KEY AUTO_INCREMENT,
	dishId 		INT,			/*菜品编号*/
	dishCount	INT,			/*份数*/
	customerName 	VARCHAR(32),	/*顾客名称*/
	orderId		INT,			/*订单编号*/
	FOREIGN KEY(dishId) REFERENCES xfn_dish(did) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY(orderId) REFERENCES xfn_order(oid) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO xfn_order_detail VALUES
(1, '1', '1', '丁丁', '1'),
(2, '2', '1', '丁丁', '1'),
(3, '3', '1', '丁丁', '1'),
(4, '4', '2', '丁丁', '1'),
(5, '5', '1', '丁丁', '1'),
(6, '2', '1', '当当', '2'),
(7, '4', '1', '当当', '2'),
(8, '6', '1', '当当', '2'),
(9, '7', '1', '当当', '2'),
(10, '8', '2', '当当', '2'),
(11, '2', '1', '当当', '2'),
(12, '1', '2', '当当', '2'),
(13, '1', '1', '花花', '3'),
(14, '2', '1', '花花', '3'),
(15, '4', '1', '花花', '3'),
(16, '5', '1', '小明', '4'),
(17, '4', '1', '小明', '4'),
(18, '1', '1', '小明', '4'),
(19, '2', '2', '小明', '4'),
(20, '7', '1', '丫丫', '5'),
(21, '8', '1', '丫丫', '5'),
(22, '4', '1', '丫丫', '5');
