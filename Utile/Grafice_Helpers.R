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
                  "SUA" = "#7B2D26",   # Deep burgundy
                  "India" = "#1F6650")   # Deep forest teal

# ---- Incarca o piata din SQLite ----
# SQL a facut deja TOATA curatarea: imputare, deduplicare, taiere outlieri
# si eliminare ani > 2023. Aici doar citim tabelul curat, fara alte filtrari.
incarca_piata <- function(tabel) {
  con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
  df <- dbReadTable(con, tabel)
  dbDisconnect(con)
  df
}

# ---- Tema standard pentru toate graficele ----
tema <- theme_minimal(base_size = 12)
