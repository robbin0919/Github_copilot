bonds_process/   
│  
├── bin/  
│   └── sqlite3.exe         # SQLite 執行檔  
│  
├── sql/  
│   ├── create_tables.sql   # 資料表建立腳本  
│   └── import_data.sql     # 資料導入腳本  
│  
├── data/  
│   └── input_bonds.txt     # 債券輸入資料  
│  
├── config/  
│   ├── time.txt           # UTC 時間設定  
│   └── user.txt           # 使用者設定  
│  
└── scripts/  
    ├── ProcessBonds.bat    # 債券資料處理批次檔  
    ├── ImportToSQLite.bat  # 資料庫導入批次檔  
    └── RunAll.bat          # 主要執行批次檔  
