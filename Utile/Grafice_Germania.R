# ============================================================
# GRAFICE PIATA AUTO GERMANIA - PENTRU LUCRARE
# ============================================================
# Teorie: Dominanta brand-urilor premium (BMW, Mercedes, Audi, VW)
#         Reglementari UE EURO 5/6/7 -> CO2 dicteaza pretul rezidual
#         Storchmann (2004) - depreciere accentuata in piete mature
#
# Rulare: source("Utile/Grafice_Germania.R")
# Output: 5 grafice afisate in Plots pane (RStudio)
# ============================================================

source("Utile/Grafice_Helpers.R")

# ---- Incarcare + filtrare outliere ----
df <- incarca_piata("Germany_Cars_Cleaned", ps = "obligatoriu")
cat("Germania - randuri dupa filtrare:", nrow(df), "\n")

# ============================================================
# GRAFIC 1: Histograma pret (distributie de baza)
# ============================================================
p1 <- df %>%
  ggplot(aes(x = price_in_euro)) +
  geom_histogram(bins = 60, fill = culori_piete["Germania"], color = "white") +
  scale_x_continuous(labels = scales::comma) +
  labs(title = "Distributia preturilor - Germania",
       subtitle = paste("N =", nrow(df), "vehicule"),
       x = "Pret (EUR)", y = "Numar masini") +
  tema
print(p1)

# ============================================================
# GRAFIC 2: Histograma varsta (distributie de baza)
# ============================================================
p2 <- df %>%
  ggplot(aes(x = varsta)) +
  geom_histogram(bins = 25, fill = culori_piete["Germania"], color = "white") +
  labs(title = "Distributia varstei masinilor - Germania",
       subtitle = "Varsta = 2023 - anul fabricatiei",
       x = "Varsta (ani)", y = "Numar masini") +
  tema
print(p2)

# ============================================================
# GRAFIC 3: Boxplot - Pret pe brand (top 12)
# TEORIE: Triunghiul premium BMW/Mercedes/Audi domina segmentul;
#   VW = volum mare dar mediana moderata; asiatice = value
# ============================================================
top_brands <- df %>%
  count(brand, sort = TRUE) %>%
  slice_max(n, n = 12) %>%
  pull(brand)

p3 <- df %>%
  filter(brand %in% top_brands) %>%
  mutate(brand = fct_reorder(brand, price_in_euro, median)) %>%
  ggplot(aes(x = brand, y = price_in_euro, fill = brand)) +
  geom_boxplot(outlier.alpha = 0.15) +
  scale_fill_viridis_d(option = "D", guide = "none") +
  scale_y_continuous(labels = scales::comma) +
  coord_flip() +
  labs(title = "Pret median pe brand - Top 12 marci, Germania",
       subtitle = "Brand-urile premium (BMW, Mercedes, Audi) domina",
       x = NULL, y = "Pret (EUR)") +
  tema
print(p3)

# ============================================================
# GRAFIC 4: Scatter - CO2 vs Varsta
# TEORIE: Normele UE (EURO 5/6) penalizeaza masinile vechi;
#   masinile mai vechi = motoare mai ineficiente = CO2 mai mare
# ============================================================
df_co2 <- df %>%
  filter(!is.na(co2_g), co2_g > 0, co2_g <= 500)

p4 <- df_co2 %>%
  ggplot(aes(x = varsta, y = co2_g)) +
  geom_point(alpha = 0.15, color = culori_piete["Germania"], size = 0.8) +
  geom_smooth(method = "loess", color = "black",
              se = TRUE, linewidth = 1) +
  labs(title = "Emisii CO2 vs Varsta - Germania",
       subtitle = "Masinile vechi emit mai mult -> penalizate de UE",
       x = "Varsta (ani)", y = "Emisii CO2 (g/km)") +
  tema
print(p4)

# ============================================================
# GRAFIC 5: Scatter - CO2 vs Pret
# Confirmare directa: CO2 mic = masini noi, scumpe;
#   CO2 mare = vechi, ieftine (efect indirect varsta-tehnologie)
# ============================================================
cor_co2_pret <- round(cor(df_co2$co2_g, df_co2$price_in_euro,
                          use = "complete.obs"), 3)

p5 <- df_co2 %>%
  ggplot(aes(x = co2_g, y = price_in_euro)) +
  geom_point(alpha = 0.15, color = culori_piete["Germania"], size = 0.8) +
  geom_smooth(method = "loess", color = "black",
              se = TRUE, linewidth = 1) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Emisii CO2 vs Pret - Germania",
       subtitle = paste0("Corelatie Pearson r = ", cor_co2_pret,
                         " (efect indirect varsta-tehnologie)"),
       x = "Emisii CO2 (g/km)", y = "Pret (EUR)") +
  tema
print(p5)

cat("\n=== GERMANIA - 5 grafice in Plots pane ===\n")
cat("Corelatie Pearson CO2-pret:", cor_co2_pret, "\n")
