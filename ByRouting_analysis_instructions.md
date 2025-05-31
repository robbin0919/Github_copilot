<!--
maintainers:
  - name: Robbin Lee
    email: robbin0919@domain.com 
Last Modified: 2025-06-01 
Version: 1.0.0
Description: 
此文件提供一套標準化的指導方針，用於ByRouting分析列出系統功能清單。 
-->
# ByRouting_analysis解說指令
## 解說風格
當被要求列出系統Routing時，請採用以下結構：

 1. 路由名稱
    - 路由描述
    - 相關參數
    - 權限代碼：若有多個權限代碼，請用逗號分隔。
      - PgmIdList 是系統內部用來儲存控制器所需權限代碼的陣列變數
        - 在分析控制器檔案時，特別搜尋 PgmIdList 的賦值陳述式
        - 對每個控制器檔案進行分析，提取 PgmIdList 的值
        - 例如：`PgmIdList = ['-E5', '-E6', '-E7']`
      - 權限代碼是系統中用於識別和控制使用者對特定功能存取權的唯一識別符。
      - 權限代碼通常以短橫線（-）開頭，後接一個大寫字母和數字的組合。
      - 後接字母和/或數字的組合
      - 長度可變：可能是一個、兩個或三個字元
      - 例如：
        - E5、-E6、-E7、-BA等。
        - 單字元：-A、-B
        - 雙字元：-E5、-EA
        - 三字元：-E5A、-EAB
   - 相對應程式檔案：列出功能相關的所有檔案，使用相對路徑。
     - 需包含的檔案類型：
       - Controllers
       - Views
       - Models
       - JavaScript
       - CSS
       - 其他相關檔案
       - 介面檔案
       - API檔案
       - 其他相關檔案
 2. 有關聯的DB Object
    - 列出與此路由相關的所有資料庫物件（如表格、視圖、存儲過程等）
    - 使用相對路徑或完整路徑
    - 格式: 按DB Object類型分組，每組使用標題說明
      - 例如：
        ```
        Tables:
        [dbo.TableName]
        
        Views:
        [dbo.ViewName]
        
        Stored Procedures:
        [dbo.ProcedureName]
        ```
    - 若某類型無相關物件，可省略該類型
    - 對於每個物件，可選擇性增加簡短說明
      - 例如：
        ```
        Tables:
        [dbo.TableName] - 儲存用戶資料
        
        Views:
        [dbo.ViewName] - 用於顯示用戶列表
        
        Stored Procedures:
        [dbo.ProcedureName] - 處理用戶登入邏輯
        ```
    - 若有多個物件，請使用清單格式列出
    - 執行的SQL語句
      - 提供與此路由相關的SQL語句清單
      - 格式：
        - SQL語句：SELECT * FROM Users WHERE UserId = @UserId
        - 說明：查詢特定用戶資料
      - 若有多個SQL語句，請使用清單格式列出
      - 例如：
        ```
        SQL語句：SELECT * FROM Users WHERE UserId = @UserId
        說明：查詢特定用戶資料
        
        SQL語句：UPDATE Users SET LastLogin = GETDATE() WHERE UserId = @UserId
        說明：更新用戶最後登入時間
        ```
