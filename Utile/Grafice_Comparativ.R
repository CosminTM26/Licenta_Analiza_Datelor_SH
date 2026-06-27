# ============================================================
# GRAFICE COMPARATIVE - ANALIZA 3 PIETE (Germania / SUA / India)
# ============================================================
# Teorie: Storchmann (2004) - depreciere ~31% piete mature vs ~15% emergente;
#         structura corelatiilor si a pietei (combustibil, transmisie) difera geografic
#
# Rulare: source("Utile/Grafice_Comparativ.R")
# Output: 7 grafice in Plots pane (RStudio):
#   1 depreciere (Pret vs Varsta, Y log) | 2 heatmap corelatii | 3 boxplot log preturi |
#   4 feature importance (ML) | 5 actual vs predicted (ML) | 6 transmisii | 7 combustibil
# ============================================================

source("Utile/Grafice_Helpers.R")

# Nivele - ordinea standard pentru afisare in facet-uri
nivele <- c("Germania", "SUA", "India")

# ---- Incarcare 3 piete (filtrarea anilor > 2023 e facuta in incarca_piata) ----
ger <- incarca_piata("Germany_Cars_Cleaned")
sua <- incarca_piata("SUA_Cars_Cleaned")
ind <- incarca_piata("India_Cars_Cleaned")

cat("Randuri din DB:  Germania:", nrow(ger),
    "| SUA:", nrow(sua), "| India:", nrow(ind), "\n\n")

# ============================================================
# GRAFIC 1: Curbe depreciere (facet 3 piete)
# TEORIE: Storchmann - pante mai abrupte = depreciere mai rapida
#   Germania/SUA = panta ABRUPTA; India = mai APLATIZATA
# ============================================================
# Capam preturile per piata la 99% (axa Y pe scara logaritmica). Axa X = VECHIMEA
# (varsta), comuna 0-23 ani pe toate 3 pietele (comparatie corecta); masinile peste
# 23 ani sunt grupate in ultima coloana, etichetata ">23".
VARSTA_MAX <- 23

