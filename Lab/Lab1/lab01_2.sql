-- test
select * from book;
select * from reader;
select * from borrow;
select * from reserve;

-- 2.1
select borrow.book_id, book.bname, borrow.borrow_date from borrow, book 
where borrow.reader_id in (select rid from reader where rname='Rose')
and book.bid=borrow.book_id;

-- 2.2
select rid, rname from reader where not exists (select reader_id from borrow where borrow.reader_id=reader.rid)
and not exists (select reader_id from reserve where reserve.reader_id=reader.rid);

-- 2.3
-- 方法1
select author from (select book.author, book_time.times from book, (select book_id, count(book_id)as times from borrow group by book_id)book_time
where book.bid=book_time.book_id)author_time group by author order by sum(times) desc limit 1;

-- 方法2
select author from book group by author order by sum(borrow_times) desc limit 1;

-- 2.4
select bid, bname from book where bstatus='1' and bname like '%MySQL%';

-- 2.5
select rname from reader where rid in (select reader_id from borrow group by reader_id having count(reader_id)>3);

-- 2.6
select rid, rname from reader where rid not in (select reader_id from borrow where book_id in (select bid from book where author='J.K. Rowling'));

-- 2.7
select reid.reader_id, reader.rname, reid.num from (select reader_id, count(reader_id) as num from (select * from borrow where year(borrow_date) <= 2024)new_borrow
group by reader_id order by num desc limit 3)reid, reader where reader.rid= reid.reader_id;

-- 2.8
create view reader_borrow(rid, rname, bid, bname, bdate)
as select borrow.reader_id, reader.rname, borrow.book_id, book.bname, borrow.borrow_date from borrow, reader, book
where borrow.book_id=book.bid and borrow.reader_id=reader.rid;

select * from reader_borrow;

select rid, count(distinct bid) from reader_borrow where year(bdate)='2024' group by rid;
