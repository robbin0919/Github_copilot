@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: ========== 初始化設定 ==========
:: 設定時間和使用者
set "UTC_TIME=%1"
set "USER_LOGIN=%2"

:: 如果沒有提供參數，使用預設值
if "%UTC_TIME%"=="" set "UTC_TIME=2025-02-15 07:38:05"
if "%USER_LOGIN%"=="" set "USER_LOGIN=robbin0919"

:: 設定檔案路徑
set "INPUT_FILE=input_bonds.txt"
set "OUTPUT_DIR=output"
set "OUTPUT_CSV=%OUTPUT_DIR%\bonds_%UTC_TIME:~0,10%_%UTC_TIME:~11,2%%UTC_TIME:~14,2%.csv"
set "LOG_FILE=%OUTPUT_DIR%\process_%UTC_TIME:~0,10%.log"
set "ERROR_LOG=%OUTPUT_DIR%\error_%UTC_TIME:~0,10%.log"

:: 建立輸出目錄
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: 移除檔名中的冒號
set "OUTPUT_CSV=!OUTPUT_CSV::=!"

:: ========== 開始執行 ==========
echo ====================================
echo 債券資料處理程式
echo 版本: 1.0.0
echo 執行時間: %UTC_TIME%
echo 執行使用者: %USER_LOGIN%
echo ====================================
echo.

:: 記錄開始執行
echo [%UTC_TIME%] 開始執行債券資料處理 >> "%LOG_FILE%"
echo [%UTC_TIME%] 執行使用者: %USER_LOGIN% >> "%LOG_FILE%"

:: 檢查輸入檔案
if not exist "%INPUT_FILE%" (
    echo 錯誤：找不到輸入檔案 %INPUT_FILE%
    echo [%UTC_TIME%] 錯誤：找不到輸入檔案 %INPUT_FILE% >> "%ERROR_LOG%"
    goto :error
)

:: 建立 CSV 標題
(
    echo 執行時間,執行者,債券代碼,債券名稱,標籤,參考報價日期,參考申購報價,票面利率,配息頻率,到期日,YTM/YTC,產業別,計價幣別,最低申購面額,風險等級
) > "%OUTPUT_CSV%"

:: ========== 初始化變數 ==========
set "current_bond="
set "bond_code="
set "bond_name="
set "tags="
set "quote_date="
set "purchase_price="
set "coupon_rate="
set "payment_freq="
set "maturity_date="
set "ytm_ytc="
set "industry="
set "currency="
set "min_purchase="
set "risk_level="
set "record_count=0"

:: ========== 讀取並處理輸入檔案 ==========
echo 開始處理輸入檔案...
echo [%UTC_TIME%] 開始讀取檔案 %INPUT_FILE% >> "%LOG_FILE%"

