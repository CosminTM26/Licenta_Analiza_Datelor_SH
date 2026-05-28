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
df <- incarca_piata("Germany_Cars_Cleaned") %>% filter(year <= 2023)
cat("Germania - randuri din baza de date (pana in 2023):", nrow(df), "\n")

# ============================================================
# GRAFIC 1: Histograma pret (distributie de baza)
# Ultima bara grupeaza preturile peste percentila 99% (ex: >150,000 EUR)
# Nu pierdem date - doar "impingem" outlierele intr-o singura bara vizibila
# ============================================================
limita_99 <- quantile(df$price_in_euro, 0.99, na.rm = TRUE)
marcaje <- pretty(c(0, limita_99), n = 8)
marcaje <- c(marcaje[marcaje < limita_99 * 0.95], limita_99)

p1 <- df %>%
  mutate(price_plot = pmin(price_in_euro, limita_99, na.rm = TRUE)) %>%
  ggplot(aes(x = price_plot)) +
  geom_histogram(bins = 60, fill = culori_piete["Germania"], color = "white") +
  scale_x_continuous(
    breaks = marcaje,
    labels = function(x) ifelse(x == limita_99,
                                paste0(">", scales::comma(round(x))),
                                scales::comma(round(x)))
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Distributia preturilor - Germania",
       subtitle = paste0("N = ", nrow(df), " vehicule (ultima bara = preturi peste percentila 99%)"),
       x = "Pret (EUR)", y = "Numar masini") +
  tema
print(p1)

# ============================================================
# GRAFIC 2: Histograma an fabricatie (distributie de baza)
# Prima bara grupeaza anii de fabricatie sub percentila 1%
# ============================================================
limita_1_y <- quantile(df$year, 0.01, na.rm = TRUE)
marcaje_an <- pretty(c(limita_1_y, 2023), n = 8)
marcaje_an <- c(limita_1_y, marcaje_an[marcaje_an > limita_1_y + 2 & marcaje_an < 2023], 2023)
marcaje_an <- unique(marcaje_an)

p2 <- df %>%
  mutate(year_plot = pmax(year, limita_1_y, na.rm = TRUE)) %>%
  ggplot(aes(x = year_plot)) +
  geom_histogram(binwidth = 1, center = 0, fill = culori_piete["Germania"], color = "white") +
  scale_x_continuous(
    breaks = marcaje_an,
    labels = function(x) ifelse(x == limita_1_y,
                                paste0("<", round(x)),
                                as.character(round(x))),
    limits = c(limita_1_y - 0.5, 2023 + 0.5)
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Distributia anului de fabricatie - Germania",
       subtitle = paste0("Prima bara = ani de fabricatie sub ", round(limita_1_y)),
       x = "An fabricatie", y = "Numar masini") +
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

limita_99 <- quantile(df$price_in_euro[df$brand %in% top_brands], 0.99, na.rm = TRUE)
marcaje_pret <- pretty(c(0, limita_99), n = 8)
marcaje_pret <- c(marcaje_pret[marcaje_pret < limita_99 * 0.95], limita_99)

p3 <- df %>%
  filter(brand %in% top_brands) %>%
  mutate(price_plot = pmin(price_in_euro, limita_99, na.rm = TRUE),
         brand = fct_reorder(brand, price_plot, median)) %>%
  ggplot(aes(x = brand, y = price_plot, fill = brand)) +
  geom_boxplot(outlier.alpha = 0.15) +
  scale_fill_viridis_d(option = "D", guide = "none") +
  scale_y_continuous(
    breaks = marcaje_pret,
    labels = function(y) ifelse(y == limita_99,
                                paste0(">", scales::comma(round(y))),
                                scales::comma(round(y)))
  ) +
  coord_flip() +
  labs(title = "Pret median pe brand - Top 12 marci, Germania",
       subtitle = "Brand-urile premium (BMW, Mercedes, Audi) domina",
       x = NULL, y = "Pret (EUR)") +
  tema
