# ============================================================
# HELPERS COMUNI PENTRU CELE 4 SCRIPTURI DE GRAFICE
# ============================================================
# Pachete: doar tidyverse (analiza/grafice) + DBI/RSQLite (citire DB)
# Sursa in fiecare script:
#   source("Utile/Grafice_Helpers.R")
# ============================================================

library(tidyverse)
library(DBI)
library(RSQLite)

# ---- Paleta academica (mute, profesionala, color-blind friendly) ----
# Aceleasi culori folosite peste tot (per-piata + comparativ)
culori_piete <- c("Germania" = "#1F3A5F",   # Deep navy slate
                  "SUA"      = "#7B2D26",   # Deep burgundy
                  "India"    = "#1F6650")   # Deep forest teal

# ---- Limite IQR pentru detectie outliere (1.5 x IQR) ----
# Returneaza lista cu limita jos si sus pentru un vector x
lim_iqr <- function(x) {
  q <- quantile(x, c(0.25, 0.75), na.rm = TRUE)
  iqr <- q[2] - q[1]
  list(jos = q[1] - 1.5 * iqr, sus = q[2] + 1.5 * iqr)
}

# ---- Incarca o piata din SQLite + aplica filtrele standard ----
# tabel: numele tabelei SQLite (ex: "India_Cars_Cleaned")
# ps:    "obligatoriu" (Germania) - filtru strict pe power_ps
#        "optional"    (India)    - power_ps poate fi NA/0
#        "fara"        (SUA)      - nu exista power_ps
incarca_piata <- function(tabel, ps = "fara") {
  con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
  df <- dbReadTable(con, tabel)
  dbDisconnect(con)

  lp <- lim_iqr(df$price_in_euro)
  lk <- lim_iqr(df$km)

  df <- df %>%
    filter(price_in_euro >= lp$jos,
           km >= lk$jos, km <= lk$sus,
           year <= 2023)

  if (ps == "obligatoriu") {
    lps <- lim_iqr(df$power_ps)
    df <- df %>% filter(power_ps >= lps$jos, power_ps <= lps$sus)
  } else if (ps == "optional") {
    ps_v <- df$power_ps[df$power_ps > 0 & !is.na(df$power_ps)]
    lps <- lim_iqr(ps_v)
    df <- df %>% filter(is.na(power_ps) | power_ps <= 0 |
                          (power_ps >= lps$jos & power_ps <= lps$sus))
  }

  df %>% mutate(varsta = 2023 - year)
}

# ---- Tema standard pentru toate graficele ----
tema <- theme_minimal(base_size = 12)