for /f "usebackq delims=" %%a in ("%INPUT_FILE%") do (
    set "line=%%a"
    
    :: 跳過空行，開始新的債券資料
    if "!line!"=="" (
        if defined bond_code (
            :: 輸出已收集的債券資料到 CSV
            echo %UTC_TIME%,%USER_LOGIN%,!bond_code!,!bond_name!,!tags!,!quote_date!,!purchase_price!,!coupon_rate!,!payment_freq!,!maturity_date!,!ytm_ytc!,!industry!,!currency!,!min_purchase!,!risk_level! >> "%OUTPUT_CSV%"
            set /a "record_count+=1"
            
            :: 記錄處理的債券
            echo [%UTC_TIME%] 處理債券: !bond_code! >> "%LOG_FILE%"
            
            :: 重設變數
            set "bond_code="
            set "bond_name="
            set "tags="
            set "quote_date="
            set "purchase_price="
            set "coupon_rate="
            set "payment_freq="
            set "maturity_date="
            set "ytm_ytc="
            set "industry="
            set "currency="
            set "min_purchase="
            set "risk_level="
        )
    ) else (
        :: 解析債券代碼和名稱（第一行）
        echo !line! | findstr /r "^WMBB[0-9]" >nul
        if !errorlevel! equ 0 (
            for /f "tokens=1,*" %%b in ("!line!") do (
                set "bond_code=%%b"
                set "bond_name=%%c"
            )
        ) else (
            :: 解析標籤（第二行）
            if not defined tags (
                set "tags=!line!"
            ) else (
                :: 解析其他欄位
                if "!line!"=="參考報價日期" set "next_is_quote_date=1" & goto :continue
                if defined next_is_quote_date set "quote_date=!line!" & set "next_is_quote_date=" & goto :continue
                
                if "!line!"=="參考申購報價" set "next_is_purchase_price=1" & goto :continue
                if defined next_is_purchase_price set "purchase_price=!line!" & set "next_is_purchase_price=" & goto :continue
                
                if "!line!"=="票面利率" set "next_is_coupon_rate=1" & goto :continue
                if defined next_is_coupon_rate set "coupon_rate=!line!" & set "next_is_coupon_rate=" & goto :continue
                
                if "!line!"=="配息頻率" set "next_is_payment_freq=1" & goto :continue
                if defined next_is_payment_freq set "payment_freq=!line!" & set "next_is_payment_freq=" & goto :continue
                
                if "!line!"=="到期日" set "next_is_maturity_date=1" & goto :continue
                if defined next_is_maturity_date set "maturity_date=!line!" & set "next_is_maturity_date=" & goto :continue
                
                if "!line!"=="YTM/YTC" set "next_is_ytm_ytc=1" & goto :continue
                if defined next_is_ytm_ytc set "ytm_ytc=!line!" & set "next_is_ytm_ytc=" & goto :continue
                
                if "!line!"=="產業別" set "next_is_industry=1" & goto :continue
                if defined next_is_industry set "industry=!line!" & set "next_is_industry=" & goto :continue
                
                if "!line!"=="計價幣別" set "next_is_currency=1" & goto :continue
                if defined next_is_currency set "currency=!line!" & set "next_is_currency=" & goto :continue
                
                if "!line!"=="最低申購面額" set "next_is_min_purchase=1" & goto :continue
                if defined next_is_min_purchase set "min_purchase=!line!" & set "next_is_min_purchase=" & goto :continue
                
                if "!line!"=="風險等級" set "next_is_risk_level=1" & goto :continue
                if defined next_is_risk_level set "risk_level=!line!" & set "next_is_risk_level=" & goto :continue
            )
        )
    )
    :continue
)

:: 處理最後一筆債券資料
if defined bond_code (
    echo %UTC_TIME%,%USER_LOGIN%,!bond_code!,!bond_name!,!tags!,!quote_date!,!purchase_price!,!coupon_rate!,!payment_freq!,!maturity_date!,!ytm_ytc!,!industry!,!currency!,!min_purchase!,!risk_level! >> "%OUTPUT_CSV%"
    set /a "record_count+=1"
    echo [%UTC_TIME%] 處理債券: !bond_code! >> "%LOG_FILE%"
)

:: ========== 清理數據 ==========
echo 清理數據格式...
echo [%UTC_TIME%] 開始清理數據格式 >> "%LOG_FILE%"

set "TEMP_CSV=%OUTPUT_DIR%\temp.csv"
if exist "%TEMP_CSV%" del "%TEMP_CSV%"

for /f "usebackq delims=" %%a in ("%OUTPUT_CSV%") do (
    set "line=%%a"
    :: 保留標題行的百分比符號
    echo %%a | findstr /C:"執行時間" >nul
    if !errorlevel! equ 0 (
        echo !line! >> "%TEMP_CSV%"
    ) else (
        set "line=!line:%%=!"
        set "line=!line:,%%=,!"
        echo !line! >> "%TEMP_CSV%"
    )
)

move /y "%TEMP_CSV%" "%OUTPUT_CSV%" >nul

:: ========== 輸出處理結果 ==========
echo.
echo 處理完成！
echo ----------------------------------------
echo 處理結果摘要：
echo 輸入檔案：%INPUT_FILE%
echo 輸出檔案：%OUTPUT_CSV%
echo 處理記錄：%LOG_FILE%
echo 處理筆數：%record_count%
echo ----------------------------------------

:: 記錄完成訊息
echo [%UTC_TIME%] 處理完成，共處理 %record_count% 筆資料 >> "%LOG_FILE%"
echo [%UTC_TIME%] 輸出檔案：%OUTPUT_CSV% >> "%LOG_FILE%"
goto :end

:error
echo.
echo 處理過程中發生錯誤！
echo 請檢查錯誤記錄：%ERROR_LOG%
exit /b 1

:end
echo.
echo 按任意鍵結束...
pause >nul
endlocal