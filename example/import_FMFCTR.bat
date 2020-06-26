@echo off

SET PRJ_DIR=D:\db-import\fmfctr
::set date
set TODAY=%date:~10,4%%date:~4,2%%date:~7,2%

echo Please wait a while ...
::date -1
set day1=-1
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day1%,now) : d=weekday(s)
echo >>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "result=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%result:~0,4%"
set "MM=%result:~4,2%"
set "DD=%result:~6,2%"
set "Date1=%yyyy%%mm%%dd%"
::date -2
set day2=-2
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day2%,now) : d=weekday(s)
echo >>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "result=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%result:~0,4%"
set "MM=%result:~4,2%"
set "DD=%result:~6,2%"
set "Date2=%yyyy%%mm%%dd%"

::set log file
Set LogFile=CBRP_%TODAY%.txt

::set path
SET FMFCTR_DIR=%PRJ_DIR%\csv\
SET LOG_DIR=%PRJ_DIR%\logs\%LogFile%
SET LOG_SQL=%PRJ_DIR%\logs\
SET CTL_FILE=%PRJ_DIR%\ctl\FMFCTR.ctl
SET CREATE_SCRIPT=%PRJ_DIR%\sql\create_table.sql
SET RENAME_SCRIPT=%PRJ_DIR%\sql\rename_table.sql
SET DELETE_SCRIPT=%PRJ_DIR%\sql\delete_table.sql


::if you have this logfile then delete it.
If exist "%LOG_DIR%" Del "%LOG_DIR%"
echo "LOGDATE %TODAY%" >> "%LOG_DIR%"

echo Please wait a while ...

SET TABLE_NAME=TEST_FMFCTR
SET RENAME_SQL=RENAME %TABLE_NAME% TO %TABLE_NAME%_%Date1%;
echo %RENAME_SQL% > %RENAME_SCRIPT%
SET DELETE_SQL=DROP TABLE %TABLE_NAME%_%Date2%;
echo %DELETE_SQL% > %DELETE_SCRIPT%
:: ----------------------------------------
SET DB_USER=xxxx
SET DB_PASS=xxxx
SET DB_NAME=xxxx
:: ----------------------------------------
::START_SQL RENAME
ECHO "%RENAME_SQL%" >> "%LOG_DIR%"
exit | sqlplus %DB_USER%/%DB_PASS%@%DB_NAME% @%RENAME_SCRIPT%
if %ERRORLEVEL% ==  0 GOTO RENAME_SUCCESSFUL
if %ERRORLEVEL% NEQ 0 GOTO RENAME_ERROR

:RENAME_SUCCESSFUL
ECHO "The SQL rename successful" >> "%LOG_DIR%"
::CREATE TABLE FMFCTR
ECHO "%CREATE_SCRIPT%" >> "%LOG_DIR%"
EXIT | sqlplus %DB_USER%/%DB_PASS%@%DB_NAME% @%CREATE_SCRIPT%
GOTO READ_CSV

:RENAME_ERROR 
echo "THE SQL rename failed" >> "%LOG_DIR%"
GOTO END


::find name of csv
:READ_CSV
SETLOCAL ENABLEDELAYEDEXPANSION
@FOR /f "delims=" %%f IN ('dir /b /s "%FMFCTR_DIR%\*.csv"') DO (
    set /a "idx+=1"
	echo [!idx!] sqlldr userid=%DB_USER%/%DB_PASS%@%DB_NAME% data=%%f control=%CTL_FILE% log=%LOG_SQL%%%~nf.log  >> "%LOG_DIR%"
	EXIT | sqlldr userid=%DB_USER%/%DB_PASS%@%DB_NAME% data=%%f control=%CTL_FILE%  log=%LOG_SQL%%%~nf.log 
	if %ERRORLEVEL% ==  0 echo "SQL*Loader execution successful" >> "%LOG_DIR%"
	if %ERRORLEVEL% NEQ 0 echo "SQL*Loader execution failed" >> "%LOG_DIR%"
	echo ************************************ >> "%LOG_DIR%"
)
exit | sqlplus %DB_USER%/%DB_PASS%@%DB_NAME% @%DELETE_SCRIPT%
if %ERRORLEVEL% ==  0 GOTO DELETE_SUCCESSFUL
if %ERRORLEVEL% NEQ 0 GOTO DELETE_ERROR

:DELETE_SUCCESSFUL
ECHO "The SQL delete successful" >> "%LOG_DIR%"
GOTO END

:DELETE__ERROR 
echo "THE SQL delete failed" >> "%LOG_DIR%"
GOTO END


TimeOut /T 10 /nobreak>nul
:END
ECHO Total files(s) read : !idx! >> %LOG_DIR%
echo End process ...
Start "" "%LOG_DIR%"

:: EOF ::
