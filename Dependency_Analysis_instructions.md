# 專案相依關係分析指南
<!--
maintainers:
  - name: Robbin Lee
    email: robbin0919@domain.com
Last Modified: 2025-05-28 
Version: 1.0.0
Description:
此文件提供一套標準化的指導方針，用於分析和記錄專案的相依關係結構，特別針對 .NET 生態系統中的專案。目的是幫助開發者理解各系統元件間的連接關係，促進更好的架構決策和重構規劃。
-->

## 分析目的

此文件旨在提供標準化方法，用於分析專案的相依關係結構，幫助開發者理解各系統元件間的連接關係，促進更好的架構決策和重構規劃。

## 分析步驟
1. **識別目標專案**：確定需要分析的主要專案/API/模組/函式庫/應用程式/服務等
   - 確認專案的名稱和版本
   - 確認專案的主要功能和用途
   - 確定專案的主要開發語言（如 C#, F#, VB.NET 等）
   - 確定專案的主要架構（如 ASP.NET Core, WPF, Xamarin 等）
   - 確定專案的主要依賴管理工具（如 NuGet, Paket 等）
   - 確定專案的主要測試框架（如 xUnit, NUnit, MSTest 等）
- **識別核心函式庫**：列出專案中所有內部函式庫和模組，特別是核心基礎函式庫
   - 確認每個函式庫的主要功能和用途
   - 確定每個函式庫的相依性和次級相依性
   - 確定每個函式庫的版本和更新歷史
1. **檢查專案參考**：審查 `.csproj`/`.fsproj`/`.vbproj`/`.sln`/`.config`  等檔案，確定所有相依性
   - 確認專案中引用的所有函式庫和套件
   - 確認每個函式庫和套件的版本和來源
   - 確認是否有任何未使用的相依性
2. **識別核心函式庫相依性**：分析內部函式庫的相依結構
   - 確定每個函式庫的直接相依性
   - 確定每個函式庫的次級相依性
   - 確認相依性之間的循環依賴問題
3. **識別次級相依性**：深入分析每個函式庫的次級相依性，確保完整性
4. **識別第三方相依套件**：列出所有外部相依套件，特別是關鍵的第三方庫
5. **建立相依關係圖**：使用視覺化工具呈現相依結構
6. **文件化相依關係**：將分析結果整理成標準格式，便於查閱和維護
7. **審查和更新**：定期審查相依關係，確保其準確性和最新性
8. **提供完整分析報告**：以標準格式提供完整分析報告，包含所有相依性和結構圖

## 分析輸出格式

### 1. 核心基礎函式庫層相依性

列出所有內部函式庫相依性，包括:
- 函式庫名稱和路徑
- 主要功能描述
- 次級相依性

### 2. 主要第三方相依套件

列出關鍵外部相依套件，包括:
- 套件名稱
- 用途簡述

### 3. 相依關係結構

使用樹狀圖表示完整相依關係鏈:
```
- 根節點：主要專案
  - 子節點：核心函式庫
    - 子節點：次級函式庫
      - 子節點：第三方套件
```
### 4. 相依性圖示
使用工具（如 Graphviz、PlantUML）生成相依性圖示，顯示各函式庫和套件間的連接關係。
### 5. 文檔化格式
使用 Markdown 或其他標準格式，將分析結果整理成易於閱讀的文檔，包括：    
- 標題和小節
- 清晰的列表和表格
- 代碼片段（如有需要）
- 圖示和圖表（如有需要）
## 注意事項
- 確保所有相依性都被正確識別和記錄

