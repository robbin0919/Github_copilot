# 功能解說指令
<!--
maintainers:
  - name: Robbin Lee
    email: robbin0919@domain.com 
Last Modified: 2025-05-28 
Version: 1.0.0
Description: 
此文件提供一套標準化的指導方針，用於解說系統功能，特別針對 .NET 生態系統中的專案。目的是幫助開發者清楚地理解系統功能的實現細節和流程。
-->
## 解說風格
當被要求解說系統功能時，請採用以下結構：
1. 提供功能的整體概述
2. 按步驟詳細解說處理流程
3. 每個步驟必須包含：
   - 步驟標題和序號
   - 對該步驟功能的詳細說明
   - 相關程式檔案的完整路徑名稱，並完整顯示檔案名稱，
     例如：不要顯示 檔案路徑：`LoginController.cs`，而是要完整顯示檔案路徑：`/webappj/Controllers/LoginController.cs`，不需要游標移到檔案上才會顯示完整路徑。
   - 對應的程式碼片段（使用程式碼區塊）
   - 程式碼的解釋說明
   - 相關的日誌記錄（如果有）
   - 相關的資料加解密處理（如果有）
   - **注意**：每個步驟的程式碼片段必須完整，不能只顯示部分程式碼。
   - **注意**：如果程式碼片段過長，請將其分成多個部分，每個部分都要包含完整的程式碼邏輯。

4. 流程圖
   - 如果有流程圖，請在解說的最後附上流程圖。
   - 流程圖應該清楚地顯示每個步驟之間的關係和流程。
   - 流程圖應該使用簡單明瞭的圖形和文字標籤，以便於理解。
   - 使用mermaid 語法來生成循序圖
   - 使用mermaid 語法來生成流程圖。
 - 循序圖
 - ```mermaid
   sequenceDiagram
       participant User
       participant System
       User->>System: 新增任務
       System-->>User: 任務已新增
       User->>System: 刪除任務
       System-->>User: 任務已刪除
       User->>System: 查看任務
       System-->>User: 返回任務清單
   ```
- 流程圖
   ```mermaid
   graph TD
       A[開始] --> B{判斷}
       B -- Yes --> C[執行]
       B -- No --> D[結束]
   ```

## 解說範例
當被要求解說某個功能時，請遵循以下範例：
### 功能概述
這個功能的目的是提供用戶一個簡單的方式來管理他們的任務清單。用戶可以新增、刪除和查看任務。
### 步驟1：新增任務
在這個步驟中，用戶可以輸入任務的詳細資訊，並將其新增到任務清單中。
- **檔案路徑**：`/webappj/Controllers/LoginController.cs`
- **程式碼片段**：
```csharp   
public IActionResult AddTask(string taskName)
{
    // 檢查任務名稱是否有效
    if (string.IsNullOrEmpty(taskName))
    {
        return BadRequest("任務名稱不能為空");
    }
    
    // 新增任務到資料庫
    _taskService.AddTask(taskName);
    
    return Ok("任務已新增");
}
```
### 程式碼解釋
這段程式碼定義了一個新增任務的動作。首先，它檢查任務名稱是否為空，如果是，則返回錯誤訊息。接著，使用服務層的 `AddTask` 方法將任務新增到資料庫中，最後返回成功訊息。
### 步驟2：刪除任務
在這個步驟中，用戶可以選擇要刪除的任務，並將其從任務清單中移除。
- **檔案路徑**：`/webappj/Controllers/LoginController.cs`
- **程式碼片段**：
```csharp
public IActionResult DeleteTask(int taskId)
{
    // 檢查任務ID是否有效
    if (taskId <= 0)
    {
        return BadRequest("無效的任務ID");
    }

    // 刪除任務
    _taskService.DeleteTask(taskId);

    return Ok("任務已刪除");
}
```
### 程式碼解釋
這段程式碼定義了一個刪除任務的動作。首先，它檢查任務ID是否有效，如果無效，則返回錯誤訊息。接著，使用服務層的 `DeleteTask` 方法將任務從資料庫中刪除，最後返回成功訊息。
### 步驟3：查看任務
在這個步驟中，用戶可以查看目前所有的任務清單。
- **檔案路徑**：`/webappj/Controllers/LoginController.cs`
- **程式碼片段**：
```csharp
public IActionResult ViewTasks()
{
    // 獲取所有任務
    var tasks = _taskService.GetAllTasks();

    return Ok(tasks);
}
```
### 程式碼解釋
這段程式碼定義了一個查看任務的動作。它使用服務層的 `GetAllTasks` 方法來獲取所有任務，並返回這些任務的清單。這樣，用戶就可以看到他們目前的任務狀態。
### 步驟4：資料加解密處理
在這個步驟中，系統會對任務資料進行加密和解密處理，以確保資料的安全性。
- **檔案路徑**：`/webappj/Services/EncryptionService.cs`
- **程式碼片段**：
```csharp   
public class EncryptionService
{
    private readonly string _encryptionKey = "your-encryption-key";

    public string Encrypt(string plainText)
    {
        // 實現加密邏輯
    }

    public string Decrypt(string cipherText)
    {
        // 實現解密邏輯
    }
}  
```
### 程式碼解釋
這段程式碼定義了一個加密服務類別，包含加密和解密方法。`Encrypt` 方法將明文轉換為密文，而 `Decrypt` 方法則將密文轉換回明文。這樣可以確保任務資料在存儲和傳輸過程中的安全性。
