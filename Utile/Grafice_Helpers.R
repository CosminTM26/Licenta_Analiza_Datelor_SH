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

# ---- Paleta inspirata din steagurile nationale ----
# Aceleasi culori folosite peste tot (per-piata + comparativ)
culori_piete <- c("Germania" = "#DD0000",   # Rosu din steagul Germaniei
                  "SUA" = "#0A3161",   # Albastru din steagul SUA (Old Glory Blue)
                  "India" = "#046A38")   # Verde din steagul Indiei

# ---- Incarca o piata din SQLite ----
# SQL a facut deja TOATA curatarea: imputare, deduplicare, taiere outlieri
# si eliminare ani > 2023. Aici doar citim tabelul curat, fara alte filtrari.
incarca_piata <- function(tabel) {
  con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
  df <- dbReadTable(con, tabel)
  dbDisconnect(con)
  df
}

options(scipen = 999, digits = 3)

# ---- Tema standard pentru toate graficele ----
# Titlul e centrat; graficele nu folosesc subtitluri (explicatiile sunt in lucrare)
tema <- theme_minimal(base_size = 12) +
  theme(plot.title = element_text(hjust = 0.5))

salveaza_grafic <- function(nume_fisier, plot_obiect = last_plot(), latime = 16.5, inaltime = 8.25) {
  # Note:
  # - plot_obiect foloseste 'last_plot()' ca default (salveaza ultimul grafic afisat)
  # - latime si inaltime sunt calibrate fix pe marginile paginii tale de Word

  ggsave(
    filename = nume_fisier,
    plot = plot_obiect,
    width = latime,
    height = inaltime,
    units = "cm",
    dpi = 330
  )
}