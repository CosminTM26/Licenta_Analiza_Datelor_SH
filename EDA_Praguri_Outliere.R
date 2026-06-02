# ============================================================
# CALCUL PRAGURI PERCENTILE PENTRU ELIMINARE OUTLIERI
# Sursa: tabele *_Cars_Cleaned din identifier.sqlite
#
# Strategie:
#   Doar P99.9   → km, engine_type, power_ps
#   P0.1 + P99.9  → price_in_euro, fuel_consumption_l_100km, co2_g
# ============================================================

library(tidyverse)
library(DBI)
library(RSQLite)

# ============================================================
# PASUL 1: INCARCARE DATE
# ============================================================

con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
germany_data <- dbReadTable(con, "Germany_Cars_Cleaned")
india_data <- dbReadTable(con, "India_Cars_Cleaned")
sua_data <- dbReadTable(con, "SUA_Cars_Cleaned")
dbDisconnect(con)

# ============================================================
# PASUL 2: PRAGURI GERMANIA
# ============================================================

print("=== GERMANIA ===")

print("-- Coada superioara (doar P99.9) --")
germany_data %>%
  summarise(
    km_p99_9 = quantile(km, 0.999, na.rm = TRUE),
    km_peste_p99_9 = sum(km > quantile(km, 0.999, na.rm = TRUE),
                         na.rm = TRUE),
    engine_p99_9 = round(quantile(engine_type, 0.999, na.rm = TRUE), 2),
    engine_peste_p99_9 = sum(engine_type >
                               quantile(engine_type, 0.999, na.rm = TRUE),
                             na.rm = TRUE),
    power_p99_9 = quantile(power_ps, 0.999, na.rm = TRUE),
    power_peste_p99_9 = sum(power_ps >
                              quantile(power_ps, 0.999, na.rm = TRUE),
                            na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Indicator_Statistic",
    values_to = "Valoare"
  ) %>%
  print()

print("-- Ambele capete (P0.1 si P99.9) --")
germany_data %>%
  summarise(
    price_p0_1 = quantile(price_in_euro, 0.001, na.rm = TRUE),
    price_sub_p0_1 = sum(price_in_euro <
                           quantile(price_in_euro, 0.001, na.rm = TRUE),
                         na.rm = TRUE),
    price_p99_9 = quantile(price_in_euro, 0.999, na.rm = TRUE),
    price_peste_p99_9 = sum(price_in_euro >
                              quantile(price_in_euro, 0.999, na.rm = TRUE),
                            na.rm = TRUE),
    consum_p0_1 = round(
      quantile(fuel_consumption_l_100km, 0.001, na.rm = TRUE), 1),
    consum_sub_p0_1 = sum(fuel_consumption_l_100km <
                            quantile(fuel_consumption_l_100km, 0.001, na.rm = TRUE),
                          na.rm = TRUE),
    consum_p99_9 = round(
      quantile(fuel_consumption_l_100km, 0.999, na.rm = TRUE), 1),
    consum_peste_p99_9 = sum(fuel_consumption_l_100km >
                               quantile(fuel_consumption_l_100km, 0.999, na.rm = TRUE),
                             na.rm = TRUE),
    co2_p0_1 = quantile(co2_g, 0.001, na.rm = TRUE),
    co2_sub_p0_1 = sum(co2_g < quantile(co2_g, 0.001, na.rm = TRUE),
                       na.rm = TRUE),
    co2_p99_9 = quantile(co2_g, 0.999, na.rm = TRUE),
    co2_peste_p99_9 = sum(co2_g > quantile(co2_g, 0.999, na.rm = TRUE),
                          na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Indicator_Statistic",
    values_to = "Valoare"
  ) %>%
  print()

# ============================================================
# PASUL 3: PRAGURI SUA
# ============================================================

print("=== SUA ===")

print("-- Coada superioara (doar P99.9) --")
sua_data %>%
  summarise(
    km_p99_9 = quantile(km, 0.999, na.rm = TRUE),
    km_peste_p99_9 = sum(km > quantile(km, 0.999, na.rm = TRUE),
                         na.rm = TRUE),
    engine_p99_9 = round(quantile(engine_type, 0.999, na.rm = TRUE), 2),
    engine_peste_p99_9 = sum(engine_type >
                               quantile(engine_type, 0.999, na.rm = TRUE),
                             na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Indicator_Statistic",
    values_to = "Valoare"
  ) %>%
  print()

print("-- Ambele capete (P0.1 si P99.9) --")
sua_data %>%
  summarise(
    price_p0_1 = quantile(price_in_euro, 0.001, na.rm = TRUE),
    price_sub_p0_1 = sum(price_in_euro <
                           quantile(price_in_euro, 0.001, na.rm = TRUE),
                         na.rm = TRUE),
    price_p99_9 = quantile(price_in_euro, 0.999, na.rm = TRUE),
    price_peste_p99_9 = sum(price_in_euro >
                              quantile(price_in_euro, 0.999, na.rm = TRUE),
                            na.rm = TRUE),
    consum_p0_1 = round(
      quantile(fuel_consumption_l_100km, 0.001, na.rm = TRUE), 1),
    consum_sub_p0_1 = sum(fuel_consumption_l_100km <
                            quantile(fuel_consumption_l_100km, 0.001, na.rm = TRUE),
                          na.rm = TRUE),
    consum_p99_9 = round(
      quantile(fuel_consumption_l_100km, 0.999, na.rm = TRUE), 1),
    consum_peste_p99_9 = sum(fuel_consumption_l_100km >
                               quantile(fuel_consumption_l_100km, 0.999, na.rm = TRUE),
                             na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Indicator_Statistic",
    values_to = "Valoare"
  ) %>%
  print()

# ============================================================
# PASUL 4: PRAGURI INDIA
# ============================================================

print("=== INDIA ===")

print("-- Coada superioara (doar P99.9) --")
india_data %>%
  summarise(
    km_p99_9 = quantile(km, 0.999, na.rm = TRUE),
    km_peste_p99_9 = sum(km > quantile(km, 0.999, na.rm = TRUE),
                         na.rm = TRUE),
    engine_p99_9 = round(quantile(engine_type, 0.999, na.rm = TRUE), 2),
    engine_peste_p99_9 = sum(engine_type >
                               quantile(engine_type, 0.999, na.rm = TRUE),
                             na.rm = TRUE),
    power_p99_9 = quantile(power_ps, 0.999, na.rm = TRUE),
    power_peste_p99_9 = sum(power_ps >
                              quantile(power_ps, 0.999, na.rm = TRUE),
                            na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Indicator_Statistic",
    values_to = "Valoare"
  ) %>%
  print()

print("-- Ambele capete (P0.1 si P99.9) --")
india_data %>%
  summarise(
    price_p0_1 = quantile(price_in_euro, 0.001, na.rm = TRUE),
    price_sub_p0_1 = sum(price_in_euro <
                           quantile(price_in_euro, 0.001, na.rm = TRUE),
                         na.rm = TRUE),
    price_p99_9 = quantile(price_in_euro, 0.999, na.rm = TRUE),
    price_peste_p99_9 = sum(price_in_euro >
                              quantile(price_in_euro, 0.999, na.rm = TRUE),
                            na.rm = TRUE),
    consum_p0_1 = round(
      quantile(fuel_consumption_l_100km, 0.001, na.rm = TRUE), 1),
    consum_sub_p0_1 = sum(fuel_consumption_l_100km <
                            quantile(fuel_consumption_l_100km, 0.001, na.rm = TRUE),
                          na.rm = TRUE),
    consum_p99_9 = round(
      quantile(fuel_consumption_l_100km, 0.999, na.rm = TRUE), 1),
    consum_peste_p99_9 = sum(fuel_consumption_l_100km >
                               quantile(fuel_consumption_l_100km, 0.999, na.rm = TRUE),
                             na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Indicator_Statistic",
    values_to = "Valoare"
  ) %>%
  print()
