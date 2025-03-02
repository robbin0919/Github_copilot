@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: 設定路徑
set "SQLITE_PATH=..\bin\sqlite3.exe"
set "DB_PATH=..\db\bonds.db"
set "SQL_DIR=..\sql"
set "CSV_FILE=%1"
set "TEMP_CSV=..\temp\temp_bonds.csv"

:: 建立必要的目錄
if not exist "..\db" mkdir "..\db"
if not exist "..\temp" mkdir "..\temp"

:: [此處包含原始 ImportToSQLite.bat 的其餘程式碼]
:: 為了簡潔，這裡省略了主要處理邏輯，請參考之前提供的完整程式碼

endlocal