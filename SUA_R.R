# ============================================================
# VERIFICARE SI CURATARE OUTLIERE: Piata auto SH din SUA
# Sursa: tabel SUA_Cars_Cleaned din identifier.sqlite
# Pasi: incarcare → verificare → IQR (pret, km) →
#       boxploturi inainte → eliminare outliere → boxploturi dupa →
#       validare cross-field → raport final
# Nota: SUA nu are power_ps, IQR doar pe pret si km
# ============================================================

library(tidyverse)
library(DBI)
library(RSQLite)

# ============================================================
# PASUL 1: INCARCARE DATE
# ============================================================

con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
SUA_Cars <- dbReadTable(con, "SUA_Cars_Cleaned")
dbDisconnect(con)

# ============================================================
# PASUL 2: VERIFICARE INITIALA
# ============================================================

glimpse(SUA_Cars)
summary(SUA_Cars)
colSums(is.na(SUA_Cars))

# ============================================================
# PASUL 3: DETECTIE OUTLIERE CU IQR
# ============================================================

# Pret
Q1_pret <- quantile(SUA_Cars$price_in_euro, 0.25)
Q3_pret <- quantile(SUA_Cars$price_in_euro, 0.75)
IQR_pret <- Q3_pret - Q1_pret
limita_jos_pret <- Q1_pret - 1.5 * IQR_pret
limita_sus_pret <- Q3_pret + 1.5 * IQR_pret

# Kilometraj
Q1_km <- quantile(SUA_Cars$km, 0.25)
Q3_km <- quantile(SUA_Cars$km, 0.75)
IQR_km <- Q3_km - Q1_km
limita_jos_km <- Q1_km - 1.5 * IQR_km
limita_sus_km <- Q3_km + 1.5 * IQR_km

# ============================================================
# PASUL 4: BOXPLOT-URI INAINTE DE ELIMINARE
# ============================================================

ggplot(SUA_Cars, aes(y = price_in_euro)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Pret (EUR) - Inainte", y = "Pret") +
  theme_minimal()

ggplot(SUA_Cars, aes(y = km)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Kilometraj - Inainte", y = "Km") +
  theme_minimal()

# ============================================================
# PASUL 5: ELIMINARE OUTLIERE
# ============================================================

n_inainte <- nrow(SUA_Cars)

SUA_Cars <- SUA_Cars %>%
  filter(price_in_euro >= limita_jos_pret) %>%
  filter(km >= limita_jos_km & km <= limita_sus_km) %>%
  filter(year <= 2023)

n_dupa <- nrow(SUA_Cars)

cat("Randuri inainte:", n_inainte, "\n")
cat("Randuri dupa:", n_dupa, "\n")
cat("Eliminate:", n_inainte - n_dupa, "\n")

# ============================================================
# PASUL 6: BOXPLOT-URI DUPA ELIMINARE
# ============================================================

ggplot(SUA_Cars, aes(y = price_in_euro)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Pret (EUR) - Dupa", y = "Pret") +
  theme_minimal()

ggplot(SUA_Cars, aes(y = km)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Kilometraj - Dupa", y = "Km") +
  theme_minimal()

# ============================================================
# PASUL 7: VALIDARE CROSS-FIELD
# ============================================================

# Electrice nu trebuie sa aiba engine_type
SUA_Cars %>%
  filter(fuel_type == "Electric" & !is.na(engine_type)) %>%
  nrow()

# Non-electrice nu trebuie sa aiba engine_type NULL
SUA_Cars %>%
  filter(fuel_type != "Electric" & is.na(engine_type)) %>%
  nrow()

# ============================================================
# PASUL 8: RAPORT FINAL
# ============================================================

cat("\n--- RAPORT FINAL ---\n")
cat("Total randuri:", nrow(SUA_Cars), "\n")
colSums(is.na(SUA_Cars))
summary(SUA_Cars)

# Distributii
table(SUA_Cars$fuel_type)
table(SUA_Cars$transmission_type)
table(SUA_Cars$drivetrain)
table(SUA_Cars$one_owner)

SUA_Cars %>% count(brand, sort = TRUE) %>% head(10)
