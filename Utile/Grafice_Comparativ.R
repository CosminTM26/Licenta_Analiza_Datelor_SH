# ============================================================
# GRAFICE COMPARATIVE - ANALIZA 3 PIETE (Germania / SUA / India)
# ============================================================
# Teorie: Storchmann (2004) - depreciere ~31% piete mature vs
#         ~15% emergente; structura corelatii difera geografic
#
# Rulare: source("Utile/Grafice_Comparativ.R")
# Output: 3 grafice afisate in Plots pane (RStudio)
# ============================================================

source("Utile/Grafice_Helpers.R")

# Nivele - ordinea standard pentru afisare in facet-uri
nivele <- c("Germania", "SUA", "India")

# ---- Incarcare 3 piete (date EXACT din baza de date) ----
ger <- incarca_piata("Germany_Cars_Cleaned") %>% filter(year <= 2023)
sua <- incarca_piata("SUA_Cars_Cleaned") %>% filter(year <= 2023)
ind <- incarca_piata("India_Cars_Cleaned") %>% filter(year <= 2023)

cat("Randuri din DB:  Germania:", nrow(ger),
    "| SUA:", nrow(sua), "| India:", nrow(ind), "\n\n")

# ============================================================
# GRAFIC 1: Curbe depreciere (facet 3 piete)
# TEORIE: Storchmann - pante mai abrupte = depreciere mai rapida
#   Germania/SUA = panta ABRUPTA; India = mai APLATIZATA
# ============================================================
# Capam preturile per piata cu percentila 99% (fara log10 - axe naturale)
# Helper-e locale pentru axa X dinamica (cu pragul de 1% ca prima eticheta)
get_breaks_comp <- function(limits) {
  if (any(is.na(limits))) {
    return(seq(2000, 2023, by = 5))
  }
  lim_min <- round(limits[1])
  lim_max <- 2023
  if (is.na(lim_min)) {
    return(seq(2000, 2023, by = 5))
  }
  brks <- pretty(c(lim_min, lim_max), n = 6)
  brks <- c(lim_min, brks[brks > lim_min + 1 & brks < lim_max], lim_max)
  unique(round(brks))
}

get_labels_comp <- function(breaks) {
  if (length(breaks) == 0 || any(is.na(breaks))) {
    return(as.character(breaks))
  }
  sapply(breaks, function(x) {
    if (is.na(x)) {
      return(NA_character_)
    } else if (x == breaks[1]) {
      paste0("<", round(x))
    } else {
      as.character(round(x))
    }
  })
}

ger_p <- ger %>% mutate(
  price_plot = pmin(price_in_euro, quantile(price_in_euro, 0.99, na.rm = TRUE), na.rm = TRUE),
  year_plot = pmax(year, quantile(year, 0.01, na.rm = TRUE), na.rm = TRUE),
  piata = "Germania"
)
sua_p <- sua %>% mutate(
  price_plot = pmin(price_in_euro, quantile(price_in_euro, 0.99, na.rm = TRUE), na.rm = TRUE),
  year_plot = pmax(year, quantile(year, 0.01, na.rm = TRUE), na.rm = TRUE),
  piata = "SUA"
)
ind_p <- ind %>% mutate(
  price_plot = pmin(price_in_euro, quantile(price_in_euro, 0.99, na.rm = TRUE), na.rm = TRUE),
  year_plot = pmax(year, quantile(year, 0.01, na.rm = TRUE), na.rm = TRUE),
  piata = "India"
)

p1 <- bind_rows(
    ger_p %>% select(year_plot, price_plot, piata),
    sua_p %>% select(year_plot, price_plot, piata),
    ind_p %>% select(year_plot, price_plot, piata)
  ) %>%
  mutate(piata = factor(piata, levels = nivele)) %>%
  ggplot(aes(x = year_plot, y = price_plot, color = piata)) +
  geom_point(alpha = 0.08, size = 0.5) +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), se = TRUE,
              linewidth = 1, color = "black") +
  facet_wrap(~ piata, scales = "free") +
  scale_y_continuous(labels = scales::comma) +
  scale_x_continuous(breaks = get_breaks_comp, labels = get_labels_comp, limits = c(NA, 2023)) +
  scale_color_manual(values = culori_piete, guide = "none") +
  labs(title = "Evolutia preturilor in functie de anul fabricatiei - 3 piete",
       subtitle = "Preturile cresc pentru modelele mai noi; cap la 99% pe pret si 1% pe an",
       x = "An fabricatie", y = "Pret (EUR)") +
  tema + theme(strip.text = element_text(face = "bold", size = 13))
