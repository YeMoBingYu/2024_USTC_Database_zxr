-- 6
use lab01;
DELIMITER //
create trigger reserve_insert after insert on reserve for each row
begin
	update book set bstatus=2, reserve_times=reserve_times+1 where bid=new.book_id;
end //
DELIMITER ;
drop trigger reserve_insert;

DELIMITER //
create trigger reserve_delete after delete on reserve for each row
begin
	update book set reserve_times=reserve_times-1 where bid=old.book_id;
    update book set bstatus=0 where bid=old.book_id and bstatus=2 and reserve_times=0;
end //
DELIMITER ;
drop trigger reserve_delete;
select * from books;

-- test
insert into reserve (book_id, reader_id, take_date)
values
('B012', 'R001', '2024-5-9');
delete from reserve where book_id='B012' and reader_id='R001';
select * from reserve;
select * from book;