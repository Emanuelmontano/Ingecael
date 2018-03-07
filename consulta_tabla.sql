select pk,fk, un, data_type, data_length, nullable, data_default ,
uno||substr(COLUMN_NAME, 2, ext) column_name, 
'private '||data_type||' '||uno||substr(COLUMN_NAME, 2, ext) texto
from (
Select 
 decode (
 (select count(*) from  user_cons_columns c, all_constraints m
where 
 c.CONSTRAINT_NAME=m.CONSTRAINT_NAME
and m.CONSTRAINT_TYPE='P'
and  t.table_name=c.table_name
and c.column_name=t.column_name and rownum=1 )
,1,1,0) pk,
 decode (
 (select count(*) from  user_cons_columns c, all_constraints m
where 
 c.CONSTRAINT_NAME=m.CONSTRAINT_NAME
and m.CONSTRAINT_TYPE='R'
and  t.table_name=c.table_name
and c.column_name=t.column_name and rownum=1 )
,1,1,0) fk,
 decode (
 (select count(*) from  user_cons_columns c, all_constraints m
where 
 c.CONSTRAINT_NAME=m.CONSTRAINT_NAME
and m.CONSTRAINT_TYPE='U'
and  t.table_name=c.table_name
and c.column_name=t.column_name and rownum=1 )
,1,1,0) un,
replace(INITCAP(replace(t.COLUMN_NAME, '_', ' ')), ' ', '') COLUMN_NAME, 
lower(substr(replace(INITCAP(replace(t.COLUMN_NAME, '_', ' ')), ' ', ''), 1, 1)) uno, 
(LENGTH(replace(INITCAP(replace(t.COLUMN_NAME, '_', ' ')), ' ', ''))-1) ext, 
decode(t.DATA_TYPE, 'VARCHAR2', 'String', 'NUMBER', 'Long', 'DATE', 'Date', t.DATA_TYPE) DATA_TYPE,
t.DATA_LENGTH, t.NULLABLE, t.DATA_DEFAULT  
from  user_tab_columns t
where t.table_name='M02_ASOCIA_CANAL_P'
order by 1 desc,2 desc,3  desc);