use lab01;
-- 3
DELIMITER //
create procedure updateReaderID ( in rid_new char(8) , in rid_old char(8) )
begin
    SET FOREIGN_KEY_CHECKS = 0;
    update borrow set reader_id=rid_new where reader_id=rid_old;
    update reader set rid=rid_new where rid=rid_old;
    SET FOREIGN_KEY_CHECKS = 1;
end //
DELIMITER ;
drop procedure updateReaderID;

-- test 
call updateReaderID('R999', 'R006');
select * from reader;
select * from borrow;

-- 复原
call updateReaderID('R006', 'R999');
