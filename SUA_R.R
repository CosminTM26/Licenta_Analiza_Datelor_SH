# Încărcăm pachetele necesare
library(DBI)
library(RSQLite)
library(dplyr)

# 1. Ne conectăm la SQLite și aducem tabelul în memoria R
# (Înlocuiește "Numele_Bazei_Tale.db" cu numele real al fișierului tău)
con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
SUA_Cars <- dbReadTable(con, "SUA_Cars_Cleaned")
dbDisconnect(con) # Închidem imediat conexiunea, datele sunt acum în R!

# 2. Vedem structura de bază: Câte rânduri au mai rămas și tipul coloanelor
glimpse(SUA_Cars)

# 3. VERIFICAREA DATELOR LIPSA (NA-uri)
# Asta îți va arăta exact câte valori goale ai pe fiecare coloană
colSums(is.na(SUA_Cars))

# 4. VERIFICAREA VALORILOR ABERANTE (Outliers)
# Generează minimul, maximul, media și mediana pentru toate coloanele numerice
(summary(SUA_Cars))