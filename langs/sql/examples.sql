-- insert records from table2 into table1 where the record does not exist in
-- table1 (MySql)
INSERT INTO table1 (
    SELECT t2.* FROM table2 t2 LEFT JOIN table1 t1
    ON t2.id = t1.id WHERE t1.id IS NULL
);

-- same as above, real world example (MySql)
INSERT INTO dses_rollup.dbo.unit_dimension
    (uic, short_name, long_name, service, parent_uic, major_command_uic,
     organization_type, activity_code, activity_description, geo_code,
     geo_name, geo_region, source, effective_date, expiration_date,
     current_unit)
(
 SELECT
     uhe.uic, uhe.short_name, uhe.long_name, uhe.service, uhe.parent_uic,
     uhe.major_command_uic, uhe.organization_type, uhe.activity_code,
     uhe.activity_description, uhe.geo_code, uhe.geo_name, uhe.geo_region,
     uhe.source, '1900-01-01', '9999-12-31', 1
 FROM
     dses_etl.dbo.unit_hierarchy_editor uhe LEFT JOIN
     dses_rollup.dbo.unit_dimension ud ON uhe.uic = ud.uic
 WHERE
     uhe.source = 'UNIT HIERARCHY EDITOR' AND
     ud.id IS NULL
);

-- dynamically determine latest table name for usage in an update query
-- (SQL Server)
DECLARE @table_name AS VARCHAR(MAX)
DECLARE @sql AS VARCHAR(MAX)

SELECT TOP 1 @table_name = table_name FROM stg_person.information_schema.tables
WHERE table_name LIKE 'person_2%' ORDER BY table_name DESC

SET @sql = 'UPDATE dses_rollup.dbo.dses_data_sources
            SET last_update = (
                SELECT CAST(CAST(MAX(effective_year) AS VARCHAR(255))+
                ''-''+CAST(MAX(effective_month) AS VARCHAR(255))+''-''+CAST(DAY(DATEADD(d,
                -DAY(DATEADD(m,1,GETDATE())),DATEADD(m,1,GETDATE()))) AS VARCHAR(255))
                AS DATETIME) FROM stg_person.dbo.'+@table_name+
           ')
            WHERE name = ''DMDC CIVILIAN PERSONNEL'''
exec(@sql)

-- mysql has an default escape character \
SELECT * FROM people WHERE symbol LIKE 'hello\_world';
-- or you can specify the escape character
SELECT * FROM people WHERE symbol LIKE 'hello|_world' ESCAPE '|';

-- tsql has no default but you can go with a single character class
SELECT * FROM people WHERE symbol LIKE 'hello[_]world';
-- or you can specify an escape character
SELECT * FROM people WHERE symbol LIKE 'hello|_world' ESCAPE '|';