date_3piete <- bind_rows(
  ger %>% mutate(piata = "Germania"),
  sua %>% mutate(piata = "SUA"),
  ind %>% mutate(piata = "India")
) %>%
  select(piata, price_in_euro, year) %>%
  group_by(piata) %>%
  mutate(price_plot = pmin(price_in_euro, quantile(price_in_euro, 0.99, na.rm = TRUE), na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(age = 2023 - year,
         age_plot = pmin(age, VARSTA_MAX),
         piata = factor(piata, levels = nivele))

# Afisam un esantion de 8000 masini/piata (altfel SUA cu 750k aglomereaza tot);
# linia de trend (GAM) foloseste TOATE datele, deci ramane exacta.
set.seed(42)
esantion <- date_3piete %>%
  group_by(piata) %>%
  slice_sample(n = 8000) %>%
  ungroup()

# Helper local pentru a asigura exact 5 breaks logaritmice pe fiecare piata
get_breaks_log <- function(lim) {
  if (lim[1] > 1500) {
    # SUA: limite ~ 2300 la 118000
    return(c(3000, 6000, 15000, 35000, 80000))
  } else if (lim[2] > 90000) {
    # Germania: limite ~ 570 la 180000
    return(c(1000, 3000, 10000, 30000, 100000))
  } else {
    # India: limite ~ 480 la 63000
    return(c(600, 1500, 4000, 10000, 30000))
  }
}

p1 <- date_3piete %>%
  ggplot(aes(x = age_plot, y = price_plot, color = piata)) +
  geom_jitter(data = esantion, width = 0.35, height = 0, alpha = 0.15, size = 0.5) +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"), se = TRUE,
              linewidth = 1, color = "black") +
  facet_wrap(~piata, scales = "free_y") +   # ACELASI X pe toate; doar Y difera (preturi)
  scale_y_log10(labels = scales::comma, breaks = get_breaks_log) +
  scale_x_continuous(breaks = c(0, 5, 10, 15, 20, VARSTA_MAX),
                     labels = c("0", "5", "10", "15", "20", ">23")) +
  scale_color_manual(values = culori_piete, guide = "none") +
  labs(title = "Evolutia preturilor in functie de vechimea masinii - 3 piete",
       x = "Vechime (ani)", y = "Pret (EUR, scara logaritmica)") +
  tema +
  theme(strip.text = element_text(face = "bold", size = 13))
print(p1)
salveaza_grafic('comparativ_p1.png')

# ============================================================
# GRAFIC 2: Heatmap corelatii (facet 3 piete)
# TEORIE: structura corelatiilor difera per piata. Fiecare matrice include EXACT
#   variabilele modelului ML local (de aceea difera ca dimensiune intre piete)
# ============================================================

# Helper local: calculeaza corelatiile pentru o piata
calc_cor <- function(df, piata) {
  df_mod <- df %>%
    mutate(age = 2023 - year)

  if ("one_owner" %in% names(df_mod)) {
    df_mod <- df_mod %>%
      mutate(one_owner = if_else(one_owner == "Yes", 1, 0))
  }

  if (piata == "Germania") {
    vars <- c("price_in_euro", "age", "km", "engine_type", "fuel_consumption_l_100km", "co2_g", "power_ps")
  } else if (piata == "India") {
    vars <- c("price_in_euro", "age", "km", "engine_type", "fuel_consumption_l_100km", "power_ps", "one_owner")
  } else if (piata == "SUA") {
    vars <- c("price_in_euro", "age", "km", "engine_type", "fuel_consumption_l_100km", "one_owner")
  } else {
    vars <- c("price_in_euro", "age", "km", "engine_type", "fuel_consumption_l_100km")
  }

  df_mod %>%
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
         "age" = "Varsta",
         "engine_type" = "Cilind.",
         "fuel_consumption_l_100km" = "Consum",
         "co2_g" = "CO2",
         "power_ps" = "Putere",
         "one_owner" = "Un prop."
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
  geom_text(aes(label = scales::number(cor, accuracy = 0.01)), size = 2.0) +
  scale_fill_gradient2(low = "#2166AC", mid = "white", high = "#B2182B",
                       midpoint = 0, limits = c(-1, 1)) +
  facet_wrap(~piata, scales = "free") +
  labs(title = "Matricea de corelatie - 3 piete",
       x = NULL, y = NULL, fill = "Cor.") +
  tema +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
        axis.text.y = element_text(size = 8),
        strip.text = element_text(face = "bold", size = 13),
        panel.grid = element_blank(),
        plot.margin = margin(5, 10, 5, 10))
print(p2)
salveaza_grafic('comparativ_p2.svg', latime = 22, inaltime = 12)

# ============================================================
# GRAFIC 3: Boxplot comparativ pe scara logaritmica (3 piete)
# TEORIE: diferenta de putere de cumparare Vest vs Asia
#   Scara logaritmica comprima preturile mari, asa ca vedem clar
#   medianele si decalajul colosal dintre SUA/Germania si India
# ============================================================
date_combinate <- bind_rows(
  ger %>%
    select(price_in_euro) %>%
    mutate(piata = "Germania"),
  sua %>%
    select(price_in_euro) %>%
    mutate(piata = "SUA"),
  ind %>%
    select(price_in_euro) %>%
    mutate(piata = "India")
) %>% mutate(piata = factor(piata, levels = nivele))

# Mediana pe fiecare piata (o afisam ca eticheta pe cutie)
mediane <- date_combinate %>%
  group_by(piata) %>%
  summarise(pret_median = median(price_in_euro, na.rm = TRUE))

p3 <- date_combinate %>%
  ggplot(aes(x = piata, y = price_in_euro)) +
  geom_boxplot(aes(fill = piata), alpha = 0.75, width = 0.6,
               outlier.alpha = 0.05, outlier.size = 0.5) +
  geom_label(data = mediane,
             aes(x = piata, y = pret_median,
                 label = paste0(scales::comma(round(pret_median)), " EUR")),
             fill = "white", color = "black", fontface = "bold", size = 3.5) +
  scale_y_log10(breaks = c(1000, 3000, 10000, 30000, 100000, 300000),
                labels = scales::comma) +
  scale_fill_manual(values = culori_piete, guide = "none") +
  labs(title = "Distributia preturilor pe scara logaritmica - 3 piete",
       x = NULL, y = "Pret (EUR, scara logaritmica)") +
  tema
print(p3)
salveaza_grafic('comparativ_p3.png')

# ============================================================
# ML COMPARATIV: Feature Importance si Actual vs Predicted
# ============================================================
library(ranger)

nume_prietenos_ml <- c(
  km = "Kilometraj", age = "Varsta", power_ps = "Putere (CP)",
  engine_type = "Capacitate", fuel_consumption_l_100km = "Consum",
  co2_g = "Emisii CO2", brand = "Brand", model = "Model",
  fuel_type = "Combustibil", transmission_type = "Transmisie",
  body_type = "Caroserie", drivetrain = "Tractiune",
  one_owner = "Un proprietar", seller_type = "Tip vanzator"
)

# Helper pentru antrenare si predictie ML
# nr_arbori = acelasi numar de arbori ca in app.R (300 Germania / 500 India / 200 SUA)
proceseaza_piata_ml <- function(date, nume_piata, coloane_selectate, coloane_factor, nr_arbori) {
  cat("Antrenare model Machine Learning pentru:", nume_piata, "...\n")

  coloane_electric <- intersect(c("engine_type", "fuel_consumption_l_100km", "co2_g"), names(date))

  df_clean <- date %>%
    mutate(age = 2023 - year) %>%
    select(all_of(c("price_in_euro", "age", setdiff(coloane_selectate, c("price_in_euro", "year"))))) %>%
    mutate(across(all_of(coloane_electric), ~if_else(fuel_type == "Electric" & is.na(.), 0, .))) %>%
    filter(!is.na(price_in_euro), price_in_euro > 0) %>%
    drop_na() %>%
    mutate(across(all_of(coloane_factor), as.factor))

  # Antrenare Random Forest pe log(pret) pe TOT setul, exact ca in app.R
  # (arbori per piata). Evaluarea foloseste eroarea out-of-bag (datele lasate
  # in afara fiecarui arbore la antrenare), deci nu mai e nevoie de o impartire
  # separata in antrenare si testare.
  model_rf <- ranger(log(price_in_euro) ~ ., data = df_clean,
                     num.trees = nr_arbori, max.depth = 20, min.node.size = 2,
                     importance = "impurity", respect.unordered.factors = "order",
                     seed = 42, num.threads = 10)

  # 1. Extragere importanta variabile (din modelul pe tot setul)
  imp <- importance(model_rf)
  df_imp <- tibble(variabila = names(imp), importanta = as.numeric(imp)) %>%
    mutate(procent = round(100 * importanta / sum(importanta), 1),
           piata = nume_piata)

  # 2. Predictii out-of-bag (pe datele nevazute de fiecare arbore), aduse in euro
  pred_price <- exp(model_rf$predictions)

  df_pred <- tibble(
    actual = df_clean$price_in_euro,
    predicted = pred_price,
    piata = nume_piata
  )

  # 3. Metrici out-of-bag (cifrele pentru Tabelul 4.1 din Capitolul 4).
  # R2 OOB pe log = valoarea afisata si de aplicatie; RMSE/MAE in euro
  rmse <- sqrt(mean((df_pred$actual - df_pred$predicted)^2))
  mae <- mean(abs(df_pred$actual - df_pred$predicted))
  cat("  ", nume_piata, "- R2 OOB (log):", round(model_rf$r.squared, 3),
      "| RMSE:", round(rmse), "EUR | MAE:", round(mae), "EUR\n")

  # Esantionare predictii pentru plot (max 5000 puncte pentru claritate)
  set.seed(42)
  df_pred_sample <- df_pred %>% slice_sample(n = min(5000, nrow(df_pred)))

  list(importanta = df_imp, predictii = df_pred_sample)
}

# Rulam pentru cele 3 piete
res_ger <- proceseaza_piata_ml(ger, "Germania",
                               c("price_in_euro", "km", "year", "power_ps", "engine_type", "brand", "model", "fuel_type", "transmission_type", "co2_g", "fuel_consumption_l_100km"),
                               c("brand", "model", "fuel_type", "transmission_type"),
                               nr_arbori = 300)

res_ind <- proceseaza_piata_ml(ind, "India",
                               c("price_in_euro", "km", "year", "power_ps", "engine_type", "brand", "model", "fuel_type", "transmission_type", "body_type", "fuel_consumption_l_100km", "one_owner", "drivetrain", "seller_type"),
                               c("brand", "model", "fuel_type", "transmission_type", "body_type", "one_owner", "drivetrain", "seller_type"),
                               nr_arbori = 500)

sua_clean_ml <- sua %>% filter(one_owner %in% c("Yes", "No"))
res_sua <- proceseaza_piata_ml(sua_clean_ml, "SUA",
                               c("price_in_euro", "km", "year", "engine_type", "brand", "model", "fuel_type", "transmission_type", "drivetrain", "one_owner", "fuel_consumption_l_100km"),
                               c("brand", "model", "fuel_type", "transmission_type", "drivetrain", "one_owner"),
                               nr_arbori = 200)

# Combinam rezultatele pentru plotare
imp_all <- bind_rows(res_ger$importanta, res_sua$importanta, res_ind$importanta) %>%
  mutate(piata = factor(piata, levels = nivele),
         eticheta = unname(nume_prietenos_ml[variabila]),
         eticheta_ord = reorder(paste0(eticheta, "___", piata), procent))

pred_all <- bind_rows(res_ger$predictii, res_sua$predictii, res_ind$predictii) %>%
  mutate(piata = factor(piata, levels = nivele))

# ============================================================
# GRAFIC 4: Feature Importance (facet 3 piete)
# ============================================================
p4 <- imp_all %>%
  ggplot(aes(x = procent, y = eticheta_ord, fill = piata)) +
  geom_col() +
  geom_text(aes(label = paste0(procent, "%")), hjust = -0.1, size = 3) +
  facet_wrap(~piata, scales = "free_y", ncol = 3) +
  scale_y_discrete(labels = function(x) sub("___.*", "", x)) +
  scale_x_continuous(expand = expansion(mult = c(0, 0.40))) +
  scale_fill_manual(values = culori_piete, guide = "none") +
  labs(title = "Importanta variabilelor in stabilirea pretului - Random Forest",
       x = "Importanta (% din total)", y = NULL) +
  tema +
  theme(panel.grid.major.y = element_blank(),
        strip.text = element_text(face = "bold", size = 13),
        plot.margin = margin(5, 15, 5, 15))
print(p4)
salveaza_grafic('comparativ_p4.svg', latime = 22, inaltime = 10)

# ============================================================
# GRAFIC 5: Actual vs Predicted (facet 3 piete)
# ============================================================
p5 <- pred_all %>%
  ggplot(aes(x = actual, y = predicted, color = piata)) +
  geom_point(alpha = 0.2, size = 0.6) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed", linewidth = 0.8) +
  facet_wrap(~piata, scales = "free", ncol = 3) +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = culori_piete, guide = "none") +
  labs(title = "Performanta predictiei ML: Pret Real vs Pret Prezist - 3 piete",
       x = "Pret Real (EUR)", y = "Pret Prezist (EUR)") +
  tema +
  theme(strip.text = element_text(face = "bold", size = 13),
        axis.text.x = element_text(angle = 30, hjust = 1))
