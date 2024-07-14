-- create library
drop database if exists library;
create database library;

-- use library
use library;

-- 设置字符集合
SET NAMES utf8mb4;

-- 禁用外键约束
SET FOREIGN_KEY_CHECKS = 0;

-- create table for books
DROP TABLE IF EXISTS books;
CREATE TABLE books(
  `书号` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL primary key,
  `书名` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `作者` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `类型` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `价格` float NULL DEFAULT NULL,
  `出版社` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `馆藏册数` int NULL DEFAULT NULL,
  `在馆册数` int NULL DEFAULT NULL,
  `位置` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `被借次数` int NULL DEFAULT NULL,
  constraint check ('馆藏册数' >= '在馆册数')
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;


-- backend/create.sql
-- create readers
DROP TABLE IF EXISTS `readers`;
CREATE TABLE readers(
  `读者号` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL primary key,
  `姓名` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `性别` enum('男','女') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `系别` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `可借册数` int NULL DEFAULT 3,
  `在借册数` int NULL DEFAULT 0,
   `密码` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '123456',
  `欠款` float NULL DEFAULT 0,
  `个人照片` mediumblob
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;


-- create table for workers
DROP TABLE IF EXISTS workers;
CREATE TABLE workers(
  `管理号` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL primary key,
  `姓名` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `性别` enum('男','女') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `手机号` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `密码` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '123456'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- create table for borrow
DROP TABLE IF EXISTS `borrow`;
CREATE TABLE `borrow`(
  `读者号` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `书号` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `借书时间` date NOT NULL,
  `应还日期` date NOT NULL,
  `归还日期` date NULL DEFAULT NULL,
  `是否归还` enum('是','否') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '否',
  `是否逾期` enum('是','否') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '否',
  `事务编号` int auto_increment primary key
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;


-- backend/create.sql
DELIMITER //
create trigger reserve_times after insert on borrow for each row
begin
	update books set 被借次数=被借次数+1, 在馆册数=在馆册数-1 where 书号=new.书号;
end //
DELIMITER ;
select * from workers;
select * from borrow;
select * from readers;
select * from books;
update readers set 在借册数=在借册数-1, 可借册数=可借册数+1 where 读者号="123";
-- backend/create.sql
DELIMITER //
create procedure setimg ( in imgpath varchar(100) , in rid varchar(15), in rname varchar(20), in sex enum('男','女'), 
                         in part varchar(45), in pw varchar(20))
begin
     declare img blob;
     set img = load_file(imgpath);
     insert into readers(读者号, 姓名, 性别, 系别, 密码, 个人照片)
     values(rid,rname,sex,part,pw,img);
end //
DELIMITER ;
-- 加回外键约束
SET FOREIGN_KEY_CHECKS = 1;