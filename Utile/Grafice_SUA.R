# ============================================================
# GRAFICE PIATA AUTO SUA - PENTRU LUCRARE
# ============================================================
# Teorie: Ingrassia "Engines of Change" - cultura motoarelor mari,
#         SUV/Pick-up, tractiune integrala
# Particularitate: SUA NU are power_ps -> folosim engine_type (cilindree)
#
# Rulare: source("Utile/Grafice_SUA.R")
# Output: 5 grafice afisate in Plots pane (RStudio)
# ============================================================

source("Utile/Grafice_Helpers.R")

# ---- Incarcare + filtrare outliere ----
df <- incarca_piata("SUA_Cars_Cleaned") %>%
  filter(year <= 2023) %>%
  mutate(age = 2023 - year)
cat("SUA - randuri din baza de date (pana in 2023):", nrow(df), "\n")

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
  geom_histogram(bins = 60, fill = culori_piete["SUA"], color = "white") +
  scale_x_continuous(
    breaks = marcaje,
    labels = function(x) ifelse(x == limita_99,
                                paste0(">", scales::comma(round(x))),
                                scales::comma(round(x)))
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Distributia preturilor - SUA",
       subtitle = paste0("N = ", nrow(df), " vehicule (ultima bara = preturi peste percentila 99%)"),
       x = "Pret (EUR)", y = "Numar masini") +
  tema
print(p1)

# ============================================================
# GRAFIC 2: Histograma rulaj (Kilometraj / Mileage)
# Ultima bara grupeaza rulajele peste percentila 99%
# ============================================================
limita_99_km <- quantile(df$km, 0.99, na.rm = TRUE)
marcaje_km <- pretty(c(0, limita_99_km), n = 6)
marcaje_km <- c(marcaje_km[marcaje_km < limita_99_km * 0.95], limita_99_km)
marcaje_km <- unique(round(marcaje_km))

p2 <- df %>%
  mutate(km_plot = pmin(km, limita_99_km, na.rm = TRUE)) %>%
  ggplot(aes(x = km_plot)) +
  geom_histogram(bins = 60, fill = culori_piete["SUA"], color = "white") +
  scale_x_continuous(
    breaks = marcaje_km,
    labels = function(x) ifelse(x == limita_99_km,
                                paste0(">", scales::comma(round(x))),
                                scales::comma(round(x)))
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Distributia rulajului (Kilometraj) - SUA",
       subtitle = paste0("N = ", nrow(df), " vehicule (ultima bara = rulaje peste percentila 99%)"),
       x = "Rulaj (km)", y = "Numar masini") +
  tema
print(p2)

# ============================================================
# GRAFIC 3: Bar - Distributia pe tip tractiune
# TEORIE: Ingrassia - americanii prefera AWD/4WD pentru
#   SUV/Pick-up/lifestyle outdoor
# ============================================================
p3 <- df %>%
  filter(!is.na(drivetrain), drivetrain != "") %>%
  count(drivetrain, sort = TRUE) %>%
  mutate(drivetrain = fct_reorder(drivetrain, n),
         procent = round(100 * n / sum(n), 1)) %>%
  ggplot(aes(x = drivetrain, y = n)) +
  geom_col(fill = culori_piete["SUA"]) +
  geom_text(aes(label = paste0(scales::comma(n), " (", procent, "%)")),
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.18)), labels = scales::comma) +
  labs(title = "Distributia tipului de tractiune - SUA",
       subtitle = "AWD/4WD reflecta cultura SUV/Pick-up (Ingrassia)",
       x = NULL, y = "Numar masini") +
  tema +
  theme(panel.grid.major.y = element_blank())
print(p3)

# ============================================================
# GRAFIC 4: Scatter - Cilindree vs Pret
# TEORIE: Ingrassia "more is more" - corelatie pozitiva puternica
#   intre cilindree (proxy de putere) si pret
# ============================================================
df_engine <- df %>%
  filter(!is.na(engine_type), engine_type >= 0.5, engine_type <= 8)

cor_val <- round(cor(df_engine$engine_type,
                     df_engine$price_in_euro, use = "complete.obs"), 3)

limita_99 <- quantile(df_engine$price_in_euro, 0.99, na.rm = TRUE)
marcaje_pret <- pretty(c(0, limita_99), n = 8)
marcaje_pret <- c(marcaje_pret[marcaje_pret < limita_99 * 0.95], limita_99)

p4 <- df_engine %>%
  mutate(price_plot = pmin(price_in_euro, limita_99, na.rm = TRUE)) %>%
  ggplot(aes(x = engine_type, y = price_plot)) +
  geom_point(alpha = 0.15, color = culori_piete["SUA"], size = 0.8) +
  geom_smooth(method = "lm", formula = y ~ x, color = "black",
              se = TRUE, linewidth = 1) +
  scale_y_continuous(
    breaks = marcaje_pret,
    labels = function(y) ifelse(y == limita_99,
                                paste0(">", scales::comma(round(y))),
                                scales::comma(round(y)))
  ) +
  labs(title = "Cilindree vs Pret - SUA",
       subtitle = paste0("Corelatie Pearson r = ", cor_val,
                         " (americanii pretiuesc motoarele mari)"),
       x = "Cilindree (litri)", y = "Pret (EUR)") +
  tema
print(p4)

# ============================================================
# GRAFIC 5: Scatter - Curba de depreciere (Pret vs Varsta) - SUA
# TEORIE: Storchmann (2004) - depreciere rapida in primii 3-5 ani
# ============================================================
limita_99_p <- quantile(df$price_in_euro, 0.99, na.rm = TRUE)
marcaje_yp <- pretty(c(0, limita_99_p), n = 8)
marcaje_yp <- c(marcaje_yp[marcaje_yp < limita_99_p * 0.95], limita_99_p)

limita_99_age <- quantile(df$age, 0.99, na.rm = TRUE)
marcaje_varsta <- pretty(c(0, limita_99_age), n = 8)
marcaje_varsta <- c(marcaje_varsta[marcaje_varsta < limita_99_age * 0.95], limita_99_age)
marcaje_varsta <- unique(round(marcaje_varsta))

p5 <- df %>%
  mutate(age_plot = pmin(age, limita_99_age, na.rm = TRUE),
         price_plot = pmin(price_in_euro, limita_99_p, na.rm = TRUE)) %>%
  ggplot(aes(x = age_plot, y = price_plot)) +
  geom_point(alpha = 0.05, color = culori_piete["SUA"], size = 0.5) +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), color = "black",
              se = TRUE, linewidth = 1) +
  scale_x_continuous(
    breaks = marcaje_varsta,
    labels = function(x) ifelse(x == limita_99_age,
                                paste0(">", round(x)),
                                as.character(round(x))),
    limits = c(0, limita_99_age)
  ) +
  scale_y_continuous(
    breaks = marcaje_yp,
    labels = function(y) ifelse(y == limita_99_p,
                                paste0(">", scales::comma(round(y))),
                                scales::comma(round(y)))
  ) +
  labs(title = "Curba de depreciere (Pret vs Varsta) - SUA",
       subtitle = "Linia GAM = trend; depreciere accelerata in primii 3-5 ani (Storchmann, 2004)",
       x = "Varsta (ani)", y = "Pret (EUR)") +
  tema
print(p5)

cat("\n=== SUA - 5 grafice in Plots pane ===\n")
cat("Corelatie Pearson cilindree-pret:", cor_val, "\n")
