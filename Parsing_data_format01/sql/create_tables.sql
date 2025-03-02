CREATE TABLE IF NOT EXISTS bonds (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    create_time DATETIME NOT NULL,
    create_user TEXT NOT NULL,
    bond_code TEXT NOT NULL,
    bond_name TEXT NOT NULL,
    tags TEXT,
    quote_date TEXT,
    purchase_price DECIMAL(10,4),
    coupon_rate DECIMAL(10,4),
    payment_freq TEXT,
    maturity_date TEXT,
    ytm_ytc DECIMAL(10,4),
    industry TEXT,
    currency TEXT,
    min_purchase INTEGER,
    risk_level TEXT,
    UNIQUE(bond_code, create_time)
);

CREATE INDEX IF NOT EXISTS idx_bonds_code ON bonds(bond_code);
CREATE INDEX IF NOT EXISTS idx_bonds_create_time ON bonds(create_time);
CREATE INDEX IF NOT EXISTS idx_bonds_risk_level ON bonds(risk_level);