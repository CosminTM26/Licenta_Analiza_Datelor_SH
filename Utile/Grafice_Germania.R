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

# ---- Incarcare date (filtrarea anilor > 2023 e facuta in incarca_piata) ----
df <- incarca_piata("Germany_Cars_Cleaned") %>%
  mutate(age = 2023 - year)
cat("Germania - randuri din baza de date (pana in 2023):", nrow(df), "\n")

# ============================================================
# GRAFIC 1: Histograma pret (distributie de baza)
# Ultima bara grupeaza preturile peste percentila 99% (ex: >150,000 EUR)
# Nu pierdem date - doar "impingem" outlierele intr-o singura bara vizibila
# ============================================================
limita_99 <- quantile(df$price_in_euro, 0.99, na.rm = TRUE)
marcaje <- pretty(c(0, limita_99), n = 8)
marcaje <- c(marcaje[marcaje < limita_99 * 0.95], limita_99)

# Linii de referinta: mediana (negru, intrerupt) si media (gri, punctat)
mediana_pret <- median(df$price_in_euro, na.rm = TRUE)
media_pret <- mean(df$price_in_euro, na.rm = TRUE)

p1 <- df %>%
  mutate(price_plot = pmin(price_in_euro, limita_99, na.rm = TRUE)) %>%
  ggplot(aes(x = price_plot)) +
  geom_histogram(bins = 60, fill = culori_piete["Germania"], color = "white") +
  geom_vline(xintercept = mediana_pret, color = "black", linetype = "dashed", linewidth = 0.8) +
  geom_vline(xintercept = media_pret, color = "grey35", linetype = "dotted", linewidth = 0.8) +
  annotate("text", x = mediana_pret, y = Inf, label = paste0("Mediana: ", scales::comma(round(mediana_pret))),
           vjust = 2, hjust = -0.05, size = 3.5) +
  annotate("text", x = media_pret, y = Inf, label = paste0("Media: ", scales::comma(round(media_pret))),
           vjust = 3.8, hjust = -0.05, size = 3.5) +
  scale_x_continuous(
    breaks = marcaje,
    labels = function(x) ifelse(x == limita_99,
                                paste0(">", scales::comma(round(x))),
                                scales::comma(round(x)))
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Distributia preturilor - Germania",
       x = "Pret (EUR)", y = "Numar masini") +
  tema
print(p1)
salveaza_grafic('germania_p1.svg')

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
       x = NULL, y = "Pret (EUR)") +
  tema
print(p3)
salveaza_grafic('germania_p3.png')   # boxplot cu mii de outlieri desenati: PNG, nu SVG

# ============================================================
# GRAFIC 4: Scatter - CO2 vs An fabricatie
# TEORIE: Normele UE (EURO 5/6) penalizeaza masinile vechi;
#   masinile mai vechi = motoare mai ineficiente = CO2 mai mare
# ============================================================
# Pastram electricele la co2 = 0 (bratul stang "eco-scump" al graficului):
# le convertim NULL-ul in 0 (exact ca electric_zero din model), apoi scoatem
# doar co2 lipsa real (masini termice fara valoare imputata).
df_co2 <- df %>%
  mutate(co2_g = if_else(fuel_type == "Electric" & is.na(co2_g), 0, co2_g)) %>%
  filter(!is.na(co2_g))

# Pragul de 1% pe an (prima eticheta devine "<an") - folosit pe axa X de mai jos
limita_1_y <- quantile(df$year, 0.01, na.rm = TRUE)
marcaje_an <- pretty(c(limita_1_y, 2023), n = 8)
marcaje_an <- c(limita_1_y, marcaje_an[marcaje_an > limita_1_y + 2 & marcaje_an < 2023], 2023)
marcaje_an <- unique(marcaje_an)

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
       x = "An fabricatie", y = "Emisii CO2 (g/km)") +
  tema
print(p4)
salveaza_grafic('germania_p4.png')   # scatter: PNG, nu SVG

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
       x = "Emisii CO2 (g/km)", y = "Pret (EUR)") +
  tema
print(p5)
salveaza_grafic('germania_p5.png')

cat("Corelatie Pearson CO2-pret:", cor_co2_pret, "\n")
