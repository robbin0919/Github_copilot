@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: ========== 初始化設定 ==========
:: 設定投資金額（可調整）
set "INVESTMENT_AMOUNT=10000"

:: 設定時間和使用者
for /f %%a in ('wmic os get LocalDateTime /value ^| find "="') do set "%%a"
set "UTC_TIME=%LocalDateTime:~0,4%-%LocalDateTime:~4,2%-%LocalDateTime:~6,2% %LocalDateTime:~8,2%:%LocalDateTime:~10,2%:%LocalDateTime:~12,2%"

if "%~1" neq "" set "UTC_TIME=%~1"
if "%~2" neq "" (
    set "USER_LOGIN=%~2"
) else (
    set "USER_LOGIN=robbin0919"
)

:: 設定基礎路徑（改用絕對路徑）
pushd "%~dp0.."
set "BASE_DIR=%CD%"
popd
set "DATA_DIR=%BASE_DIR%\data"
set "OUTPUT_DIR=%BASE_DIR%\output"

:: 設定檔案路徑
set "INPUT_FILE=%DATA_DIR%\input_bonds.txt"
set "FILE_NAME=bonds_%UTC_TIME:~0,10%_%UTC_TIME:~11,2%%UTC_TIME:~14,2%.csv"
:: 移除檔名中的冒號
set "FILE_NAME=!FILE_NAME::=_!"
:: 設定完整輸出路徑
set "OUTPUT_CSV=%OUTPUT_DIR%\%FILE_NAME%"
set "LOG_FILE=%OUTPUT_DIR%\process_%UTC_TIME:~0,10%.log"
set "ERROR_LOG=%OUTPUT_DIR%\error_%UTC_TIME:~0,10%.log"

:: 建立輸出目錄
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

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

:: 修改 CSV 標題行，明確標示單位
set "HEADER=執行時間,執行者,債券代碼,債券名稱,參考報價日期,參考申購報價,票面利率,配息頻率,到期日,YTM/YTC,產業別,計價幣別,最低申購面額,風險等級,票息收入(%INVESTMENT_AMOUNT%美金),折價金額(%INVESTMENT_AMOUNT%美金),投資年期(年),配息期數(期),開放申購"
echo !HEADER! > "%OUTPUT_CSV%"

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
set "is_available="

:: ========== 讀取並處理輸入檔案 ==========
echo 開始處理輸入檔案...
echo [%UTC_TIME%] 開始讀取檔案 %INPUT_FILE% >> "%LOG_FILE%"

