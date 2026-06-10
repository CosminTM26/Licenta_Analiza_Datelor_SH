# ============================================================
# GRAFICE PIATA AUTO SUA - PENTRU LUCRARE
# ============================================================
# Teorie: Ingrassia "Engines of Change" - cultura motoarelor mari,
#         SUV/Pick-up, tractiune integrala
# Particularitate: SUA NU are power_ps -> folosim engine_type (cilindree)
#
# Rulare: source("Utile/Grafice_SUA.R")
# Output: 6 grafice afisate in Plots pane (RStudio)
# ============================================================

source("Utile/Grafice_Helpers.R")

# ---- Incarcare date (filtrarea anilor > 2023 e facuta in incarca_piata) ----
df <- incarca_piata("SUA_Cars_Cleaned") %>%
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

# Linii de referinta: mediana (negru, intrerupt) si media (gri, punctat)
mediana_pret <- median(df$price_in_euro, na.rm = TRUE)
media_pret <- mean(df$price_in_euro, na.rm = TRUE)

p1 <- df %>%
  mutate(price_plot = pmin(price_in_euro, limita_99, na.rm = TRUE)) %>%
  ggplot(aes(x = price_plot)) +
  geom_histogram(bins = 60, fill = culori_piete["SUA"], color = "white") +
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
  labs(title = "Distributia preturilor - SUA",

       x = "Pret (EUR)", y = "Numar masini") +
  tema
print(p1)
salveaza_grafic('sua_p1.svg')

# ============================================================
# GRAFIC 2: Histograma rulaj (Kilometraj / Mileage)
# Ultima bara grupeaza rulajele peste percentila 99%
# ============================================================
limita_99_km <- quantile(df$km, 0.99, na.rm = TRUE)
marcaje_km <- pretty(c(0, limita_99_km), n = 6)
marcaje_km <- c(marcaje_km[marcaje_km < limita_99_km * 0.95], limita_99_km)
marcaje_km <- unique(round(marcaje_km))

# Linii de referinta: mediana (negru, intrerupt) si media (gri, punctat)
mediana_km <- median(df$km, na.rm = TRUE)
media_km <- mean(df$km, na.rm = TRUE)

p2 <- df %>%
  mutate(km_plot = pmin(km, limita_99_km, na.rm = TRUE)) %>%
  ggplot(aes(x = km_plot)) +
  geom_histogram(bins = 60, fill = culori_piete["SUA"], color = "white") +
  geom_vline(xintercept = mediana_km, color = "black", linetype = "dashed", linewidth = 0.8) +
  geom_vline(xintercept = media_km, color = "grey35", linetype = "dotted", linewidth = 0.8) +
  annotate("text", x = mediana_km, y = Inf, label = paste0("Mediana: ", scales::comma(round(mediana_km)), " km"),
           vjust = 2, hjust = -0.05, size = 3.5) +
  annotate("text", x = media_km, y = Inf, label = paste0("Media: ", scales::comma(round(media_km)), " km"),
           vjust = 3.8, hjust = -0.05, size = 3.5) +
  scale_x_continuous(
    breaks = marcaje_km,
    labels = function(x) ifelse(x == limita_99_km,
                                paste0(">", scales::comma(round(x))),
                                scales::comma(round(x)))
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Distributia rulajului (Kilometraj) - SUA",

       x = "Rulaj (km)", y = "Numar masini") +
  tema
print(p2)
salveaza_grafic('sua_p2.svg')

