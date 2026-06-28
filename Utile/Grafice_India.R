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
  geom_histogram(bins = 50, fill = culori_piete["India"], color = "white") +
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
  labs(title = "Distributia preturilor - India",
       x = "Pret (EUR)", y = "Numar masini") +
  tema
print(p1)
salveaza_grafic('india_p1.svg')

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
  scale_y_continuous(expand = expansion(mult = c(0, 0.25)), labels = scales::comma) +
  labs(title = "Top 5 tipuri de caroserie - India",
       x = NULL, y = "Numar masini") +
  tema +
  theme(panel.grid.major.y = element_blank())
print(p3)
salveaza_grafic('india_p3.svg')

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
  scale_y_continuous(expand = expansion(mult = c(0, 0.25)), labels = scales::comma) +
  labs(title = "Top 10 cele mai tranzactionate branduri - India",
       x = NULL, y = "Numar masini") +
  tema +
  theme(panel.grid.major.y = element_blank())
print(p6)
salveaza_grafic('india_p6.svg')

# ============================================================
# GRAFIC 7: Pret vs tipul vanzatorului (seller_type) - test statistic
# seller_type (Dealer / Individual) e folosit ca factor de modelul RF India.
# Aceeasi abordare ca one_owner la SUA: ggbetweenstats cu test Mann-Whitney.
# ============================================================
library(ggstatsplot)

date_seller <- df %>%
  filter(!is.na(seller_type), seller_type != "") %>%
  slice_sample(n = 5000)

p7 <- ggbetweenstats(
  data = date_seller,
  x = seller_type,
  y = price_in_euro,
  type = "np",                                # Mann-Whitney (non-parametric)
  xlab = "Tipul Vanzatorului",
  ylab = "Pret (EUR)",
  title = "Pret vs tipul vanzatorului - India",
  point.args = list(alpha = 0.15, size = 1),
  ggtheme = theme_minimal()
) +
  scale_color_manual(values = c("Dealer" = "#046A38",
                                "Particular" = "#5FA37D")) +
  scale_y_continuous(labels = scales::comma) +
  scale_y_log10(labels = scales::comma) +
  theme(plot.title = element_text(hjust = 0.5))
print(p7)
salveaza_grafic('india_p7.png')