for /f "usebackq delims=" %%a in ("%INPUT_FILE%") do (
    set "line=%%a"
    :: 先處理 & 符號，將其轉換為「和」
    set "line=!line:&=和!"
    
    :: 解析債券代碼和名稱（第一行）
    echo !line! | findstr /r "^WMBB[0-9]" >nul
    if !errorlevel! equ 0 (
        :: 如果已有債券代碼，先處理前一筆資料
        if defined bond_code (
            :: 計算票息收入和折價金額
            set "annual_income="
            set "discount_amount="
            if defined min_purchase if defined coupon_rate if defined purchase_price (
                :: 移除百分比符號和逗號
                set "clean_rate=!coupon_rate:%%=!"
                set "clean_price=!purchase_price:%%=!"

                :: 計算票息收入
                for /f %%i in ('powershell -Command "$rate=[double]'!clean_rate!'; $income=%INVESTMENT_AMOUNT%*($rate/100); Write-Host $([math]::Round($income,2))"') do (
                    set "annual_income=%%i"
                )

                :: 計算折價金額
                for /f %%i in ('powershell -Command "$price=[double]'!clean_price!'; $discount=%INVESTMENT_AMOUNT%*(100-$price)/100; Write-Host $([math]::Round($discount,2))"') do (
                    set "discount_amount=%%i"
                )
            )

            :: 設定 PowerShell 命令計算投資期間
            if defined quote_date if defined maturity_date (
                :: 根據配息頻率設定乘數
                set "freq_multiplier=2"
                if "!payment_freq!"=="月配" (
                    set "freq_multiplier=12"
                ) else if "!payment_freq!"=="季配" (
                    set "freq_multiplier=4"
                ) else if "!payment_freq:~0,3!"=="半年" (
                    set "freq_multiplier=2"
                )

                :: 設定 PowerShell 命令輸出純數字
                set "PS_CMD="
                set "PS_CMD=!PS_CMD! $start = [datetime]::ParseExact('!quote_date!', 'yyyy/MM/dd', $null);"
                set "PS_CMD=!PS_CMD! $end = [datetime]::ParseExact('!maturity_date!', 'yyyy/MM/dd', $null);"
                set "PS_CMD=!PS_CMD! $years = [math]::Round(($end - $start).Days / 365, 1);"
                set "PS_CMD=!PS_CMD! $periods = [math]::Round($years * !freq_multiplier!, 0);"
                set "PS_CMD=!PS_CMD! Write-Host ($years.ToString() + '|' + $periods.ToString())"

                :: 執行 PowerShell 命令並設定純數字結果
                for /f "tokens=1,2 delims=|" %%i in ('powershell -Command "!PS_CMD!"') do (
                    set "investment_years=%%i"
                    set "investment_periods=%%j"
                )
            ) else (
                set "investment_years=N/A"
                set "investment_periods=N/A"
            )
            
            :: 輸出資料，分開顯示年期和期數
            echo %UTC_TIME%,%USER_LOGIN%,!bond_code!,!bond_name!,!quote_date!,!purchase_price!,!coupon_rate!,!payment_freq!,!maturity_date!,!ytm_ytc!,!industry!,!currency!,"!min_purchase!",!risk_level!,!annual_income!,!discount_amount!,!investment_years!,!investment_periods!,!is_available! >> "%OUTPUT_CSV%"
            set /a "record_count+=1"
            echo [%UTC_TIME%] 處理債券: !bond_code! >> "%LOG_FILE%"
        )
        
        :: 開始新的債券資料
        for /f "tokens=1,*" %%b in ("!line!") do (
            set "bond_code=%%b"
            set "bond_name=%%c"
        )
        :: 重設其他變數
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
        set "is_available=N"   :: 這裡有設定預設值為N
    ) else (
        :: 跳過空行，開始新的債券資料
        if "!line!"=="" (
            if defined bond_code (
                :: 計算票息收入和折價金額
                set "annual_income="
                set "discount_amount=" 
                if defined min_purchase if defined coupon_rate if defined purchase_price (
                    :: 移除百分比符號和逗號
                    set "clean_rate=!coupon_rate:%%=!"
                    set "clean_price=!purchase_price:%%=!"

                    :: 計算票息收入
                    for /f %%i in ('powershell -Command "$rate=[double]'!clean_rate!'; $income=%INVESTMENT_AMOUNT%*($rate/100); Write-Host $([math]::Round($income,2))"') do (
                        set "annual_income=%%i"
                    )

                    :: 計算折價金額
                    for /f %%i in ('powershell -Command "$price=[double]'!clean_price!'; $discount=%INVESTMENT_AMOUNT%*(100-$price)/100; Write-Host $([math]::Round($discount,2))"') do (
                        set "discount_amount=%%i"
                    )
                )

                :: 設定 PowerShell 命令計算投資期間
                if defined quote_date if defined maturity_date (
                    :: 根據配息頻率設定乘數
                    set "freq_multiplier=2"
                    if "!payment_freq!"=="月配" (
                        set "freq_multiplier=12"
                    ) else if "!payment_freq!"=="季配" (
                        set "freq_multiplier=4"
                    ) else if "!payment_freq:~0,3!"=="半年" (
                        set "freq_multiplier=2"
                    )

                     :: 設定 PowerShell 命令輸出純數字
                    set "PS_CMD="
                    set "PS_CMD=!PS_CMD! $start = [datetime]::ParseExact('!quote_date!', 'yyyy/MM/dd', $null);"
                    set "PS_CMD=!PS_CMD! $end = [datetime]::ParseExact('!maturity_date!', 'yyyy/MM/dd', $null);"
                    set "PS_CMD=!PS_CMD! $years = [math]::Round(($end - $start).Days / 365, 1);"
                    set "PS_CMD=!PS_CMD! $periods = [math]::Round($years * !freq_multiplier!, 0);"
                    set "PS_CMD=!PS_CMD! Write-Host ($years.ToString() + '|' + $periods.ToString())"

                    :: 執行 PowerShell 命令並設定純數字結果
                    for /f "tokens=1,2 delims=|" %%i in ('powershell -Command "!PS_CMD!"') do (
                        set "investment_years=%%i"
                        set "investment_periods=%%j"
                    )
                ) else (
                    set "investment_years=N/A"
                    set "investment_periods=N/A"
                )
                
                :: 輸出資料，分開顯示年期和期數
                echo %UTC_TIME%,%USER_LOGIN%,!bond_code!,!bond_name!,!quote_date!,!purchase_price!,!coupon_rate!,!payment_freq!,!maturity_date!,!ytm_ytc!,!industry!,!currency!,"!min_purchase!",!risk_level!,!annual_income!,!discount_amount!,!investment_years!,!investment_periods!,!is_available! >> "%OUTPUT_CSV%"
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
            :: 解析其他欄位（移除標籤處理）
            if "!line!"=="參考報價日期" (
                set "next_is_quote_date=1"
            ) else if defined next_is_quote_date (
                set "quote_date=!line!"
                set "next_is_quote_date="
            ) else if "!line!"=="參考申購報價" (
                set "next_is_purchase_price=1"
            ) else if defined next_is_purchase_price (
                set "purchase_price=!line!"
                set "next_is_purchase_price="
            ) else if "!line!"=="票面利率" (
                set "next_is_coupon_rate=1"
            ) else if defined next_is_coupon_rate (
                set "coupon_rate=!line!"
                set "next_is_coupon_rate="
            ) else if "!line!"=="配息頻率" (
                set "next_is_payment_freq=1"
                set "payment_freq="
            ) else if defined next_is_payment_freq (
                if "!payment_freq!"=="" (
                    set "payment_freq=!line!"
                    :: 檢查是否為月配，如果是則直接結束
                    if "!line!"=="月配" (
                        set "next_is_payment_freq="
                    )
                    :: 檢查是否為季配，如果是則直接結束
                    if "!line!"=="季配" (
                        set "next_is_payment_freq="
                    )
                ) else (
                    :: 如果有第二行，則加入括號
                    set "payment_freq=!payment_freq! (!line!)"
                    set "next_is_payment_freq="
                )
            ) else if "!line!"=="到期日" (
                set "next_is_maturity_date=1"
            ) else if defined next_is_maturity_date (
                set "maturity_date=!line!"
                set "next_is_maturity_date="
            ) else if "!line!"=="YTM/YTC" (
                set "next_is_ytm_ytc=1"
            ) else if defined next_is_ytm_ytc (
                set "ytm_ytc=!line!"
                set "next_is_ytm_ytc="
            ) else if "!line!"=="產業別" (
                set "next_is_industry=1"
            ) else if defined next_is_industry (
                set "industry=!line!"
                set "next_is_industry="
            ) else if "!line!"=="計價幣別" (
                set "next_is_currency=1"
            ) else if defined next_is_currency (
                set "currency=!line!"
                set "next_is_currency="
            ) else if "!line!"=="最低申購面額" (
                set "next_is_min_purchase=1"
            ) else if defined next_is_min_purchase (
                set "min_purchase=!line!"
                set "next_is_min_purchase="
            ) else if "!line!"=="風險等級" (
                set "next_is_risk_level=1"
            ) else if defined next_is_risk_level (
                set "risk_level=!line!"
                set "next_is_risk_level="
            ) else (
                :: 使用 PowerShell 檢查是否包含"我要申購"
                for /f %%i in ('powershell -Command "$line = '!line!'; if($line -match '我要申購') { Write-Host 'Y' } else { Write-Host 'N' }"') do (
                    if "%%i"=="Y" (
                        set "is_available=Y"
                    )
                )
            )
        )
    )
)
:: 處理最後一筆債券資料
if defined bond_code (
    :: 計算票息收入和折價金額
    set "annual_income="
    set "discount_amount="
    if defined min_purchase if defined coupon_rate if defined purchase_price (
        :: 移除百分比符號和逗號
        set "clean_rate=!coupon_rate:%%=!"
        set "clean_price=!purchase_price:%%=!"

        :: 計算票息收入
        for /f %%i in ('powershell -Command "$rate=[double]'!clean_rate!'; $income=%INVESTMENT_AMOUNT%*($rate/100); Write-Host $([math]::Round($income,2))"') do (
            set "annual_income=%%i"
        )

        :: 計算折價金額
        for /f %%i in ('powershell -Command "$price=[double]'!clean_price!'; $discount=%INVESTMENT_AMOUNT%*(100-$price)/100; Write-Host $([math]::Round($discount,2))"') do (
            set "discount_amount=%%i"
        )
    )

    :: 設定 PowerShell 命令計算投資期間
    if defined quote_date if defined maturity_date (
        :: 根據配息頻率設定乘數
        set "freq_multiplier=2"
        if "!payment_freq!"=="月配" (
            set "freq_multiplier=12"
        ) else if "!payment_freq!"=="季配" (
            set "freq_multiplier=4"
        ) else if "!payment_freq:~0,3!"=="半年" (
            set "freq_multiplier=2"
        )

        :: 設定 PowerShell 命令輸出純數字
        set "PS_CMD="
        set "PS_CMD=!PS_CMD! $start = [datetime]::ParseExact('!quote_date!', 'yyyy/MM/dd', $null);"
        set "PS_CMD=!PS_CMD! $end = [datetime]::ParseExact('!maturity_date!', 'yyyy/MM/dd', $null);"
        set "PS_CMD=!PS_CMD! $years = [math]::Round(($end - $start).Days / 365, 1);"
        set "PS_CMD=!PS_CMD! $periods = [math]::Round($years * !freq_multiplier!, 0);"
        set "PS_CMD=!PS_CMD! Write-Host ($years.ToString() + '|' + $periods.ToString())"

        :: 執行 PowerShell 命令並設定純數字結果
        for /f "tokens=1,2 delims=|" %%i in ('powershell -Command "!PS_CMD!"') do (
            set "investment_years=%%i"
            set "investment_periods=%%j"
        )
    ) else (
        set "investment_years=N/A"
        set "investment_periods=N/A"
    )

    :: 在輸出最後一筆資料前，加入檢查是否有"我要申購"的邏輯
    :: 使用 PowerShell 檢查累積的行內容是否包含"我要申購"
    for /f %%i in ('powershell -Command "$line = '!line!'; if($line -match '我要申購') { Write-Host 'Y' } else { Write-Host 'N' }"') do (
        if "%%i"=="Y" (
            set "is_available=Y"
        )
    )
    
    :: 輸出資料，分開顯示年期和期數
    echo %UTC_TIME%,%USER_LOGIN%,!bond_code!,!bond_name!,!quote_date!,!purchase_price!,!coupon_rate!,!payment_freq!,!maturity_date!,!ytm_ytc!,!industry!,!currency!,"!min_purchase!",!risk_level!,!annual_income!,!discount_amount!,!investment_years!,!investment_periods!,!is_available! >> "%OUTPUT_CSV%"
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
    set "line=%%a"
    if "!line:~0,14!"=="執行時間,執行者,債券代碼" (
        echo !line! >> "%TEMP_CSV%"
    ) else (
        set "line=!line:%%=%%!"
        set "line=!line:,%%=%%!"
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