# ============================================================
# GRAFIC 3: Bar - Distributia pe tip tractiune
# TEORIE: Ingrassia - americanii prefera AWD/4WD pentru
#   SUV/Pick-up/lifestyle outdoor
# ============================================================
p3 <- df %>%
  filter(!is.na(drivetrain), drivetrain != "") %>%
  count(drivetrain, sort = TRUE) %>%
  mutate(procent = round(100 * n / sum(n), 1)) %>%   # procent din total (inainte de slice)
  slice_max(n, n = 4) %>%                             # pastram doar top 4 tractiuni (scoatem 2WD)
  mutate(drivetrain = fct_reorder(drivetrain, n)) %>%
  ggplot(aes(x = drivetrain, y = n)) +
  geom_col(fill = culori_piete["SUA"]) +
  geom_text(aes(label = paste0(scales::comma(n), " (", procent, "%)")),
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.40)), labels = scales::comma) +
  labs(title = "Distributia tipului de tractiune - SUA",

       x = NULL, y = "Numar masini") +
  tema +
  theme(panel.grid.major.y = element_blank())
print(p3)
salveaza_grafic('sua_p3.svg')

# ============================================================
# GRAFIC 4: Scatter - Cilindree vs Pret
# TEORIE: Ingrassia "more is more" - corelatie pozitiva puternica
#   intre cilindree (proxy de putere) si pret
# ============================================================
# Doar motoare termice: excludem electricele (engine_type lipsa) ca sa nu
# distorsioneze corelatia pozitiva litraj-pret cu un grup scump la litraj 0.
df_engine <- df %>%
  filter(!is.na(engine_type), engine_type > 0)

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
  labs(title = "Capacitate vs Pret - SUA",

       x = "Capacitate motor (litri)", y = "Pret (EUR)") +
  tema
print(p4)
salveaza_grafic('sua_p4.png')

# ============================================================
# GRAFIC 5: Scatter - Curba de depreciere (Pret vs Varsta) - SUA
# TEORIE: Storchmann (2004) - depreciere rapida in primii 3-5 ani
# ============================================================
limita_99_p <- quantile(df$price_in_euro, 0.99, na.rm = TRUE)
marcaje_yp <- pretty(c(0, limita_99_p), n = 8)
marcaje_yp <- c(marcaje_yp[marcaje_yp < limita_99_p * 0.95], limita_99_p)

limita_99_age <- quantile(df$age, 0.99, na.rm = TRUE)
marcaje_varsta <- c(seq(0, limita_99_age, by = 2), limita_99_age)
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
       x = "Varsta (ani)", y = "Pret (EUR)") +
  tema
print(p5)
salveaza_grafic('sua_p5.png')

# ============================================================
# GRAFIC 6: Boxplot - Pret vs Istoric proprietari (one_owner)
# Variabila one_owner (Yes/No) e folosita direct ca factor de modelul RF.
# Masinile cu un singur proprietar isi pastreaza valoarea mai bine.
# (excludem 'Unknown', exact ca la antrenarea modelului)
# ============================================================
limita_99 <- quantile(df$price_in_euro, 0.99, na.rm = TRUE)
marcaje_pret <- pretty(c(0, limita_99), n = 8)
marcaje_pret <- c(marcaje_pret[marcaje_pret < limita_99 * 0.95], limita_99)

p6 <- df %>%
  filter(one_owner %in% c("Yes", "No")) %>%
  mutate(price_plot = pmin(price_in_euro, limita_99, na.rm = TRUE),
         proprietari = recode(one_owner, "Yes" = "Un proprietar", "No" = "Mai multi proprietari"),
         proprietari = fct_reorder(proprietari, price_plot, median)) %>%
  ggplot(aes(x = proprietari, y = price_plot, fill = proprietari)) +
  geom_boxplot(outlier.alpha = 0.1) +
  scale_fill_brewer(palette = "Set2", guide = "none") +
  scale_y_continuous(
    breaks = marcaje_pret,
    labels = function(y) ifelse(y == limita_99,
                                paste0(">", scales::comma(round(y))),
                                scales::comma(round(y)))
  ) +
  labs(title = "Pret vs istoric proprietari - SUA",
       x = NULL, y = "Pret (EUR)") +
  tema
print(p6)
salveaza_grafic('sua_p6.png')

cat("\n=== SUA - 6 grafice in Plots pane ===\n")
cat("Corelatie Pearson cilindree-pret:", cor_val, "\n")
