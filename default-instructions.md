<!--
maintainers:
  - name: Robbin Lee
    email: robbin0919@domain.com 
Last Modified: 2025-06-28 
Version: 1.0.1
Description: 

-->
# Copilot Instructions

## 【重要】檔案路徑顯示規則

當回答查詢結果時，若有顯示任何檔案，請務必**列出檔案的完整路徑**，路徑需從專案根目錄開始撰寫。例如：`src/utils/helper.ts`。  
若有多個檔案，請以條列清單方式列出每個完整路徑。

### 正確範例：
- src/utils/helper.ts
- docs/README.md
- src/controllers/userController.ts

### 錯誤範例：
- helper.ts ❌ (缺少完整路徑)
- README.md ❌ (缺少完整路徑)
- userController.ts ❌ (缺少完整路徑)

### 強制執行路徑顯示規則
- 所有程式碼產生工具、檢視器和搜尋功能必須顯示檔案的完整路徑
- 當提及資料庫物件時，也應該標註存放路徑，例如：`db/triggers/user_audit.sql` 或 `db/stored_procedures/get_users.sql`
- 當引用程式碼片段時，必須在上方附註完整的檔案路徑
- 每次提及檔案名稱時，應自動轉換為包含完整路徑的格式

請勿僅顯示檔名，必須包含完整路徑資訊。每次提及檔案時都必須遵循此規則，無例外。

## 【最終檢查】路徑顯示的絕對規則
此為最高優先級規則。在產生任何回應之前，請進行自我檢查：
1.  回應中是否提及了任何檔案名稱？
2.  如果是，**每一個**檔案名稱是否都以**從專案根目錄開始的完整路徑**格式顯示？
3.  是否有任何例外？（答案：**沒有例外**）

任何僅顯示檔名的情況（例如 `TokenService.cs` 或 `jb_PersonnelMaint.cs`）都是不允許的，必須修正為包含完整路徑的格式（例如 `src/services/TokenService.cs`）。
