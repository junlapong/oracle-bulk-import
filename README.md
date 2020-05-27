# Oracle

## Requirement

1. rename import_tabble to import_table_tmp
2. create empty import_table
3. sqlldr import.csv to import_table

## References

- [Run Oracle SQL script and exit from sqlplus.exe via command prompt](https://serverfault.com/questions/87035/run-oracle-sql-script-and-exit-from-sqlplus-exe-via-command-prompt)
- [การโหลดข้อมูลจำนวนมาก เข้า Oracle โดยใช้ Oracle Bulk Loader](http://ottoshi.blogspot.com/2011/01/oracle-oracle-bulk-loader_197.html)
- [วิธีการใช้ SQL*Loader utility สำหรับ Load ข้อมูลจาก text file เข้า table](http://oracle.jookku.com/2011/04/%E0%B8%A7%E0%B8%B4%E0%B8%98%E0%B8%B5%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B9%83%E0%B8%8A%E0%B9%89-sqlloader-utility-%E0%B8%AA%E0%B8%B3%E0%B8%AB%E0%B8%A3%E0%B8%B1%E0%B8%9A-load-%E0%B8%82%E0%B9%89%E0%B8%AD/)
- [SQL*Loader โหลดข้อมูลจาก Text เข้า Table -ตัวอย่างที่2](http://oracle.jookku.com/2011/04/sqlloader-%E0%B9%82%E0%B8%AB%E0%B8%A5%E0%B8%94%E0%B8%82%E0%B9%89%E0%B8%AD%E0%B8%A1%E0%B8%B9%E0%B8%A5%E0%B8%88%E0%B8%B2%E0%B8%81-text-%E0%B9%80%E0%B8%82%E0%B9%89%E0%B8%B2-table-%E0%B8%95%E0%B8%B1/)

### Docker Image

- https://github.com/junlapong/oracle-docker-images/tree/master/OracleDatabase/SingleInstance
