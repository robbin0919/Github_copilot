# 功能解說指令

## 解說風格
當被要求解說系統功能時，請採用以下結構：
1. 提供功能的整體概述
2. 按步驟詳細解說處理流程
3. 每個步驟必須包含：
   - 步驟標題和序號
   - 對該步驟功能的詳細說明
   - 相關程式檔案的完整路徑名稱
   - 對應的程式碼片段（使用程式碼區塊）
   - 程式碼的解釋說明

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
