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
df <- incarca_piata("SUA_Cars_Cleaned", ps = "fara")
cat("SUA - randuri dupa filtrare:", nrow(df), "\n")

# ============================================================
# GRAFIC 1: Histograma pret (distributie de baza)
# ============================================================
p1 <- df %>%
  ggplot(aes(x = price_in_euro)) +
  geom_histogram(bins = 60, fill = culori_piete["SUA"], color = "white") +
  scale_x_continuous(labels = scales::comma) +
  labs(title = "Distributia preturilor - SUA",
       subtitle = paste("N =", nrow(df), "vehicule"),
       x = "Pret (EUR)", y = "Numar masini") +
  tema
print(p1)

# ============================================================
# GRAFIC 2: Histograma varsta (distributie de baza)
# ============================================================
p2 <- df %>%
  ggplot(aes(x = varsta)) +
  geom_histogram(bins = 25, fill = culori_piete["SUA"], color = "white") +
  labs(title = "Distributia varstei masinilor - SUA",
       subtitle = "Varsta = 2023 - anul fabricatiei",
       x = "Varsta (ani)", y = "Numar masini") +
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
  scale_y_continuous(expand = expansion(mult = c(0, 0.18))) +
  labs(title = "Distributia tipului de tractiune - SUA",
       subtitle = "AWD/4WD reflecta cultura SUV/Pick-up (Ingrassia)",
       x = NULL, y = "Numar masini") +
  tema + theme(panel.grid.major.y = element_blank())
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

p4 <- df_engine %>%
  ggplot(aes(x = engine_type, y = price_in_euro)) +
  geom_point(alpha = 0.15, color = culori_piete["SUA"], size = 0.8) +
  geom_smooth(method = "lm", color = "black",
              se = TRUE, linewidth = 1) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Cilindree vs Pret - SUA",
       subtitle = paste0("Corelatie Pearson r = ", cor_val,
                         " (americanii pretiuesc motoarele mari)"),
       x = "Cilindree (litri)", y = "Pret (EUR)") +
  tema
print(p4)

# ============================================================
# GRAFIC 5: Boxplot - Pret pe tip tractiune
# Combina graficul 3 (volum) cu pretul: AWD/4WD aduc premium
# ============================================================
p5 <- df %>%
  filter(!is.na(drivetrain), drivetrain != "") %>%
  mutate(drivetrain = fct_reorder(drivetrain, price_in_euro, median)) %>%
  ggplot(aes(x = drivetrain, y = price_in_euro, fill = drivetrain)) +
  geom_boxplot(outlier.alpha = 0.2) +
  scale_fill_brewer(palette = "Set2", guide = "none") +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Pret median pe tip tractiune - SUA",
       subtitle = "AWD/4WD aduc premium semnificativ peste FWD",
       x = NULL, y = "Pret (EUR)") +
  tema
print(p5)

cat("\n=== SUA - 5 grafice in Plots pane ===\n")
cat("Corelatie Pearson cilindree-pret:", cor_val, "\n")