print(p3)

# ============================================================
# GRAFIC 4: Scatter - CO2 vs An fabricatie
# TEORIE: Normele UE (EURO 5/6) penalizeaza masinile vechi;
#   masinile mai vechi = motoare mai ineficiente = CO2 mai mare
# ============================================================
df_co2 <- df %>% filter(!is.na(co2_g), co2_g > 0)

limita_99_co2 <- quantile(df_co2$co2_g, 0.99, na.rm = TRUE)
marcaje_co2 <- pretty(c(0, limita_99_co2), n = 8)
marcaje_co2 <- c(marcaje_co2[marcaje_co2 < limita_99_co2 * 0.95], limita_99_co2)

p4 <- df_co2 %>%
  mutate(year_plot = pmax(year, limita_1_y, na.rm = TRUE),
         co2_plot = pmin(co2_g, limita_99_co2, na.rm = TRUE)) %>%
  ggplot(aes(x = year_plot, y = co2_plot)) +
  geom_point(alpha = 0.15, color = culori_piete["Germania"], size = 0.8) +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), color = "black",
              se = TRUE, linewidth = 1) +
  scale_x_continuous(
    breaks = marcaje_an,
    labels = function(x) ifelse(x == limita_1_y,
                                paste0("<", round(x)),
                                as.character(round(x))),
    limits = c(limita_1_y, 2023)
  ) +
  scale_y_continuous(
    breaks = marcaje_co2,
    labels = function(y) ifelse(y == limita_99_co2,
                                paste0(">", round(y)),
                                as.character(round(y)))
  ) +
  labs(title = "Emisii CO2 vs An fabricatie - Germania",
       subtitle = "Masinile vechi emit mai mult -> penalizate de UE",
       x = "An fabricatie", y = "Emisii CO2 (g/km)") +
  tema
print(p4)

# ============================================================
# GRAFIC 5: Scatter - CO2 vs Pret
# Confirmare directa: CO2 mic = masini noi, scumpe;
#   CO2 mare = vechi, ieftine (efect indirect varsta-tehnologie)
# ============================================================
cor_co2_pret <- round(cor(df_co2$co2_g, df_co2$price_in_euro,
                          use = "complete.obs"), 3)

limita_99_p <- quantile(df_co2$price_in_euro, 0.99, na.rm = TRUE)
marcaje_yp <- pretty(c(0, limita_99_p), n = 8)
marcaje_yp <- c(marcaje_yp[marcaje_yp < limita_99_p * 0.95], limita_99_p)

p5 <- df_co2 %>%
  mutate(co2_plot = pmin(co2_g, limita_99_co2, na.rm = TRUE),
         price_plot = pmin(price_in_euro, limita_99_p, na.rm = TRUE)) %>%
  ggplot(aes(x = co2_plot, y = price_plot)) +
  geom_point(alpha = 0.15, color = culori_piete["Germania"], size = 0.8) +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), color = "black",
              se = TRUE, linewidth = 1) +
  scale_x_continuous(
    breaks = marcaje_co2,
    labels = function(x) ifelse(x == limita_99_co2,
                                paste0(">", round(x)),
                                as.character(round(x)))
  ) +
  scale_y_continuous(
    breaks = marcaje_yp,
    labels = function(y) ifelse(y == limita_99_p,
                                paste0(">", scales::comma(round(y))),
                                scales::comma(round(y)))
  ) +
  labs(title = "Emisii CO2 vs Pret - Germania",
       subtitle = paste0("Corelatie Pearson r = ", cor_co2_pret,
                         " (efect indirect an fabricatie-tehnologie)"),
       x = "Emisii CO2 (g/km)", y = "Pret (EUR)") +
  tema
print(p5)

cat("\n=== GERMANIA - 5 grafice in Plots pane ===\n")
cat("Corelatie Pearson CO2-pret:", cor_co2_pret, "\n")
