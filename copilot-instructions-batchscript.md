---
title: Batch Script 編碼規範和建議
version: 1.0.0
date: 2025-05-10
author: Robbin Lee
license: MIT
repository: https://github.com/robbin0919/Github_copilot
maintainers:
  - name: Robbin Lee
    email: robbin0919@domain.com
---

# Batch Script 編碼規範和建議

## 命名規範
- 使用有意義的檔案名稱，優先使用英文
- 批次檔副檔名使用 .bat 或 .cmd
- 變數名稱使用大寫字母，用底線分隔 (例如: USER_INPUT, FILE_PATH)
- 標籤名稱使用小寫字母，使用冒號結尾 (例如: :start_process:)

## 註解規範
- 在腳本開頭加入描述性註解，說明用途
- 重要區塊需加入區塊註解
- 使用 `rem` 或 `::` 作為註解標記

## 錯誤處理
- 使用 errorlevel 檢查命令執行狀態
- 加入錯誤處理機制
- 重要操作需要加入確認提示

## 錯誤處理詳解

### 1. ErrorLevel 檢查最佳實踐
```batch
rem 不建議使用
if !errorlevel! EQU 1 (
    echo 錯誤狀態檢查
)

rem 建議使用以下方式
if errorlevel 1 (
    echo 錯誤狀態檢查 - 適用於 >= 1 的情況
)

rem 精確檢查特定錯誤碼
if "!errorlevel!"=="1" (
    echo 錯誤狀態等於 1
)

rem 多重條件檢查 多重條件檢查
if errorlevel 2 (
    echo 錯誤等級 >= 2
) else if errorlevel 1 (
    echo 錯誤等級 = 1
) else (
    echo 執行成功
)
```

### 2. 錯誤狀態檢查範例
```batch
xcopy "source.txt" "dest.txt" >nul
if "!errorlevel!"=="0" (
    echo 複製成功
) else if "!errorlevel!"=="4" (
    echo 初始化錯誤
) else if "!errorlevel!"=="5" (
    echo 磁碟寫入錯誤
) else (
    echo 未知錯誤：!errorlevel!
)
```

### 3. 檔案操作錯誤處理
```batch
if exist "!FILE_PATH!" (
    del "!FILE_PATH!" 2>nul || (
        echo 無法刪除檔案
        exit /b 1
    )
)
```

### 4. 使用者確認機制
```batch
choice /c yn /m "是否繼續執行？"
if errorlevel 2 (
    echo 使用者取消操作
    exit /b 0
)
```

### 5. 錯誤碼定義
```batch
set "ERR_FILE_NOT_FOUND=1"
set "ERR_ACCESS_DENIED=2"
set "ERR_INVALID_INPUT=3"

if not exist "!INPUT_FILE!" (
    echo 錯誤：找不到檔案
    exit /b !ERR_FILE_NOT_FOUND!
)
```

### 6. 錯誤日誌記錄
```batch
call :log_error "操作失敗：!errorlevel!"
goto :eof

:log_error
    echo [%date% %time%] ERROR: %~1 >> error.log
    exit /b
```

## 語法標準

### 避免巢狀條件檢查
- 減少使用多層 if-else 結構
- 優先使用 goto 和子程序處理複雜條件
- 善用早期返回（early return）pattern

#### 不建議的寫法
```batch
if exist "!FILE!" (
    if "!USER!"=="admin" (
        if !COUNT! GTR 5 (
            echo 條件符合
        )
    )
)
```

#### 建議的寫法 1：使用 goto
```batch
if not exist "!FILE!" goto :check_failed
if not "!USER!"=="admin" goto :check_failed
if not !COUNT! GTR 5 goto :check_failed
echo 條件符合
goto :continue

:check_failed
echo 條件檢查失敗
exit /b 1

:continue
rem 繼續執行
```

#### 建議的寫法 2：使用子程序
```batch
call :check_conditions || (
    echo 條件檢查失敗
    exit /b 1
)
echo 條件符合

:check_conditions
    if not exist "!FILE!" exit /b 1
    if not "!USER!"=="admin" exit /b 1
    if not !COUNT! GTR 5 exit /b 1
    exit /b 0
```

### 優點
1. 提高程式碼可讀性
2. 降低邏輯錯誤風險
3. 方便維護和除錯
4. 減少重複程式碼

## 程式結構範例
```batch
@echo off
setlocal enabledelayedexpansion

rem === 腳本說明 ===
rem 檔案名稱：example.cmd
rem 用途：示範標準語法
rem 建立日期：%date%
rem 作者：

rem === 變數宣告 ===
set "INPUT_FILE=%~1"
set "OUTPUT_DIR=%~dp0output"
set /a "COUNTER=0"

rem === 主要程式 ===
:main
    if not exist "!INPUT_FILE!" (
        echo 錯誤：找不到輸入檔案 >con
        exit /b 1
    )
    
    mkdir "!OUTPUT_DIR!" 2>nul
    
    for /f "tokens=* delims=" %%a in (!INPUT_FILE!) do (
        set /a "COUNTER+=1"
        echo 處理第 !COUNTER! 行... >con
    )
    goto :eof

rem === 子程序 ===
:sub_routine
    setlocal
    set "PARAM=%~1"
    rem 程式邏輯
    endlocal & exit /b
```

