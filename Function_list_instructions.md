<!--
maintainers:
  - name: Robbin Lee
    email: robbin0919@domain.com 
Last Modified: 2025-05-30 
Version: 1.0.0
Description: 
此文件提供一套標準化的指導方針，用於程式分析列出系統功能清單。
此版本專為C#程式碼庫設計，旨在確保功能清單的結構一致性和易讀性。
提示範例：@workspace 列出 ProjectA/Areas/Admin/  UI功能清單概述
-->
# UI功能清單解說指令
## 解說風格
當被要求列出系統功能時，請採用以下結構：

1. 功能名稱
   - 功能描述
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
     - 格式: 按檔案類型分組，每組使用標題說明
       ```
       Controllers:
       [`專案名稱/Areas/模組名/Controllers/控制器名稱.cs`]
       
       Views:
       [`專案名稱/Areas/模組名/Views/控制器名/視圖名稱.cshtml`]
       
       Models:
       [`專案名稱/Areas/模組名/Models/模型名稱.cs`]
       
       JavaScript:
       [`專案名稱/Areas/模組名/Scripts/腳本名稱.js`]
       
       CSS:
       [`專案名稱/Areas/模組名/Content/樣式名稱.css`]
       ```
     - 若某類型無相關檔案，可省略該類型
     - 對於每個檔案，可選擇性增加簡短說明
     - 例如：
       ```
       控制器:
       [`ProjectA/Areas/Admin/Controllers/UserController.cs`] - 處理使用者管理操作
       
       視圖:
       [`ProjectA/Areas/Admin/Views/User/Index.cshtml`] - 使用者列表頁面
       [`ProjectA/Areas/Admin/Views/User/Edit.cshtml`] - 使用者編輯頁面
       
       模型:
       [`ProjectA/Areas/Admin/Models/UserModel.cs`] - 使用者資料模型
       ```

2. 權限代碼清單
   - 提供權限代碼、功能模組、功能名稱、功能描述的清單。
   - 格式：
     - 權限代碼：-E5
     - 功能模組：系統管理
     - 功能名稱：使用者管理
     - 功能描述：管理系統使用者的新增、修改、刪除等操作。