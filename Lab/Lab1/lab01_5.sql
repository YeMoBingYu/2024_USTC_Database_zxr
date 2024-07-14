-- 5
use lab01;
DELIMITER //
create procedure returnBook ( in b_id char(8), in r_id char(8), in r_date date)
begin
	declare state int default 0;
    declare if_return int default 0;
    declare if_reserve int default 0;
    declare bid_ char(8);
    declare rid_ char(8);
    declare rdate_ date;
	declare borrow_cur cursor for select book_id, reader_id, return_date from borrow;
    declare reserve_cur cursor for select book_id from reserve;
    declare continue handler for not found set state=1;
    open borrow_cur;
    while state=0 do
		fetch borrow_cur into bid_, rid_, rdate_;
        if bid_=b_id and r_id=r_id and rdate_ is null then
			set if_return=1;
            update borrow set return_date=r_date where book_id=b_id and reader_id=r_id and return_date is null;
        end if;
    end while;
    close borrow_cur;
    set state=1;
    if if_return=1 then
		open reserve_cur;
        while state=0 and if_reserve=0 do
			fetch reserve_cur into bid_;
            if bid_=b_id then
				set if_reserve=1;
            end if;
        end while;
        close reserve_cur;
	else 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '还书失败';
    end if;
    if if_return=1 and if_reserve=1 then
		update book set bstatus=1 where bid=b_id;
	elseif if_return=1 and if_reserve=0 then
        update book set bstatus=0 where bid=b_id;
    end if;
end //
DELIMITER ;
drop procedure returnBook;

-- test
call returnBook('B008', 'R001', '2024-3-29');
call returnBook('B001', 'R001', '2024-3-29');
select * from book;
select * from borrow;
select * from reserve;