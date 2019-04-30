------------------------------------------------------------------------------
create table table_demo(
  НомДок      char(10) primary key,
  МфоДб       number(10),
  РрДб        varchar(14),
  НаимДб      varchar(40),
  ОкпоДв      varchar(14),
  МфоКр       number(10),
  РрКр        varchar(14),
  НаимКр      varchar(40),
  ОкпоКр      varchar(14),
  Сума        double not null,
  Назн        varchar(160),
  Дата        date not null,
  ДатаПров    date,
  КодВал      number(10)
);
------------------------------------------------------------------------------
     CREATE TABLE t1 (t1key INTEGER
                  PRIMARY KEY,data TEXT,num double,timeEnter DATE);

     INSERT INTO "t1" VALUES(1, 'This is sample data', 3, NULL);
     INSERT INTO "t1" VALUES(2, 'More sample data', 6, NULL);
     INSERT INTO "t1" VALUES(3, 'And a little more', 9, NULL);
------------------------------------------------------------------------------