## 建議實踐
1. 使用 `@echo off` 關閉命令回顯
2. 使用 `setlocal` 限制變數範圍
3. 使用 `exit /b` 結束子程序
4. 使用 `goto :eof` 結束主程序
5. 重要檔案操作需要檢查檔案是否存在
6. 使用引號包覆路徑和變數，避免空格問題
7. 善用 `setlocal` 和 `endlocal` 管理變數範圍
8. 使用 `%~nx1` 取得檔名和副檔名
9. 使用 `%~dp0` 取得腳本所在目錄
10. 使用 `>con` 確保訊息顯示在控制台

## 系統時間處理規範

### 1. 基本時間格式
```batch
rem 取得系統日期和時間
set "CURRENT_DATE=%date%"
set "CURRENT_TIME=%time%"

rem 建議使用 wmic 取得統一格式的時間
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YYYY=%dt:~0,4%"
set "MM=%dt:~4,2%"
set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%"
set "MI=%dt:~10,2%"
set "SS=%dt:~12,2%"
```

### 2. 時間戳記格式化
```batch
rem 格式化時間戳記 (YYYY-MM-DD_HH-MI-SS)
set "TIMESTAMP=%YYYY%-%MM%-%DD%_%HH%-%MI%-%SS%"

rem 用於檔案命名
set "LOG_FILE=log_%TIMESTAMP%.txt"
```

### 3. 時間運算處理
```batch
rem 使用 PowerShell 進行日期計算
for /f %%a in ('powershell -Command "(Get-Date).AddDays(-7).ToString('yyyy-MM-dd')"') do set "LAST_WEEK=%%a"

rem 使用 wmic 計算時間差
for /f %%a in ('wmic path win32_localtime get hour^,minute /format:value') do set %%a
```

### 注意事項
1. 不同地區的 `%date%` 格式可能不同
2. `%time%` 可能包含前導空格
3. 建議使用 wmic 或 PowerShell 取得統一格式
4. 處理時間時需考慮時區問題
5. 批次檔時間運算建議使用 PowerShell

## IF-ELSE 語法規範

### 基本語法規則
- 每個開括號 `(` 必須有對應的閉括號 `)`
- 多行結構中，`else` 必須與 `if` 的結束括號在同一行
- 使用 `enabledelayedexpansion` 處理複雜條件
- 在條件檢查中使用引號包覆變數和字串比較

### 正確 IF-ELSE 寫法
```batch
rem 單行結構
if condition (command1) else (command2)

rem 多行結構 - else 必須與前一個結束括號在同一行
if condition (
    command1
    command2
) else (
    command3
    command4
)

rem 巢狀條件結構
if "%var%"=="1" (
    if exist "file.txt" (
        echo 找到檔案
    ) else (
        echo 找不到檔案
    )
) else (
    echo 變數不等於1
)
```

### 常見錯誤與解決方案

#### 錯誤寫法 1：ELSE 與 IF 的結束括號不在同一行
```batch
if exist "file.txt" (
    echo 檔案存在
)
else (                   :: 錯誤！將導致"這個時候不應有 )。"錯誤
    echo 檔案不存在
)
```

#### 正確寫法 1：
```batch
if exist "file.txt" (
    echo 檔案存在
) else (                 :: 正確！else 與前面的 ) 在同一行
    echo 檔案不存在
)
```

#### 錯誤寫法 2：巢狀 IF 結構中括號對不齊
```batch
if "%var%"=="1" (
    if exist "file.txt" (
        echo 找到檔案
    )
    else (               :: 錯誤！將導致"這個時候不應有 )。"錯誤
        echo 找不到檔案
    )
)
```

#### 正確寫法 2：
```batch
if "%var%"=="1" (
    if exist "file.txt" (
        echo 找到檔案
    ) else (             :: 正確！內層 else 與前面的 ) 在同一行
        echo 找不到檔案
    )
)
```

### 預防錯誤的最佳實踐
1. 保持一致的縮排和括號對齊，方便查找問題
2. 在複雜條件結構中，考慮使用子程序或 goto 避免多層巢狀
3. 避免在括號內使用特殊字元 (`&`, `|`, `<`, `>` 等) 或適當轉義
4. 在條件檢查中使用引號包覆變數，以防止變數為空時的語法錯誤
5. 使用 `setlocal enabledelayedexpansion` 在複雜條件判斷中使用 `!var!` 語法

### 其他條件判斷技巧
```batch
rem 多條件判斷：AND 與 OR 邏輯
if exist "file1.txt" if exist "file2.txt" echo 兩個檔案都存在    rem AND 邏輯
if exist "file1.txt" (echo 檔案1存在) else if exist "file2.txt" (echo 檔案2存在)  rem OR 邏輯

rem 條件取反
if not exist "file.txt" echo 檔案不存在

rem 比較運算符：EQU(等於), NEQ(不等於), LSS(小於), LEQ(小於等於), GTR(大於), GEQ(大於等於)
if !COUNT! GEQ 10 echo 計數大於等於10
```

