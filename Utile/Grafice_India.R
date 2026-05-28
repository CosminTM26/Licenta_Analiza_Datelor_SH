# ============================================================
# GRAFICE PIATA AUTO INDIA - PENTRU LUCRARE
# ============================================================
# Teorie: Bhargava & Freiberg - "Frugal Innovation"
#         Bhargava & Seetha (2010) - "The Maruti Story"
#         Storchmann (2004) - depreciere lenta in piete emergente
#
# Rulare: source("Utile/Grafice_India.R")
# Output: 6 grafice afisate in Plots pane (RStudio)
# ============================================================

source("Utile/Grafice_Helpers.R")

# ---- Incarcare + filtrare outliere ----
df <- incarca_piata("India_Cars_Cleaned", ps = "optional")
cat("India - randuri dupa filtrare:", nrow(df), "\n")

# ============================================================
# GRAFIC 1: Histograma pret (distributie de baza)
# ============================================================
p1 <- df %>%
  ggplot(aes(x = price_in_euro)) +
  geom_histogram(bins = 50, fill = culori_piete["India"], color = "white") +
  labs(title = "Distributia preturilor - India",
       subtitle = paste("N =", nrow(df), "vehicule"),
       x = "Pret (EUR)", y = "Numar masini") +
  tema
print(p1)

# ============================================================
# GRAFIC 2: Histograma varsta (distributie de baza)
# ============================================================
p2 <- df %>%
  ggplot(aes(x = varsta)) +
  geom_histogram(bins = 25, fill = culori_piete["India"], color = "white") +
  labs(title = "Distributia varstei masinilor - India",
       subtitle = "Varsta = 2023 - anul fabricatiei",
       x = "Varsta (ani)", y = "Numar masini") +
  tema
print(p2)

# ============================================================
# GRAFIC 3: Bar - Distributia pe tip caroserie
# TEORIE: Frugal Innovation (Bhargava & Freiberg)
#   Hatchback domina = utilitate maxima la cost minim
# ============================================================
p3 <- df %>%
  filter(!is.na(body_type), body_type != "") %>%
  count(body_type, sort = TRUE) %>%
  mutate(body_type = fct_reorder(body_type, n)) %>%
  ggplot(aes(x = body_type, y = n)) +
  geom_col(fill = culori_piete["India"]) +
  geom_text(aes(label = scales::comma(n)), hjust = -0.1, size = 3.5) +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(title = "Distributia pe tip caroserie - India",
       subtitle = "Dominanta Hatchback confirma teoria frugal innovation",
       x = NULL, y = "Numar masini") +
  tema + theme(panel.grid.major.y = element_blank())
print(p3)

# ============================================================
# GRAFIC 4: Boxplot - Pret pe tip caroserie (top 6)
# Combina volumul (graf 3) cu pretul: Hatchback ieftin, SUV scump
# ============================================================
top_body <- df %>%
  filter(!is.na(body_type), body_type != "") %>%
  count(body_type, sort = TRUE) %>%
  slice_max(n, n = 6) %>%
  pull(body_type)

p4 <- df %>%
  filter(body_type %in% top_body) %>%
  mutate(body_type = fct_reorder(body_type, price_in_euro, median)) %>%
  ggplot(aes(x = body_type, y = price_in_euro, fill = body_type)) +
  geom_boxplot(outlier.alpha = 0.2) +
  scale_fill_brewer(palette = "Set2", guide = "none") +
  labs(title = "Pret median pe tip caroserie - India",
       subtitle = "Hatchback = accesibil; SUV = top de gama",
       x = NULL, y = "Pret (EUR)") +
  tema
print(p4)

# ============================================================
# GRAFIC 5: Scatter - Curba depreciere India
# TEORIE: Storchmann (2004) - panta MAI PLATA decat in piete mature
# ============================================================
p5 <- df %>%
  ggplot(aes(x = varsta, y = price_in_euro)) +
  geom_point(alpha = 0.15, color = culori_piete["India"], size = 0.8) +
  geom_smooth(method = "loess", color = "black",
              se = TRUE, linewidth = 1) +
  scale_y_log10(labels = scales::comma) +
  labs(title = "Curba de depreciere - India",
       subtitle = "Axa Y log10; linia LOESS = trend median",
       x = "Varsta (ani)", y = "Pret (EUR, log10)") +
  tema
print(p5)

# ============================================================
# GRAFIC 6: Bar - Top 10 branduri auto in India
# TEORIE: Bhargava & Seetha (2010) - "The Maruti Story"
#   Dominanta Maruti Suzuki = inovatia frugala institutionalizata
# ============================================================
p6 <- df %>%
  filter(!is.na(brand), brand != "") %>%
  count(brand, sort = TRUE) %>%
  slice_max(n, n = 10) %>%
  mutate(brand = fct_reorder(brand, n)) %>%
  ggplot(aes(x = brand, y = n)) +
  geom_col(fill = culori_piete["India"]) +
  geom_text(aes(label = scales::comma(n)), hjust = -0.1, size = 3.5) +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(title = "Top 10 cele mai tranzactionate branduri - India",
       subtitle = "Maruti Suzuki domina piata, confirmand 'The Maruti Story'",
       x = NULL, y = "Numar masini") +
  tema + theme(panel.grid.major.y = element_blank())
print(p6)

cat("\n=== INDIA - 6 grafice in Plots pane ===\n")
