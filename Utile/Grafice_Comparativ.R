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

# ---- Incarcare + filtrare cele 3 piete ----
ger <- incarca_piata("Germany_Cars_Cleaned", ps = "obligatoriu")
sua <- incarca_piata("SUA_Cars_Cleaned",     ps = "fara")
ind <- incarca_piata("India_Cars_Cleaned",   ps = "optional")

cat("Randuri filtrate:  Germania:", nrow(ger),
    "| SUA:", nrow(sua), "| India:", nrow(ind), "\n\n")

# ============================================================
# GRAFIC 1: Curbe depreciere (facet 3 piete)
# TEORIE: Storchmann - pante mai abrupte = depreciere mai rapida
#   Germania/SUA = panta ABRUPTA; India = mai APLATIZATA
# ============================================================
p1 <- bind_rows(
    ger %>% select(varsta, price_in_euro) %>% mutate(piata = "Germania"),
    sua %>% select(varsta, price_in_euro) %>% mutate(piata = "SUA"),
    ind %>% select(varsta, price_in_euro) %>% mutate(piata = "India")
  ) %>%
  filter(varsta >= 0, varsta <= 30) %>%
  mutate(piata = factor(piata, levels = nivele)) %>%
  ggplot(aes(x = varsta, y = price_in_euro, color = piata)) +
  geom_point(alpha = 0.08, size = 0.5) +
  geom_smooth(method = "loess", se = TRUE,
              linewidth = 1, color = "black") +
  facet_wrap(~ piata, scales = "free_y") +
  scale_y_log10(labels = scales::comma) +
  scale_color_manual(values = culori_piete, guide = "none") +
  labs(title = "Curbele de depreciere - comparatie 3 piete",
       subtitle = "Pante mai abrupte = depreciere mai rapida (Storchmann 2004)",
       x = "Varsta (ani)", y = "Pret (EUR, log10)") +
  tema + theme(strip.text = element_text(face = "bold", size = 13))
print(p1)

# ============================================================
# GRAFIC 2: Heatmap corelatii (facet 3 piete)
# TEORIE: structura corelatii difera per piata
#   SUA: Pret-Cilindree rosu intens; India: Pret-Km albastru intens
# ============================================================

# Helper local: calculeaza corelatiile pentru o piata
calc_cor <- function(df, piata) {
  vars <- c("price_in_euro", "km", "varsta",
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
    "varsta" = "Varsta",
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
p3 <- bind_rows(
    ger %>% select(price_in_euro) %>% mutate(piata = "Germania"),
    sua %>% select(price_in_euro) %>% mutate(piata = "SUA"),
    ind %>% select(price_in_euro) %>% mutate(piata = "India")
  ) %>%
  mutate(piata = factor(piata, levels = nivele)) %>%
  ggplot(aes(x = price_in_euro, fill = piata, color = piata)) +
  geom_density(alpha = 0.3, linewidth = 0.8) +
  scale_x_log10(labels = scales::comma) +
  scale_fill_manual(values = culori_piete) +
  scale_color_manual(values = culori_piete) +
  labs(title = "Densitatea preturilor - comparatie 3 piete",
       subtitle = "Scala log10; forma distributiei reflecta nivelul economic",
       x = "Pret (EUR, log10)", y = "Densitate",
       fill = "Piata", color = "Piata") +
  tema
print(p3)

cat("\n=== COMPARATIV - 3 grafice in Plots pane ===\n")
