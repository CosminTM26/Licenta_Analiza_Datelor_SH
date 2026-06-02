# ============================================================
# GRAFICE PIATA AUTO INDIA - PENTRU LUCRARE
# ============================================================
# Teorie: Bhargava & Freiberg - "Frugal Innovation"
#         Bhargava & Seetha (2010) - "The Maruti Story"
#         Storchmann (2004) - depreciere lenta in piete emergente
#
# Rulare: source("Utile/Grafice_India.R")
# Output: 7 grafice afisate in Plots pane (RStudio)
# ============================================================

source("Utile/Grafice_Helpers.R")

# ---- Incarcare date (filtrarea anilor > 2023 e facuta in incarca_piata) ----
df <- incarca_piata("India_Cars_Cleaned") %>%
  mutate(age = 2023 - year)
cat("India - randuri din baza de date (pana in 2023):", nrow(df), "\n")

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
  geom_histogram(bins = 50, fill = culori_piete["India"], color = "white") +
  scale_x_continuous(
    breaks = marcaje,
    labels = function(x) ifelse(x == limita_99,
                                paste0(">", scales::comma(round(x))),
                                scales::comma(round(x)))
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Distributia preturilor - India",
       subtitle = paste0("N = ", nrow(df), " vehicule (ultima bara = preturi peste percentila 99%)"),
       x = "Pret (EUR)", y = "Numar masini") +
  tema
print(p1)

# ============================================================
# GRAFIC 2: Histograma varsta masini (distributie de baza)
# Ultima bara grupeaza masinile cu varsta peste percentila 99%
# ============================================================
limita_99_age <- quantile(df$age, 0.99, na.rm = TRUE)
marcaje_varsta <- pretty(c(0, limita_99_age), n = 8)
marcaje_varsta <- c(marcaje_varsta[marcaje_varsta < limita_99_age * 0.95], limita_99_age)
marcaje_varsta <- unique(round(marcaje_varsta))

p2 <- df %>%
  mutate(age_plot = pmin(age, limita_99_age, na.rm = TRUE)) %>%
  ggplot(aes(x = age_plot)) +
  geom_histogram(binwidth = 1, center = 0, fill = culori_piete["India"], color = "white") +
  scale_x_continuous(
    breaks = marcaje_varsta,
    labels = function(x) ifelse(x == limita_99_age,
                                paste0(">", round(x)),
                                as.character(round(x))),
    limits = c(-0.5, limita_99_age + 0.5)
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Distributia varstei masinilor - India",
       subtitle = paste0("Ultima bara = varsta peste ", round(limita_99_age), " ani (arata retentia masinilor in piata)"),
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
  slice_max(n, n = 5) %>%
  mutate(body_type = fct_reorder(body_type, n)) %>%
  ggplot(aes(x = body_type, y = n)) +
  geom_col(fill = culori_piete["India"]) +
  geom_text(aes(label = scales::comma(n)), hjust = -0.1, size = 3.5) +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15)), labels = scales::comma) +
  labs(title = "Top 5 tipuri de caroserie - India",
       subtitle = "Dominanta Hatchback confirma teoria frugal innovation",
       x = NULL, y = "Numar masini") +
  tema + theme(panel.grid.major.y = element_blank())
print(p3)

# ============================================================
# GRAFIC 4: Boxplot - Pret pe tip caroserie (top 5)
# Combina volumul (graf 3) cu pretul: Hatchback ieftin, SUV scump
# ============================================================
top_body <- df %>%
  filter(!is.na(body_type), body_type != "") %>%
  count(body_type, sort = TRUE) %>%
  slice_max(n, n = 5) %>%
  pull(body_type)

limita_99 <- quantile(df$price_in_euro, 0.99, na.rm = TRUE)
marcaje_pret <- pretty(c(0, limita_99), n = 8)
marcaje_pret <- c(marcaje_pret[marcaje_pret < limita_99 * 0.95], limita_99)