print(p5)
salveaza_grafic('comparativ_p5.png')   # scatter ~15k puncte: PNG, nu SVG

# ============================================================
# GRAFIC 6: Structura transmisiilor (cota de piata %) - 3 piete
# ============================================================
date_trans <- bind_rows(
  ger %>%
    select(transmission_type) %>%
    mutate(piata = "Germania"),
  sua %>%
    select(transmission_type) %>%
    mutate(piata = "SUA"),
  ind %>%
    select(transmission_type) %>%
    mutate(piata = "India")
) %>%
  filter(transmission_type %in% c("Automatic", "Manual", "Semi-automatic")) %>%
  group_by(piata, transmission_type) %>%
  summarise(n = n(), .groups = "drop_last") %>%
  mutate(procent = n / sum(n)) %>%
  ungroup() %>%
  mutate(piata = factor(piata, levels = nivele),
         transmission_type = factor(transmission_type, levels = c("Manual", "Automatic", "Semi-automatic")))

p6 <- date_trans %>%
  ggplot(aes(x = piata, y = procent, fill = transmission_type)) +
  geom_col(width = 0.55, color = "white", linewidth = 0.3) +
  geom_text(aes(label = ifelse(procent > 0.05, paste0(round(procent * 100), "%"), "")),
            position = position_stack(vjust = 0.5), color = "white", fontface = "bold", size = 3.5) +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_fill_manual(values = c("Manual" = "#4393C3", "Automatic" = "#D6604D", "Semi-automatic" = "#969696")) +
  labs(title = "Structura pietei auto dupa tipul de transmisie - 3 piete",
       x = NULL, y = "Proportie (%)", fill = "Transmisie") +
  tema +
  theme(panel.grid.major.x = element_blank())
