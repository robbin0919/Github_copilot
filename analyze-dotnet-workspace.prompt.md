<!--
maintainers:
  - name: Robbin Lee
    email: robbin0919@gmail.com 
Last Modified: 2025-06-07 
Version: 1.1.0
Description:
此Prompt File 文件，用於分析 .NET 專案結構與依賴關係，提供系統架構的全貌
-->
# .NET 專案結構與依賴全覽分析

請協助分析目前 workspace（${workspaceFolder}）下所有 .csproj 檔案，整理出各專案（目錄）之間的關係與系統架構。請依下列步驟進行：

1. 掃描 ${workspaceFolder} 下所有子目錄的 .csproj 檔案，彙整專案清單與路徑。
2. 條列每個專案的主要功能（可依據專案名稱、資料夾結構、命名推測）。
3. 分析各專案的 ProjectReference（專案間依賴）及 PackageReference（NuGet 套件依賴）。
4. 描述專案間的依賴關係，並以階層圖或條列方式呈現系統分層與架構大致輪廓。
5. 摘要各專案的主要 NuGet 套件（只需列出重點套件）。
6. 提出系統架構設計的觀察、潛在風險或改進建議。

請以「目錄（專案）」為單位，條列、分節、結構化地以繁體中文說明。若專案數量龐大，請聚焦於主要專案與核心依賴關係。

---

## 輸出格式範例

### 1. 專案結構清單
- ProjectA/ProjectA.csproj
- ProjectB/ProjectB.csproj
...

### 2. 主要功能摘要
- ProjectA：處理核心業務邏輯
- ProjectB：API 入口與資料交換
...

### 3. 專案間依賴（ProjectReference）
- ProjectA 依賴 ProjectCommon
- ProjectB 依賴 ProjectA、ProjectCommon
...

### 4. NuGet 套件摘要（PackageReference）
- ProjectA：Newtonsoft.Json、EntityFrameworkCore
- ProjectB：Swashbuckle.AspNetCore
...

### 5. 架構總結與建議
- 系統以三層架構分明，資料存取與業務邏輯分離良好。
- 建議加強單元測試覆蓋率，並檢查套件版本安全性。
...

---

請根據上方步驟與格式，詳細分析目前 workspace 的 .NET 專案結構及依賴關係。