p4 <- df %>%
  filter(body_type %in% top_body) %>%
  mutate(price_plot = pmin(price_in_euro, limita_99, na.rm = TRUE),
         body_type = fct_reorder(body_type, price_plot, median)) %>%
  ggplot(aes(x = body_type, y = price_plot, fill = body_type)) +
  geom_boxplot(outlier.alpha = 0.2) +
  scale_fill_brewer(palette = "Set2", guide = "none") +
  scale_y_continuous(
    breaks = marcaje_pret,
    labels = function(y) ifelse(y == limita_99,
                                paste0(">", scales::comma(round(y))),
                                scales::comma(round(y)))
  ) +
  labs(title = "Pret median pe tip caroserie (top 5) - India",
       subtitle = "Hatchback = accesibil; SUV = top de gama",
       x = NULL, y = "Pret (EUR)") +
  tema
print(p4)

# ============================================================
# GRAFIC 5: Scatter - Curba de depreciere (Pret vs Varsta) - India
# TEORIE: Storchmann (2004) - depreciere mai lenta in piete emergente (~15% anual)
# ============================================================
limita_99_p <- quantile(df$price_in_euro, 0.99, na.rm = TRUE)
marcaje_yp <- pretty(c(0, limita_99_p), n = 8)
marcaje_yp <- c(marcaje_yp[marcaje_yp < limita_99_p * 0.95], limita_99_p)

p5 <- df %>%
  mutate(age_plot = pmin(age, limita_99_age, na.rm = TRUE),
         price_plot = pmin(price_in_euro, limita_99_p, na.rm = TRUE)) %>%
  ggplot(aes(x = age_plot, y = price_plot)) +
  geom_point(alpha = 0.15, color = culori_piete["India"], size = 0.8) +
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
  labs(title = "Curba de depreciere (Pret vs Varsta) - India",
       subtitle = "Linia GAM = trend median; depreciere mai lenta in piata emergenta (Storchmann, 2004)",
       x = "Varsta (ani)", y = "Pret (EUR)") +
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
  scale_y_continuous(expand = expansion(mult = c(0, 0.15)), labels = scales::comma) +
  labs(title = "Top 10 cele mai tranzactionate branduri - India",
       subtitle = "Maruti Suzuki domina piata, confirmand 'The Maruti Story'",
       x = NULL, y = "Numar masini") +
  tema + theme(panel.grid.major.y = element_blank())
print(p6)

# ============================================================
# GRAFIC 7: Boxplot - Pret vs Tipul vanzatorului (seller_type)
# seller_type (Dealer / Individual) e folosit ca factor de modelul RF India.
# Aceeasi logica ca one_owner la SUA: aratam ca am valorificat fiecare coloana.
# ============================================================
limita_99 <- quantile(df$price_in_euro, 0.99, na.rm = TRUE)
marcaje_pret <- pretty(c(0, limita_99), n = 8)
marcaje_pret <- c(marcaje_pret[marcaje_pret < limita_99 * 0.95], limita_99)

p7 <- df %>%
  filter(!is.na(seller_type), seller_type != "") %>%
  mutate(price_plot = pmin(price_in_euro, limita_99, na.rm = TRUE),
         seller_type = fct_reorder(seller_type, price_plot, median)) %>%
  ggplot(aes(x = seller_type, y = price_plot, fill = seller_type)) +
  geom_boxplot(outlier.alpha = 0.1) +
  scale_fill_brewer(palette = "Set2", guide = "none") +
  scale_y_continuous(
    breaks = marcaje_pret,
    labels = function(y) ifelse(y == limita_99,
                                paste0(">", scales::comma(round(y))),
                                scales::comma(round(y)))
  ) +
  labs(title = "Pret vs tipul vanzatorului - India",
       subtitle = "Dealerii au pret median mai mare decat vanzatorii privati (folosit de modelul RF)",
       x = NULL, y = "Pret (EUR)") +
  tema
print(p7)

cat("\n=== INDIA - 7 grafice in Plots pane ===\n")