print(p1)

# ============================================================
# GRAFIC 2: Heatmap corelatii (facet 3 piete)
# TEORIE: structura corelatii difera per piata
#   SUA: Pret-Cilindree rosu intens; India: Pret-Km albastru intens
# ============================================================

# Helper local: calculeaza corelatiile pentru o piata
calc_cor <- function(df, piata) {
  vars <- c("price_in_euro", "km", "year",
            "engine_type", "fuel_consumption_l_100km")
  df %>%
    select(any_of(vars)) %>%
    mutate(across(everything(), as.numeric)) %>%
    drop_na() %>%
    cor() %>%
    as_tibble(rownames = "var1") %>%
    pivot_longer(-var1, names_to = "var2", values_to = "cor") %>%
    mutate(piata = piata)
}

# Helper local: redenumire pentru afisare prietenoasa
to_friendly <- function(v) {
  recode(v,
    "price_in_euro" = "Pret",
    "km" = "Km",
    "year" = "An fabricatie",
    "engine_type" = "Cilindree",
    "fuel_consumption_l_100km" = "Consum"
  )
}

p2 <- bind_rows(
    calc_cor(ger, "Germania"),
    calc_cor(sua, "SUA"),
    calc_cor(ind, "India")
  ) %>%
  mutate(piata = factor(piata, levels = nivele),
         var1 = to_friendly(var1),
         var2 = to_friendly(var2)) %>%
  ggplot(aes(x = var1, y = var2, fill = cor)) +
  geom_tile(color = "white") +
  geom_text(aes(label = sprintf("%.2f", cor)), size = 3) +
  scale_fill_gradient2(low = "#2166AC", mid = "white", high = "#B2182B",
                       midpoint = 0, limits = c(-1, 1)) +
  facet_wrap(~ piata) +
  labs(title = "Matricea de corelatie - 3 piete",
       subtitle = "Rosu = pozitiva; Albastru = negativa; structura difera",
       x = NULL, y = NULL, fill = "Cor.") +
  tema + theme(axis.text.x = element_text(angle = 45, hjust = 1),
               strip.text = element_text(face = "bold", size = 13),
               panel.grid = element_blank())
print(p2)

# ============================================================
# GRAFIC 3: Densitatea preturilor (overlay 3 piete)
# TEORIE: forma distributiei pretului difera fundamental
#   India = pic ascutit la stanga (low-cost dominant)
#   SUA   = distributie larga (premium prezent)
#   Germania = bimodala (mainstream + premium)
# ============================================================
date_combinate <- bind_rows(
    ger %>% select(price_in_euro) %>% mutate(piata = "Germania"),
    sua %>% select(price_in_euro) %>% mutate(piata = "SUA"),
    ind %>% select(price_in_euro) %>% mutate(piata = "India")
  ) %>% mutate(piata = factor(piata, levels = nivele))

limita_99 <- quantile(date_combinate$price_in_euro, 0.99, na.rm = TRUE)
marcaje <- pretty(c(0, limita_99), n = 8)
marcaje <- c(marcaje[marcaje < limita_99 * 0.95], limita_99)

p3 <- date_combinate %>%
  mutate(price_plot = pmin(price_in_euro, limita_99, na.rm = TRUE)) %>%
  ggplot(aes(x = price_plot, fill = piata, color = piata)) +
  geom_density(alpha = 0.3, linewidth = 0.8) +
  scale_x_continuous(
    breaks = marcaje,
    labels = function(x) ifelse(x == limita_99,
                                paste0(">", scales::comma(round(x))),
                                scales::comma(round(x)))
  ) +
  scale_fill_manual(values = culori_piete) +
  scale_color_manual(values = culori_piete) +
  labs(title = "Densitatea preturilor - comparatie 3 piete",
       subtitle = "Forma distributiei reflecta nivelul economic; ultima zona = peste percentila 99%",
       x = "Pret (EUR)", y = "Densitate",
       fill = "Piata", color = "Piata") +
  tema
print(p3)

cat("\n=== COMPARATIV - 3 grafice in Plots pane ===\n")
