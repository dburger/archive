-- insert records from table2 into table1 where the record does not exist in
-- table1
INSERT INTO table1 (
    SELECT t2.* FROM table2 t2 LEFT JOIN table1 t1
    ON t2.id = t1.id WHERE t1.id IS NULL
);
