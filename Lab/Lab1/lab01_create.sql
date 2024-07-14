create database lab01;
use lab01;
create table book(
  bid char(8) primary key,
  bname varchar(100) NOT NULL,
  author varchar(50),
  price float,
  borrow_times int default 0,
  reserve_times int default 0,
  bstatus int default 0
);

create table reader(
  rid char(8) primary key,
  rname varchar(20),
  age int,
  address varchar(100)
);

create table borrow(
  book_id char(8),
  reader_id char(8),
  borrow_date Date,
  return_date Date,
  primary key (book_id, reader_id, borrow_date),
  foreign key (book_id) references book(bid),
  foreign key (reader_id) references reader(rid)
);

create table reserve(
  book_id char(8),
  reader_id char(8),
  reserve_date DATE,
  take_date date,
  primary key (book_id, reader_id, take_date),
  check (take_date > reserve_date)
);