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

-- tsql style multi table update
UPDATE employment_statuses SET
    mde_id = esd.id
FROM employment_statuses es JOIN
   mde_mishaps.dbo.employment_statuses_dim esd ON
   es.tier1 = esd.employment_status_tier1 AND
   es.tier2 = esd.employment_status_tier2

-- some updates against a fact table from several raw tables, uses cursor etc.
-- on tsql
IF NOT EXISTS (SELECT * FROM information_schema.columns WHERE column_name = 'transport_mode' AND table_name = 'traces_fact')
BEGIN
  ALTER TABLE dbo.traces_fact ADD transport_mode VARCHAR(255)

  -- this only needs to be ran the first time we add these columns as the
  -- populate_traces_fact will handle filling in these columns for all new
  -- records in the future
  DECLARE @table_name VARCHAR(255)
  DECLARE @sql_string VARCHAR(4000)
  DECLARE mycursor CURSOR FOR SELECT table_name
      FROM stg_raw.information_schema.tables
      WHERE table_name LIKE 'traces_%'
  OPEN mycursor
  FETCH NEXT FROM mycursor INTO @table_name
  WHILE @@fetch_status = 0
  BEGIN
      SET @sql_string = 'UPDATE dbo.traces_fact SET
                            age = raw.age,
                            age_unit = raw.age_unit,
                            cite = raw.cite,
                            db = raw.db,
                            gender = raw.gender,
                            mission_id#_of_last_mission = raw.mission_id#_of_last_mission,
                            personnel_status_name = raw.personnel_status_name,
                            service_active_duty = raw.service_active_duty,
                            service_grade_code = raw.service_grade_code,
                            service_grade_name = raw.service_grade_name
                        FROM dbo.traces_fact JOIN stg_raw.dbo.' + @table_name + ' raw
                            ON dbo.traces_fact.pmr_identifier = raw.pmr_identifier'
      EXEC(@sql_string)
      FETCH NEXT FROM mycursor INTO @table_name
  END
  CLOSE mycursor
  DEALLOCATE mycursor
END
