@echo off
setlocal EnableDelayedExpansion

:: 設定 UTF-8 編碼
chcp 65001 >nul

:: 讀取設定檔
set /p UTC_TIME=<..\config\time.txt
set /p USER_LOGIN=<..\config\user.txt

echo 開始執行債券資料處理程序
echo =============================
echo 執行時間: %UTC_TIME%
echo 執行使用者: %USER_LOGIN%
echo.

:: 執行資料處理
echo 步驟 1: 處理債券資料
call ProcessBonds.bat "%UTC_TIME%" "%USER_LOGIN%"
if errorlevel 1 (
    echo 錯誤：債券資料處理失敗
    goto :error
)

:: 取得最新的 CSV 檔案
for /f "delims=" %%a in ('dir /b /o:d ..\output\bonds_*.csv') do set "LATEST_CSV=%%a"

:: 執行資料庫導入
echo.
echo 步驟 2: 導入資料庫
call ImportToSQLite.bat "..\output\%LATEST_CSV%"
if errorlevel 1 (
    echo 錯誤：資料庫導入失敗
    goto :error
)

echo.
echo 處理完成！
echo =============================
goto :end

:error
echo.
echo 處理過程中發生錯誤！
echo 請檢查記錄檔以取得詳細資訊。

:end
pause
endlocal