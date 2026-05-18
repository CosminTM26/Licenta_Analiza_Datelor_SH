# ============================================================
# VERIFICARE SI CURATARE OUTLIERE: Piata auto SH din Germania
# Sursa: tabel Germany_Cars_Cleaned din identifier.sqlite
# Pasi: incarcare → verificare → IQR (pret, km, power_ps) →
#       boxploturi inainte → eliminare outliere → boxploturi dupa →
#       validare cross-field → raport final
# ============================================================

library(tidyverse)
library(DBI)
library(RSQLite)

# ============================================================
# PASUL 1: INCARCARE DATE
# ============================================================

con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
Germany_Cars <- dbReadTable(con, "Germany_Cars_Cleaned")
dbDisconnect(con)

# ============================================================
# PASUL 2: VERIFICARE INITIALA
# ============================================================

glimpse(Germany_Cars)
summary(Germany_Cars)
colSums(is.na(Germany_Cars))

# ============================================================
# PASUL 3: DETECTIE OUTLIERE CU IQR
# ============================================================

# Pret
Q1_pret <- quantile(Germany_Cars$price_in_euro, 0.25)
Q3_pret <- quantile(Germany_Cars$price_in_euro, 0.75)
IQR_pret <- Q3_pret - Q1_pret
limita_jos_pret <- Q1_pret - 1.5 * IQR_pret
limita_sus_pret <- Q3_pret + 1.5 * IQR_pret

# Kilometraj
Q1_km <- quantile(Germany_Cars$km, 0.25)
Q3_km <- quantile(Germany_Cars$km, 0.75)
IQR_km <- Q3_km - Q1_km
limita_jos_km <- Q1_km - 1.5 * IQR_km
limita_sus_km <- Q3_km + 1.5 * IQR_km

# Putere
Q1_ps <- quantile(Germany_Cars$power_ps, 0.25)
Q3_ps <- quantile(Germany_Cars$power_ps, 0.75)
IQR_ps <- Q3_ps - Q1_ps
limita_jos_ps <- Q1_ps - 1.5 * IQR_ps
limita_sus_ps <- Q3_ps + 1.5 * IQR_ps

# ============================================================
# PASUL 4: BOXPLOT-URI INAINTE DE ELIMINARE
# ============================================================

ggplot(Germany_Cars, aes(y = price_in_euro)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Pret (EUR) - Inainte", y = "Pret") +
  theme_minimal()

ggplot(Germany_Cars, aes(y = km)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Kilometraj - Inainte", y = "Km") +
  theme_minimal()

ggplot(Germany_Cars, aes(y = power_ps)) +
  geom_boxplot(fill = "lightyellow") +
  labs(title = "Putere (PS) - Inainte", y = "PS") +
  theme_minimal()

# ============================================================
# PASUL 5: ELIMINARE OUTLIERE
# ============================================================

n_inainte <- nrow(Germany_Cars)

Germany_Cars <- Germany_Cars %>%
  filter(price_in_euro >= limita_jos_pret & price_in_euro <= limita_sus_pret) %>%
  filter(km >= limita_jos_km & km <= limita_sus_km) %>%
  filter(power_ps >= limita_jos_ps & power_ps <= limita_sus_ps)

n_dupa <- nrow(Germany_Cars)

cat("Randuri inainte:", n_inainte, "\n")
cat("Randuri dupa:", n_dupa, "\n")
cat("Eliminate:", n_inainte - n_dupa, "\n")

# ============================================================
# PASUL 6: BOXPLOT-URI DUPA ELIMINARE
# ============================================================

ggplot(Germany_Cars, aes(y = price_in_euro)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Pret (EUR) - Dupa", y = "Pret") +
  theme_minimal()

ggplot(Germany_Cars, aes(y = km)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Kilometraj - Dupa", y = "Km") +
  theme_minimal()

ggplot(Germany_Cars, aes(y = power_ps)) +
  geom_boxplot(fill = "lightyellow") +
  labs(title = "Putere (PS) - Dupa", y = "PS") +
  theme_minimal()

# ============================================================
# PASUL 7: VALIDARE CROSS-FIELD
# ============================================================

# Electrice nu trebuie sa aiba engine_type
Germany_Cars %>%
  filter(fuel_type == "Electric" & !is.na(engine_type)) %>%
  nrow()

# Non-electrice nu trebuie sa aiba engine_type NULL
Germany_Cars %>%
  filter(fuel_type != "Electric" & is.na(engine_type)) %>%
  nrow()

# ============================================================
# PASUL 8: RAPORT FINAL
# ============================================================

cat("\n--- RAPORT FINAL ---\n")
cat("Total randuri:", nrow(Germany_Cars), "\n")
colSums(is.na(Germany_Cars))
summary(Germany_Cars)

# Distributii
table(Germany_Cars$fuel_type)
table(Germany_Cars$transmission_type)

Germany_Cars %>% count(brand, sort = TRUE) %>% head(10)