## 檔案與編碼處理規範

### 文件編碼設定
- 批次檔在台灣環境中建議使用 ANSI (繁體中文環境下為 BIG5) 編碼
- 使用 UTF-8 編碼時應注意可能發生的顯示問題
- 在 Visual Studio Code 中，可以透過右下角選擇文件編碼 (ANSI/BIG5)

### 中文字元處理
```batch
@echo off
rem 設定命令提示字元為本地編碼頁 (繁體中文為 950/BIG5)
chcp 950 >nul
setlocal enabledelayedexpansion

rem 設定為簡體中文 (若需要)
rem chcp 936 >nul

rem 其他批次檔內容...
```

### 中文輸出與重定向
```batch
rem 直接輸出中文到控制台
echo 這是中文輸出

rem 將中文輸出到檔案 (使用當前代碼頁)
>output.txt echo 這是中文輸出

rem 如有亂碼問題，確保環境使用相同代碼頁
```

### 中文檔案讀取
```batch
rem 讀取本地編碼檔案內容
for /f "usebackq tokens=* delims=" %%a in ("中文檔案.txt") do (
    echo %%a
)

rem 處理不同編碼的檔案時，確保轉換為相容編碼
```

### 避免中文路徑問題
```batch
rem 處理含中文的路徑
set "CHINESE_PATH=C:\測試目錄"

rem 檢查目錄是否存在
if exist "!CHINESE_PATH!\*" (
    echo 目錄存在
) else (
    echo 目錄不存在
)

rem 處理中文路徑時，確保命令提示字元的代碼頁與檔案系統編碼一致
```

### 日誌檔案編碼
```batch
rem 建立符合本地編碼的日誌檔案
echo [%date% %time%] 程序啟動 > log.txt

rem 追加日誌內容
echo [%date% %time%] 操作完成 >> log.txt
```

### ANSI/BIG5 與 UTF-8 轉換
```batch
rem 若必須在不同環境使用，提供轉換機制

rem 使用 PowerShell 進行編碼轉換 (BIG5/ANSI 轉 UTF-8)
powershell -Command "$content = Get-Content -Path 'ansi.txt' -Encoding Default; Set-Content -Path 'utf8.txt' -Encoding UTF8 -Value $content"

rem UTF-8 轉回 BIG5/ANSI
powershell -Command "$content = Get-Content -Path 'utf8.txt' -Encoding UTF8; Set-Content -Path 'ansi.txt' -Encoding Default -Value $content"
```

### 編碼相關最佳實踐
1. **保持編碼一致性**：整個專案使用同一種編碼標準
2. **優先使用本地編碼**：在台灣環境使用 BIG5，中國環境使用 GB2312/GBK
3. **命令提示字元設定**：使用 `chcp 950` (BIG5) 或 `chcp 936` (GBK) 確保命令提示字元顯示正確
4. **檔案頭標記**：在批次檔開頭註明使用的編碼方式
5. **避免混合編碼**：不在同一系統中混用不同編碼的檔案
6. **路徑處理**：中文路徑使用雙引號包覆，避免特殊符號
7. **跨平台相容**：若需要跨平台使用，考慮提供編碼轉換機制
8. **簡化檔名**：盡量使用英文或數字作為檔名，減少編碼問題

### 編碼轉換工具
```batch
rem 建立一個簡單的編碼轉換批次檔

@echo off
setlocal enabledelayedexpansion

if "%~1"=="" goto :usage
if "%~2"=="" goto :usage

set "SRC_FILE=%~1"
set "DST_FILE=%~2"
set "SRC_ENC=%~3"
set "DST_ENC=%~4"

if not defined SRC_ENC set "SRC_ENC=Default"
if not defined DST_ENC set "DST_ENC=UTF8"

powershell -Command "$content = Get-Content -Path '%SRC_FILE%' -Encoding %SRC_ENC%; Set-Content -Path '%DST_FILE%' -Encoding %DST_ENC% -Value $content"

exit /b 0

:usage
echo 用法: %~nx0 來源檔案 目標檔案 [來源編碼] [目標編碼]
echo 範例: %~nx0 input.txt output.txt Default UTF8
exit /b 1
```

### 常見編碼問題與解決方案

#### 問題1: 中文顯示為亂碼
```batch
rem 解決方案: 設定正確的代碼頁
chcp 950 >nul
```

#### 問題2: 輸出到檔案時中文變亂碼
```batch
rem 解決方案: 確保使用相同編碼讀寫
rem 使用 type 命令而非 echo 重定向
type 中文內容.txt > 輸出.txt
```

#### 問題3: 不同電腦執行結果不同
```batch
rem 解決方案: 在批次檔開頭明確設定代碼頁
chcp 950 >nul
```