print(p6)
salveaza_grafic('comparativ_p6.svg')

# ============================================================
# GRAFIC 7: Structura combustibilului (cota de piata %) - 3 piete
# Combustibilii rari (LPG, CNG, Hidrogen etc.) sunt grupati in "Altele".
# Acelasi stil ca GRAFIC 6 (transmisii).
# ============================================================
date_fuel <- bind_rows(
  ger %>%
    select(fuel_type) %>%
    mutate(piata = "Germania"),
  sua %>%
    select(fuel_type) %>%
    mutate(piata = "SUA"),
  ind %>%
    select(fuel_type) %>%
    mutate(piata = "India")
) %>%
  mutate(fuel_type = if_else(fuel_type %in% c("Petrol", "Diesel", "Hybrid", "Electric"),
                             fuel_type, "Altele")) %>%
  group_by(piata, fuel_type) %>%
  summarise(n = n(), .groups = "drop_last") %>%
  mutate(procent = n / sum(n)) %>%
  ungroup() %>%
  mutate(piata = factor(piata, levels = nivele),
         fuel_type = factor(fuel_type, levels = c("Petrol", "Diesel", "Hybrid", "Electric", "Altele")))

p7 <- date_fuel %>%
  ggplot(aes(x = piata, y = procent, fill = fuel_type)) +
  geom_col(width = 0.55, color = "white", linewidth = 0.3) +
  geom_text(aes(label = ifelse(procent > 0.05, paste0(round(procent * 100), "%"), "")),
            position = position_stack(vjust = 0.5), color = "white", fontface = "bold", size = 3.5) +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_fill_manual(values = c("Petrol" = "#4393C3", "Diesel" = "#D6604D",
                               "Hybrid" = "#5AAE61", "Electric" = "#9970AB", "Altele" = "#969696")) +
  labs(title = "Structura pietei auto dupa tipul de combustibil - 3 piete",
       x = NULL, y = "Proportie (%)", fill = "Combustibil") +
  tema +
  theme(panel.grid.major.x = element_blank())
print(p7)
salveaza_grafic('comparativ_p7.svg')
