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
 initcap(replace(lower(t.COLUMN_NAME), '_' , ' ')), 
decode(t.DATA_TYPE, 'VARCHAR2', 'String', 'NUMBER', 'Long', 'DATE', 'Date', t.DATA_TYPE) DATA_TYPE,
t.DATA_LENGTH, t.NULLABLE, t.DATA_DEFAULT  
from  user_tab_columns t
where t.table_name='M02_MEDIDORES'
order by 1 desc,2 desc,3  desc