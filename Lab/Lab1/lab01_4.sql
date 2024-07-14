-- 4
use lab01;
DELIMITER //
create procedure borrowBook ( in b_id char(8) , in r_id char(8) , in b_date date)
begin
    declare state int default 0;
	declare if_reserve int default 0;
	declare if_have_borrow int default 0;
	declare borrow_count int default 0;
	declare bid_ char(8);
    declare rid_ char(8);
	declare bdate_ date;
    declare rdate_ date;
	declare reserve_cu cursor for select book_id, reader_id from reserve;
    declare borrow_cu_date cursor for select book_id, reader_id, borrow_date from borrow;
    declare borrow_cu_count cursor for select reader_id, return_date from borrow;
    declare continue handler for not found set state=1;
    -- 判断是否预约
    open reserve_cu;
    while state=0 and if_reserve=0 do
		fetch reserve_cu into bid_, rid_;
        if bid_=b_id and rid_=r_id then
			set if_reserve=1;
		end if;
    end while;
    close reserve_cu;
    set state=0;
    
    if if_reserve=1 then
		-- 判断是否当天借过
        open borrow_cu_date;
        while state=0 do
			fetch borrow_cu_date into bid_, rid_, bdate_;
            if bid_=b_id and rid_=r_id and bdate_=b_date then
				set if_have_borrow=1;
            end if;
        end while;
        close borrow_cu_date;
        set state=0;
        -- 判断是否借书超过3本
        if if_have_borrow=0 then
            open borrow_cu_count;
            while state=0 do
				fetch borrow_cu_count into rid_, rdate_;
                if rid_=r_id and rdate_ is null then
					set borrow_count=borrow_count+1;
                end if;
            end while;
            close borrow_cu_count;
			-- 处理借书
            if borrow_count<3 then
				update book set borrow_times=borrow_times+1, bstatus=1 where bid=b_id;
                delete from reserve where book_id=b_id and reader_id=r_id;
                insert into borrow(book_id, reader_id, borrow_date)
                values
                (b_id, r_id, b_date);
			else 
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '借阅失败';
            end if;
		else
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '借阅失败';
        end if;
	else 
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '借阅失败';
    end if;
end //
DELIMITER ;
drop procedure borrowBook;

-- test
call borrowBook('B008', 'R001', '2024-3-28');
call borrowBook('B001', 'R001', '2024-3-28');
call borrowBook('B008', 'R005', '2024-3-28');
select * from book;
select * from reserve;
select * from borrow;

-- 复原
INSERT INTO reserve (book_id, reader_id, take_date)
VALUES
('B001', 'R001', '2024-04-08');
update book set bstatus=2,borrow_times=borrow_times-1 where bid='B001';
delete from borrow where book_id='B001' and reader_id='R001';
