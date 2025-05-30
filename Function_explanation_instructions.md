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
   - 相對應程式檔案：檔案路徑使用相對路徑。
     - 格式: [`專案名稱/路徑/檔案名稱`]
     - 若有多個檔案，請用逗號分隔
     - 例如：[`ProjectA/src/components/Component1.vue`]
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
 ```mermaid
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