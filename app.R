# ==============================================================================
# Dashboard Auto SH + Predictor Pret (Random Forest)
# Licenta Cosmin
# ==============================================================================
# Structura aplicatiei:
#   PARTEA 1 (Dashboard)  - KPI-uri + grafice descriptive pe piata aleasa
#   PARTEA 2 (Predictor)  - Random Forest pentru fiecare piata (Germania/India/SUA)
#                           cu acelasi tipar de cod: campuri baza -> RF -> predictie
# ==============================================================================

library(shiny)
library(shinydashboard)
library(DBI)
library(RSQLite)
library(tidyverse)
library(ranger)

options(scipen = 999)
options(ranger.num.threads = 10)

# ==============================================================================
# HELPER COMUNI
# ==============================================================================

DB <- "identifier.sqlite"

# Formatare numere cu separator de mii (ex. 12345 -> "12,345")
fmt <- function(x) {
  if (is.na(x) || is.nan(x)) return("N/A")
  format(round(x), big.mark = ",")
}

# Mapare piata (afisaj) -> tabel SQLite (real)
tabel_piata <- function(piata) {
  switch(piata, "India" = "India_Cars_Cleaned",
         "Germania" = "Germany_Cars_Cleaned", "SUA" = "SUA_Cars_Cleaned")
}

# Citeste valori distincte dintr-o coloana (pentru selectInput-uri)
get_vals <- function(tbl, col) {
  if (!file.exists(DB)) return(character(0))
  con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))
  if (!dbExistsTable(con, tbl)) return(character(0))
  dbGetQuery(con, paste0(
    "SELECT DISTINCT `", col, "` FROM `", tbl,
    "` WHERE `", col, "` IS NOT NULL AND `", col, "` != '' ORDER BY `", col, "`"
  ))[[1]]
}

# Preincarca valorile fixe pentru selectInput-uri (la pornirea aplicatiei)
ger_brands <- get_vals("Germany_Cars_Cleaned", "brand")
ger_fuels <- get_vals("Germany_Cars_Cleaned", "fuel_type")
ger_trans <- get_vals("Germany_Cars_Cleaned", "transmission_type")
ind_brands <- get_vals("India_Cars_Cleaned", "brand")
ind_fuels <- get_vals("India_Cars_Cleaned", "fuel_type")
ind_trans <- get_vals("India_Cars_Cleaned", "transmission_type")
ind_body <- get_vals("India_Cars_Cleaned", "body_type")
ind_states <- get_vals("India_Cars_Cleaned", "state")
ind_seller <- get_vals("India_Cars_Cleaned", "seller_type")
ind_drive <- get_vals("India_Cars_Cleaned", "drivetrain")
sua_brands <- get_vals("SUA_Cars_Cleaned", "brand")
sua_fuels <- get_vals("SUA_Cars_Cleaned", "fuel_type")
sua_trans <- get_vals("SUA_Cars_Cleaned", "transmission_type")
sua_drive <- get_vals("SUA_Cars_Cleaned", "drivetrain")

# ==============================================================================
# HELPER-E UI PENTRU PREDICTOR (toate cele 3 piete au aceeasi structura)
# ==============================================================================

# Campurile de baza ale unui predictor (brand, model, km, year, fuel, transmisie)
# Sunt identice pentru toate cele 3 piete, doar valorile implicite difera
campuri_baza <- function(piata, brands, fuels, trans, year_default, km_default) {
  id <- function(s) paste0("pred_", piata, "_", s)
  tagList(
    selectInput(id("brand"), "Brand:", choices = brands),
    uiOutput(id("model_ui")),
    numericInput(id("km"), "Kilometraj (km):", value = km_default, min = 0, step = 10000),
    numericInput(id("year"), "An fabricatie:", value = year_default),
    selectInput(id("fuel"), "Combustibil:", choices = fuels),
    selectInput(id("trans"), "Transmisie:", choices = trans)
  )
}

# Camp optional numeric: checkbox "Specific X" + numericInput vizibil cand e bifat
camp_num <- function(piata, nume, label_cb, label_inp, default, min_val = 1, step = 0.1) {
  id_inp <- paste0("pred_", piata, "_", nume)
  id_cb <- paste0("pred_", piata, "_use_", nume)
  tagList(
    checkboxInput(id_cb, label_cb, value = FALSE),
    conditionalPanel(condition = paste0("input.", id_cb, " == true"),
                     numericInput(id_inp, label_inp, value = default, min = min_val, step = step))
  )
}

# Camp optional categoric: checkbox "Specific X" + selectInput vizibil cand e bifat
camp_sel <- function(piata, nume, label_cb, label_inp, choices) {
  id_inp <- paste0("pred_", piata, "_", nume)
  id_cb <- paste0("pred_", piata, "_use_", nume)
  tagList(
    checkboxInput(id_cb, label_cb, value = FALSE),
    conditionalPanel(condition = paste0("input.", id_cb, " == true"),
                     selectInput(id_inp, label_inp, choices = choices))
  )
}

# Coloana din dreapta: buton antreneaza + status + buton predictie + rezultat
coloana_actiuni <- function(piata) {
  tagList(
    actionButton(paste0("train_", piata), "Antreneaza Model",
                 icon = icon("cogs"), class = "btn-warning btn-block"),
    br(),
    verbatimTextOutput(paste0("train_", piata, "_status"), placeholder = TRUE),
    actionButton(paste0("pred_", piata, "_btn"), "Calculeaza Pret",
                 icon = icon("calculator"), class = "btn-success btn-block"),
    uiOutput(paste0("pred_", piata, "_result"))
  )
}

# ==============================================================================
# HELPER-E MACHINE LEARNING (folosite in observerele de antrenare)
# ==============================================================================

# Imputare ierarhica pentru o coloana cu NA: median brand+model -> median global -> fallback
imputare_ierarhica <- function(df, col, fallback) {
  if (!col %in% names(df)) return(df)
  # Pas 1: completeaza NA cu mediana pe grupul brand+model
  df <- df %>%
    group_by(brand, model) %>%
    mutate(across(all_of(col), ~ifelse(is.na(.), median(., na.rm = TRUE), .))) %>%
    ungroup()
  # Pas 2: ce a ramas NA -> median global, sau fallback daca nu exista
  global_med <- median(df[[col]], na.rm = TRUE)
  if (is.na(global_med)) global_med <- fallback
  df[[col]][is.na(df[[col]])] <- global_med
  df
}

# Pentru masini electrice: engine/consum/co2 = 0 (nu se aplica)
electric_zero <- function(df) {
  for (col in c("engine_type", "fuel_consumption_l_100km", "co2_g")) {
    if (col %in% names(df)) df[[col]][df$fuel_type == "Electric"] <- 0
  }
  df
}

# Antrenare Random Forest cu hyperparametri din studii (Wright & Konig 2019)
# - quantreg = TRUE: salveaza predictia fiecarui arbore -> putem cere mediana
# - respect.unordered.factors = "order": Target Encoding nativ pentru marca/model
# - max.depth + min.node.size: limita complexitatea ca sa nu supraadapteze
train_rf <- function(df, factor_cols, n_trees, model_rv, levels_rv, status_rv) {
  # Feature engineering: inlocuim "year" cu "age" (= 2023 - year, datele sunt din 2023)
  df$age <- 2023 - df$year
  df$year <- NULL

  # Pregatire date: corectie electrici + imputare valori lipsa
  df <- electric_zero(df)
  df <- imputare_ierarhica(df, "engine_type", 1.6)
  df <- imputare_ierarhica(df, "fuel_consumption_l_100km", 6.0)
  df <- imputare_ierarhica(df, "co2_g", 146.0)

  # Curatare finala + transformare text in factori
  df <- df %>%
    filter(!is.na(price_in_euro), price_in_euro > 0) %>%
    drop_na()
  for (c in factor_cols) df[[c]] <- as.factor(df[[c]])

  # Antrenare Random Forest
  m <- ranger(price_in_euro ~ ., data = df,
              num.trees = n_trees, max.depth = 20, min.node.size = 2,
              quantreg = TRUE, importance = "impurity",
              respect.unordered.factors = "order", seed = 42, verbose = FALSE)

  # Salveaza modelul si nivelele factor (necesare la predictie)
  model_rv(m)
  lv <- list()
  for (c in factor_cols) lv[[c]] <- levels(df[[c]])
  levels_rv(lv)

  # Status: R² OOB + top caracteristici cu impact in decizie
  r2 <- round(1 - m$prediction.error / var(df$price_in_euro), 3)
  imp <- sort(importance(m), decreasing = TRUE)
  pct <- round(100 * imp / sum(imp), 1)
  imp_str <- paste(names(pct), paste0(pct, "%"), sep = ": ", collapse = " | ")
  status_rv(paste0("Antrenat pe ", fmt(nrow(df)), " masini (", n_trees, " arbori). ",
                   "R² OOB = ", r2, "\nCum decide modelul: ", imp_str))
}

# Antrenare completa pentru o piata: descarca date din SQLite, eventual filtreaza, antreneaza
antreneaza_piata <- function(piata_nume, tabel, sql_cols, factori, n_trees,
                             model_rv, levels_rv, status_rv, filtru = NULL) {
  withProgress(message = paste0("Antrenare RF ", piata_nume, " (", n_trees, " arbori)"),
    value = NULL, {
    con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))
    df <- dbGetQuery(con, paste("SELECT", paste(sql_cols, collapse = ", "), "FROM", tabel))
    if (!is.null(filtru)) df <- filtru(df)
    train_rf(df, factori, n_trees, model_rv, levels_rv, status_rv)
  })
}

# Predictie cu interval +/-10% in jurul medianei
prezice_pret <- function(model, date_noi, pred_rv) {
  med <- predict(model, data = date_noi, type = "quantiles",
                 quantiles = 0.5)$predictions[1, 1]
  pred_rv(list(low = med * 0.9, med = med, high = med * 1.1))
}

# ==============================================================================
# UI
# ==============================================================================

ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Dashboard Auto SH"),

  dashboardSidebar(
    sidebarMenu(id = "main_menu",
                menuItem("Dashboard", tabName = "dashboard", icon = icon("chart-bar")),
                menuItem("Predictor Pret", tabName = "predictor", icon = icon("calculator"))),
    hr(),
    selectInput("piata", "Selecteaza Piata:",
                choices = c("SUA", "Germania", "India"), selected = "Germania"),
    uiOutput("brand_selector")
  ),

  dashboardBody(
    # Spacing aerisit + valueBox responsive (font mai mic pe ecran ingust)
    tags$head(tags$style(HTML("
      .content-wrapper { padding: 20px; }
      .box { margin-bottom: 25px; }
      .row { margin-bottom: 10px; }
      .small-box, .info-box { margin-bottom: 20px; }
      .small-box h3 {
        font-size: 30px !important;
        font-weight: bold !important;
        line-height: 1.2 !important;
        margin: 0 0 5px 0 !important;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
      .small-box p {
        font-size: 13px !important;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
      @media (max-width: 1400px) {
        .small-box h3 { font-size: 24px !important; }
        .small-box p  { font-size: 12px !important; }
      }
      @media (max-width: 1200px) {
        .small-box h3 { font-size: 18px !important; }
        .small-box p  { font-size: 11px !important; }
      }
      @media (max-width: 992px) {
        .small-box h3 { font-size: 26px !important; }
        .small-box p  { font-size: 13px !important; }
      }
      @media (max-width: 768px) {
        .small-box h3 { font-size: 20px !important; }
        .small-box p  { font-size: 11px !important; }
      }
    "))),

    tabItems(

      # =========================================================================
      # ============================ TAB DASHBOARD ==============================
      # =========================================================================
      tabItem(tabName = "dashboard",
              h2(textOutput("titlu_dinamic")),
              fluidRow(
                valueBoxOutput("kpi_listings", width = 4),
                valueBoxOutput("kpi_price", width = 4),
                valueBoxOutput("kpi_km", width = 4)
              ),
              fluidRow(
                valueBoxOutput("kpi_age", width = 4),
                valueBoxOutput("kpi_pop_model", width = 4),
                valueBoxOutput("kpi_pop_listings", width = 4)
              ),
              fluidRow(
                valueBoxOutput("kpi_consum", width = 4),
                valueBoxOutput("kpi_spec1", width = 4),
                valueBoxOutput("kpi_spec2", width = 4)
              ),
              fluidRow(
                box(title = "Distributia Preturilor (EUR)", status = "primary",
                    solidHeader = TRUE, width = 12,
                    plotOutput("price_dist_plot", height = "300px"))
              ),
              fluidRow(
                box(title = "Caracteristici Brand si Piata", status = "info",
                    solidHeader = TRUE, width = 12, uiOutput("market_tabs_ui"))
              )
      ),

      # =========================================================================
      # ============================ TAB PREDICTOR ==============================
      # =========================================================================
      # Toate cele 3 piete urmeaza acelasi tipar:
      #   coloana stanga = campuri baza + campuri optionale (specifice pietei)
      #   coloana dreapta = butoane + status + rezultat
      tabItem(tabName = "predictor",
              h2("Predictor Pret (Random Forest)"),
              tabsetPanel(

                # -------- GERMANIA --------
                tabPanel("Germania",
                         fluidRow(
                           column(6,
                                  campuri_baza("ger", ger_brands, ger_fuels, ger_trans,
                                               year_default = 2015, km_default = 100000),
                                  camp_num("ger", "ps", "Specific Putere (PS)", "Putere (PS):", 120, min_val = 1, step = 1),
                                  camp_num("ger", "engine", "Specific Capacitate cilindrica", "Capacitate cilindrica (L):", 1.6, min_val = 0.5, step = 0.1),
                                  camp_num("ger", "cons", "Specific Consum", "Consum (l/100km):", 6.0, min_val = 1, step = 0.1),
                                  camp_num("ger", "co2", "Specific Emisii CO2", "Emisii CO2 (g/km):", 140, min_val = 0, step = 1)
                           ),
                           column(6, coloana_actiuni("ger"))
                         )
                ),

                # -------- INDIA --------
                tabPanel("India",
                         fluidRow(
                           column(6,
                                  campuri_baza("ind", ind_brands, ind_fuels, ind_trans,
                                               year_default = 2018, km_default = 60000),
                                  camp_num("ind", "ps", "Specific Putere (PS)", "Putere (PS):", 80, min_val = 1, step = 1),
                                  camp_num("ind", "engine", "Specific Capacitate cilindrica", "Capacitate cilindrica (L):", 1.5, min_val = 0.5, step = 0.1),
                                  camp_sel("ind", "body", "Specific Tip caroserie", "Tip caroserie:", ind_body),
                                  camp_num("ind", "cons", "Specific Consum", "Consum (l/100km):", 5.4, min_val = 1, step = 0.1),
                                  camp_sel("ind", "owner", "Specific Proprietar unic", "Un proprietar:", c("Yes", "No")),
                                  camp_sel("ind", "drive", "Specific Tractiune", "Tractiune:", ind_drive),
                                  camp_sel("ind", "seller", "Specific Tip vanzator", "Tip vanzator:", ind_seller),
                                  camp_sel("ind", "state", "Specific Stat", "Stat:", ind_states)
                           ),
                           column(6, coloana_actiuni("ind"))
                         )
                ),

                # -------- SUA --------
                tabPanel("SUA",
                         fluidRow(
                           column(6,
                                  campuri_baza("sua", sua_brands, sua_fuels, sua_trans,
                                               year_default = 2017, km_default = 80000),
                                  camp_num("sua", "engine", "Specific Capacitate cilindrica", "Capacitate cilindrica (L):", 2.5, min_val = 0.5, step = 0.1),
                                  camp_num("sua", "cons", "Specific Consum", "Consum (l/100km):", 10.1, min_val = 1, step = 0.1),
                                  camp_sel("sua", "drive", "Specific Tractiune", "Tractiune:", sua_drive),
                                  camp_sel("sua", "owner", "Specific Proprietar unic", "Un singur proprietar:", c("Yes", "No"))
                           ),
                           column(6, coloana_actiuni("sua"))
                         )
                )
              )
      )
    )
  )
)

# ==============================================================================
# SERVER
# ==============================================================================

server <- function(input, output, session) {

  # ============================================================================
  # ========================== PARTEA 1: DASHBOARD =============================
  # ============================================================================

  # Selector dinamic brand (lista de branduri depinde de piata aleasa)
  output$brand_selector <- renderUI({
    req(input$piata)
    con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))
    brands <- dbGetQuery(con, paste0(
      "SELECT DISTINCT brand FROM `", tabel_piata(input$piata), "` ORDER BY brand"))$brand
    selectInput("brand", "Selecteaza Brand:",
                c("Toate Brandurile", brands), "Toate Brandurile")
  })

  # Sursa reactiva de date pentru dashboard (filtreaza dupa piata + brand)
  car_data <- reactive({
    req(input$piata, input$brand)
    tbl <- tabel_piata(input$piata)
    con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))
    if (input$brand == "Toate Brandurile") {
      dbGetQuery(con, paste0("SELECT * FROM `", tbl, "`"))
    } else {
      dbGetQuery(con, paste0("SELECT * FROM `", tbl, "` WHERE brand = ?"),
                 params = list(input$brand))
    }
  })

  output$titlu_dinamic <- renderText({
    req(input$piata, input$brand)
    if (input$brand == "Toate Brandurile") paste("Analiza Generala:", input$piata)
    else paste("Analiza Brand:", input$brand, paste0("(", input$piata, ")"))
  })

  # Sufix KPI: "Piata" cand toate brandurile sunt incluse, "Brand" altfel
  sfx <- function() if (input$brand == "Toate Brandurile") "Piata" else "Brand"

  # --- KPI-uri ---
  output$kpi_listings <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    valueBox(fmt(nrow(df)), paste("Listari", sfx()), icon = icon("car"), color = "blue")
  })
  output$kpi_price <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    valueBox(paste0(fmt(mean(df$price_in_euro, na.rm = TRUE)), " EUR"),
             paste("Pret Mediu", sfx()), icon = icon("euro-sign"), color = "green")
  })
  output$kpi_km <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    valueBox(paste0(fmt(mean(df$km, na.rm = TRUE)), " km"),
             paste("Kilometraj Mediu", sfx()), icon = icon("road"), color = "purple")
  })
  output$kpi_age <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    valueBox(paste0(round(2023 - mean(df$year, na.rm = TRUE), 1), " ani"),
             paste("Varsta Medie", sfx()), icon = icon("calendar-alt"), color = "yellow")
  })
  output$kpi_pop_model <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    col <- if (input$brand == "Toate Brandurile") "brand" else "model"
    lbl <- if (input$brand == "Toate Brandurile") "Brand Popular" else "Model Popular"
    top <- df %>% count(.data[[col]]) %>% arrange(desc(n))
    valueBox(if (nrow(top) > 0) top[[col]][1] else "N/A", lbl,
             icon = icon("star"), color = "orange")
  })
  output$kpi_pop_listings <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    col <- if (input$brand == "Toate Brandurile") "brand" else "model"
    lbl <- if (input$brand == "Toate Brandurile") "Listari Brand Popular" else "Listari Model Popular"
    top <- df %>% count(.data[[col]]) %>% arrange(desc(n))
    nl <- if (nrow(top) > 0) top$n[1] else 0
    pct <- round((nl / nrow(df)) * 100, 1)
    valueBox(paste0(fmt(nl), " (", pct, "%)"), lbl, icon = icon("list"), color = "blue")
  })
  output$kpi_consum <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    v <- mean(df$fuel_consumption_l_100km, na.rm = TRUE)
    val <- if (is.nan(v) || v <= 0) "N/A" else paste0(round(v, 1), " l/100km")
    valueBox(val, paste("Consum Mediu", sfx()), icon = icon("gas-pump"), color = "aqua")
  })
  output$kpi_spec1 <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    if (input$piata == "Germania") {
      v <- mean(df$co2_g, na.rm = TRUE)
      valueBox(if (is.nan(v) || v <= 0) "N/A" else paste0(round(v, 1), " g/km"),
               paste("CO2 Mediu", sfx()), icon = icon("leaf"), color = "olive")
    } else if (input$piata == "India") {
      v <- mean(df$power_ps, na.rm = TRUE)
      valueBox(if (is.nan(v) || v <= 0) "N/A" else paste0(round(v), " PS"),
               paste("Putere Medie", sfx()), icon = icon("bolt"), color = "orange")
    } else {
      dc <- df %>%
        filter(!is.na(drivetrain), drivetrain != "", drivetrain != "Unknown") %>%
        count(drivetrain) %>%
        arrange(desc(n))
      valueBox(if (nrow(dc) == 0) "N/A" else dc$drivetrain[1],
               paste("Tractiune Majoritara", sfx()), icon = icon("cog"), color = "teal")
    }
  })
  output$kpi_spec2 <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    if (input$piata == "Germania") {
      v <- mean(df$power_ps, na.rm = TRUE)
      valueBox(if (is.nan(v) || v <= 0) "N/A" else paste0(round(v), " PS"),
               paste("Putere Medie", sfx()), icon = icon("bolt"), color = "orange")
    } else if (input$piata == "India") {
      bc <- df %>%
        filter(!is.na(body_type), body_type != "") %>%
        count(body_type) %>%
        arrange(desc(n))
      valueBox(if (nrow(bc) == 0) "N/A" else bc$body_type[1],
               paste("Caroserie Majoritara", sfx()), icon = icon("car-side"), color = "navy")
    } else {
      vd <- df %>% filter(!is.na(one_owner), one_owner != "Unknown")
      val <- if (nrow(vd) == 0) "N/A"
      else paste0(round(sum(vd$one_owner == "Yes") / nrow(vd) * 100, 1), "%")
      valueBox(val, paste("Un Proprietar", sfx()), icon = icon("user-check"), color = "green")
    }
  })

  # --- GRAFICE ---

  # Distributia preturilor (histograma, limita la percentila 99% pentru lizibilitate)
  output$price_dist_plot <- renderPlot({
    df <- car_data(); req(nrow(df) > 0)
    med <- median(df$price_in_euro, na.rm = TRUE)
    avg <- mean(df$price_in_euro, na.rm = TRUE)
    lim <- quantile(df$price_in_euro, 0.99, na.rm = TRUE)
    min_pret <- max(0, floor(min(df$price_in_euro, na.rm = TRUE) / 1000) * 1000)

    # Recodificam preturile peste lim la valoarea lim pentru a le grupa in ultima bara
    df$price_plot <- pmin(df$price_in_euro, lim, na.rm = TRUE)

    # Generam tick-uri personalizate pe axa pentru a arata exact min_pret si lim (ultimul pret)
    ticks <- pretty(c(min_pret, lim), n = 12)
    ticks <- ticks[ticks > min_pret & ticks < (lim - (lim - min_pret) * 0.035)]
    custom_breaks <- c(min_pret, ticks, lim)

    ggplot(df, aes(x = price_plot)) +
      geom_histogram(fill = "steelblue", color = "white", linewidth = 0.3, bins = 100, na.rm = TRUE) +
      geom_vline(xintercept = med, color = "darkred", linetype = "dashed", linewidth = 0.9) +
      geom_vline(xintercept = avg, color = "darkgreen", linetype = "dotted", linewidth = 0.9) +
      annotate("text", x = med, y = Inf, label = paste0("Mediana: ", fmt(med)),
               vjust = 2, hjust = -0.1, color = "darkred") +
      annotate("text", x = avg, y = Inf, label = paste0("Media: ", fmt(avg)),
               vjust = 3.5, hjust = -0.1, color = "darkgreen") +
      scale_x_continuous(breaks = custom_breaks,
                         labels = function(x) {
                           labs <- format(round(x), big.mark = ",")
                           is_lim <- abs(x - lim) < 1e-3
                           labs[is_lim] <- paste0(">", labs[is_lim])
                           labs
                         },
                         limits = c(min_pret, lim), expand = c(0, 0)) +
      scale_y_continuous(breaks = function(x) pretty(x, n = 10),
                         labels = function(x) format(x, big.mark = ",")) +
      labs(x = "Pret (EUR)", y = "Nr. masini") +
      theme_minimal(base_size = 13) +
      theme(plot.margin = margin(t = 10, r = 25, b = 10, l = 10))
  })

  # Distributia anilor de fabricatie (histograma cu etichete verticale)
  output$year_dist_plot <- renderPlot({
    df <- car_data(); req(nrow(df) > 0)
    df_f <- df %>% filter(year <= 2023)

    min_an <- min(df_f$year, na.rm = TRUE)
    an_lim <- as.integer(quantile(df_f$year, 0.01, na.rm = TRUE))

    # Daca percentila 1% este mai mare decat anul minim, grupam tot ce este sub ea
    if (an_lim > min_an) {
      df_f <- df_f %>% mutate(year_group = ifelse(year < an_lim, paste("Sub", an_lim), as.character(year)))
      ani_unici <- as.character(an_lim:2023)
      grupuri <- c(paste("Sub", an_lim), ani_unici)

      start_seq <- an_lim + 1
      if (start_seq <= 2021) {
        ani_seq <- seq(start_seq, 2021, by = 2)
        custom_breaks_x <- c(paste("Sub", an_lim), as.character(ani_seq), "2023")
      } else {
        custom_breaks_x <- c(paste("Sub", an_lim), "2023")
      }
    } else {
      df_f <- df_f %>% mutate(year_group = as.character(year))
      ani_unici <- as.character(min_an:2023)
      grupuri <- ani_unici

      start_seq <- min_an + 1
      if (start_seq <= 2021) {
        ani_seq <- seq(start_seq, 2021, by = 2)
        custom_breaks_x <- c(as.character(min_an), as.character(ani_seq), "2023")
      } else {
        custom_breaks_x <- c(as.character(min_an), "2023")
      }
    }

    df_f$year_group <- factor(df_f$year_group, levels = grupuri)
    df_f <- df_f %>% filter(!is.na(year_group))

    # Calculam frecventa pentru fiecare categorie
    plot_data <- df_f %>% count(year_group, .drop = FALSE)

    # Calculam valoarea maxima pentru limita axei Y
    max_count <- if (nrow(plot_data) > 0) max(plot_data$n, na.rm = TRUE) else 100

    # Generam tick-uri personalizate pe axa Y verticala
    ticks <- pretty(c(0, max_count), n = 10)
    ticks <- ticks[ticks > 0 & ticks < (max_count - max_count * 0.035)]
    custom_breaks_y <- c(0, ticks, max_count)

    ggplot(plot_data, aes(x = year_group, y = n)) +
      geom_col(fill = "darkorange", color = "white", width = 0.8) +
      geom_text(aes(label = ifelse(n > 0, format(n, big.mark = ","), "")),
                angle = 90, hjust = -0.1, size = 2.8, na.rm = TRUE) +
      scale_x_discrete(breaks = custom_breaks_x) +
      scale_y_continuous(breaks = custom_breaks_y,
                         labels = function(x) format(round(x), big.mark = ","),
                         limits = c(0, max_count), expand = c(0, 0)) +
      coord_cartesian(clip = "off") +
      labs(x = "An Fabricatie", y = "Nr. masini") +
      theme_minimal(base_size = 13) +
      theme(plot.margin = margin(t = 35, r = 15, b = 10, l = 10))
  })

  # Bar plot orizontal cu numere (top N)
  bar_plot <- function(df, col, y_label = "Nr. listari", n_top = 10) {
    plot_data <- df %>% count(.data[[col]]) %>% top_n(n_top, n)
    max_val <- if (nrow(plot_data) > 0) max(plot_data$n, na.rm = TRUE) else 100

    # Generam tick-uri pentru axa numerica (reprezinta axa Y, afisata pe orizontala din cauza coord_flip)
    ticks <- pretty(c(0, max_val), n = 10)
    ticks <- ticks[ticks > 0 & ticks < (max_val - max_val * 0.035)]
    custom_breaks <- c(0, ticks, max_val)

    ggplot(plot_data, aes(x = reorder(.data[[col]], n), y = n)) +
      geom_col(fill = "steelblue", width = 0.7) +
      geom_text(aes(label = format(n, big.mark = ",")), hjust = -0.1, size = 3.8) +
      coord_flip(clip = "off") +
      scale_y_continuous(breaks = custom_breaks,
                         labels = function(x) format(round(x), big.mark = ","),
                         limits = c(0, max_val), expand = c(0, 0)) +
      labs(x = "", y = y_label) +
      theme_minimal(base_size = 13) +
      theme(plot.margin = margin(t = 10, r = 55, b = 10, l = 10))
  }

  output$models_plot <- renderPlot({
    df <- car_data(); req(nrow(df) > 0)
    col <- if (input$brand == "Toate Brandurile") "brand" else "model"
    lbl <- if (input$brand == "Toate Brandurile") "Top 5 Branduri" else "Top 5 Modele"
    bar_plot(df, col, lbl, n_top = 5)
  })
  output$trans_plot <- renderPlot({ df <- car_data(); req(nrow(df) > 0); bar_plot(df, "transmission_type") })
  output$fuel_plot <- renderPlot({ df <- car_data(); req(nrow(df) > 0); bar_plot(df, "fuel_type") })

  output$india_extra_plot <- renderPlot({
    df <- car_data()
    validate(need("body_type" %in% names(df), "Lipsa coloana"))
    df_p <- df %>% filter(!is.na(body_type), body_type != "")
    validate(need(nrow(df_p) > 0, "Fara date"))
    bar_plot(df_p, "body_type", "Nr. masini")
  })

  output$sua_drivetrain_plot <- renderPlot({
    df <- car_data()
    validate(need("drivetrain" %in% names(df), "Lipsa coloana"))
    df_p <- df %>% filter(!is.na(drivetrain), drivetrain != "", drivetrain != "Unknown")
    validate(need(nrow(df_p) > 0, "Fara date"))
    bar_plot(df_p, "drivetrain", "Nr. masini")
  })

  output$sua_owner_plot <- renderPlot({
    df <- car_data()
    validate(need("one_owner" %in% names(df), "Lipsa coloana"))
    df_p <- df %>% filter(!is.na(one_owner), one_owner != "", one_owner != "Unknown")
    validate(need(nrow(df_p) > 0, "Fara date"))

    plot_data <- df_p %>% count(one_owner)
    max_val <- if (nrow(plot_data) > 0) max(plot_data$n, na.rm = TRUE) else 100

    # Generam tick-uri personalizate pe axa Y verticala
    ticks <- pretty(c(0, max_val), n = 10)
    ticks <- ticks[ticks > 0 & ticks < (max_val - max_val * 0.035)]
    custom_breaks <- c(0, ticks, max_val)

    plot_data %>%
      ggplot(aes(x = one_owner, y = n, fill = one_owner)) +
      geom_col(width = 0.55, show.legend = FALSE) +
      geom_text(aes(label = format(n, big.mark = ",")), vjust = -0.5, size = 4) +
      scale_fill_manual(values = c("Yes" = "darkgreen", "No" = "darkred")) +
      scale_y_continuous(breaks = custom_breaks,
                         labels = function(x) format(round(x), big.mark = ","),
                         limits = c(0, max_val), expand = c(0, 0)) +
      labs(x = "Un singur proprietar?", y = "Nr. masini") +
      theme_minimal(base_size = 13) +
      theme(plot.margin = margin(t = 35, r = 15, b = 10, l = 10))
  })

  # Tab-uri dinamice (extra-graficele difera per piata)
  output$market_tabs_ui <- renderUI({
    req(input$piata)
    tab_lbl <- if (!is.null(input$brand) && input$brand == "Toate Brandurile") "Branduri Populare" else "Modele Populare"
    comune <- list(
      tabPanel(tab_lbl, plotOutput("models_plot", height = "250px")),
      tabPanel("An Fabricatie", plotOutput("year_dist_plot", height = "250px")),
      tabPanel("Transmisie", plotOutput("trans_plot", height = "250px")),
      tabPanel("Combustibil", plotOutput("fuel_plot", height = "250px"))
    )
    extra <- switch(input$piata,
                    "India" = list(tabPanel("Tip Caroserie", plotOutput("india_extra_plot", height = "250px"))),
                    "SUA" = list(tabPanel("Tractiune", plotOutput("sua_drivetrain_plot", height = "250px")),
                                 tabPanel("Un Proprietar", plotOutput("sua_owner_plot", height = "250px"))),
                    list())
    do.call(tabBox, c(list(width = 12), comune, extra))
  })

  # ============================================================================
  # ========================== PARTEA 2: PREDICTOR =============================
  # ============================================================================
  # Random Forest: Germania 300 arbori, India 500, SUA 200 | Interval +/-10%
  # Toate cele 3 piete urmeaza acelasi tipar (vezi structura tabPanel si observere)

  # Lista de modele pentru un brand (pentru dropdown reactiv)
  get_models <- function(tbl, brand) {
    con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))
    dbGetQuery(con, paste0(
      "SELECT DISTINCT model FROM `", tbl,
      "` WHERE brand = ? AND model IS NOT NULL AND model != '' ORDER BY model"
    ), params = list(brand))$model
  }

  # Imputare DB la predictie: media unei coloane pentru (brand+model) sau (brand)
  # Folosit cand utilizatorul nu specifica manual valoarea
  get_db_avg <- function(tbl, col, brand, model, fuel_type, fallback) {
    if (!is.null(fuel_type) &&
      fuel_type == "Electric" &&
      col %in% c("engine_type", "fuel_consumption_l_100km", "co2_g")) return(0)
    con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))
    # Pas 1: media pentru brand+model
    res <- dbGetQuery(con, paste0(
      "SELECT AVG(`", col, "`) FROM `", tbl,
      "` WHERE brand = ? AND model = ? AND `", col, "` IS NOT NULL AND `", col, "` > 0"
    ), params = list(brand, model))[[1]]
    if (!is.na(res) && length(res) > 0 && res > 0) return(res)
    # Pas 2: media pentru brand
    res <- dbGetQuery(con, paste0(
      "SELECT AVG(`", col, "`) FROM `", tbl,
      "` WHERE brand = ? AND `", col, "` IS NOT NULL AND `", col, "` > 0"
    ), params = list(brand))[[1]]
    if (!is.na(res) && length(res) > 0 && res > 0) return(res)
    fallback
  }

  # Imputare DB la predictie: cel mai frecvent (modul statistic) pentru o categorie
  get_db_mode <- function(tbl, col, brand, model, fallback) {
    con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))
    res <- dbGetQuery(con, paste0(
      "SELECT `", col, "`, COUNT(*) as c FROM `", tbl,
      "` WHERE brand = ? AND model = ? AND `", col, "` IS NOT NULL AND `", col, "` != ''",
      " GROUP BY `", col, "` ORDER BY c DESC LIMIT 1"
    ), params = list(brand, model))[[1]]
    if (length(res) > 0 && !is.na(res) && res != "") return(res)
    res <- dbGetQuery(con, paste0(
      "SELECT `", col, "`, COUNT(*) as c FROM `", tbl,
      "` WHERE brand = ? AND `", col, "` IS NOT NULL AND `", col, "` != ''",
      " GROUP BY `", col, "` ORDER BY c DESC LIMIT 1"
    ), params = list(brand))[[1]]
    if (length(res) > 0 && !is.na(res) && res != "") return(res)
    fallback
  }

  # Valoare numerica: input manual (daca user a bifat) sau media din DB
  val_num <- function(piata, nume, tbl, col, brand, model, fuel, fallback) {
    if (isTRUE(input[[paste0("pred_", piata, "_use_", nume)]])) {
      as.numeric(input[[paste0("pred_", piata, "_", nume)]])
    } else get_db_avg(tbl, col, brand, model, fuel, fallback)
  }

  # Valoare categorica: input manual (daca user a bifat) sau modul din DB
  val_cat <- function(piata, nume, tbl, col, brand, model, fallback) {
    if (isTRUE(input[[paste0("pred_", piata, "_use_", nume)]])) {
      input[[paste0("pred_", piata, "_", nume)]]
    } else get_db_mode(tbl, col, brand, model, fallback)
  }

  # Verificare ca modelul a fost antrenat inainte de predictie
  verifica_model <- function(model) {
    if (is.null(model)) {
      showNotification("Antreneaza modelul mai intai (butonul portocaliu)!",
                       type = "warning", duration = 5)
      return(FALSE)
    }
    TRUE
  }

  # Caseta verde cu rezultatul predictiei
  result_box <- function(p) {
    if (is.null(p)) return(NULL)
    valueBox(
      paste0(fmt(p$med), " EUR"),
      paste0("Interval +/- 10%: ", fmt(p$low), " - ", fmt(p$high), " EUR"),
      icon = icon("euro-sign"), color = "green", width = 12
    )
  }

  # --- Stari reactive: model antrenat, nivele factor, ultima predictie, mesaj status ---
  model_ger <- reactiveVal(); levels_ger <- reactiveVal(); pred_ger <- reactiveVal()
  model_ind <- reactiveVal(); levels_ind <- reactiveVal(); pred_ind <- reactiveVal()
  model_sua <- reactiveVal(); levels_sua <- reactiveVal(); pred_sua <- reactiveVal()
  status_ger <- reactiveVal("Apasa 'Antreneaza Model'.")
  status_ind <- reactiveVal("Apasa 'Antreneaza Model'.")
  status_sua <- reactiveVal("Apasa 'Antreneaza Model'.")

  output$train_ger_status <- renderText(status_ger())
  output$train_ind_status <- renderText(status_ind())
  output$train_sua_status <- renderText(status_sua())

  output$pred_ger_result <- renderUI({ result_box(pred_ger()) })
  output$pred_ind_result <- renderUI({ result_box(pred_ind()) })
  output$pred_sua_result <- renderUI({ result_box(pred_sua()) })

  # Dropdown-uri model: se actualizeaza cand schimbi brandul
  output$pred_ger_model_ui <- renderUI({
    req(input$pred_ger_brand)
    selectInput("pred_ger_model", "Model:", choices = get_models("Germany_Cars_Cleaned", input$pred_ger_brand))
  })
  output$pred_ind_model_ui <- renderUI({
    req(input$pred_ind_brand)
    selectInput("pred_ind_model", "Model:", choices = get_models("India_Cars_Cleaned", input$pred_ind_brand))
  })
  output$pred_sua_model_ui <- renderUI({
    req(input$pred_sua_brand)
    selectInput("pred_sua_model", "Model:", choices = get_models("SUA_Cars_Cleaned", input$pred_sua_brand))
  })

  # ============================================================================
  # ============================== GERMANIA ====================================
  # ============================================================================
  observeEvent(input$train_ger, {
    antreneaza_piata("Germania", "Germany_Cars_Cleaned",
                     sql_cols = c("price_in_euro", "km", "year", "power_ps", "engine_type",
                                  "brand", "model", "fuel_type", "transmission_type",
                                  "co2_g", "fuel_consumption_l_100km"),
                     factori = c("brand", "model", "fuel_type", "transmission_type"),
                     n_trees = 300,
                     model_rv = model_ger, levels_rv = levels_ger, status_rv = status_ger)
  })

  observeEvent(input$pred_ger_btn, {
    if (!verifica_model(model_ger())) return()
    req(input$pred_ger_model)
    lvl <- levels_ger(); TBL <- "Germany_Cars_Cleaned"
    br <- input$pred_ger_brand; mo <- input$pred_ger_model; fu <- input$pred_ger_fuel

    ps_val <- val_num("ger", "ps", TBL, "power_ps", br, mo, fu, 120)
    engine_val <- val_num("ger", "engine", TBL, "engine_type", br, mo, fu, 1.6)
    cons_val <- val_num("ger", "cons", TBL, "fuel_consumption_l_100km", br, mo, fu, 6.1)
    co2_val <- val_num("ger", "co2", TBL, "co2_g", br, mo, fu, 146.5)
    if (fu == "Electric") engine_val <- 0

    date_noi <- data.frame(
      km = as.numeric(input$pred_ger_km),
      age = as.integer(2026 - input$pred_ger_year),
      power_ps = ps_val,
      engine_type = engine_val,
      fuel_consumption_l_100km = cons_val,
      co2_g = co2_val,
      brand = factor(br, levels = lvl$brand),
      model = factor(mo, levels = lvl$model),
      fuel_type = factor(fu, levels = lvl$fuel_type),
      transmission_type = factor(input$pred_ger_trans, levels = lvl$transmission_type)
    )
    prezice_pret(model_ger(), date_noi, pred_ger)
  })

  # ============================================================================
  # =============================== INDIA ======================================
  # ============================================================================
  observeEvent(input$train_ind, {
    antreneaza_piata("India", "India_Cars_Cleaned",
                     sql_cols = c("price_in_euro", "km", "year", "power_ps", "engine_type",
                                  "brand", "model", "fuel_type", "transmission_type",
                                  "body_type", "fuel_consumption_l_100km", "one_owner",
                                  "drivetrain", "seller_type", "state"),
                     factori = c("brand", "model", "fuel_type", "transmission_type", "body_type",
                                 "one_owner", "drivetrain", "seller_type", "state"),
                     n_trees = 500,
                     model_rv = model_ind, levels_rv = levels_ind, status_rv = status_ind)
  })

  observeEvent(input$pred_ind_btn, {
    if (!verifica_model(model_ind())) return()
    req(input$pred_ind_model)
    lvl <- levels_ind(); TBL <- "India_Cars_Cleaned"
    br <- input$pred_ind_brand; mo <- input$pred_ind_model; fu <- input$pred_ind_fuel

    ps_val <- val_num("ind", "ps", TBL, "power_ps", br, mo, fu, 80)
    engine_val <- val_num("ind", "engine", TBL, "engine_type", br, mo, fu, 1.5)
    cons_val <- val_num("ind", "cons", TBL, "fuel_consumption_l_100km", br, mo, fu, 5.4)
    body_val <- val_cat("ind", "body", TBL, "body_type", br, mo, "Hatchback")
    owner_val <- val_cat("ind", "owner", TBL, "one_owner", br, mo, "Yes")
    drive_val <- val_cat("ind", "drive", TBL, "drivetrain", br, mo, "FWD")
    seller_val <- val_cat("ind", "seller", TBL, "seller_type", br, mo, "Dealer")
    state_val <- val_cat("ind", "state", TBL, "state", br, mo, "delhi")
    if (fu == "Electric") engine_val <- 0

    date_noi <- data.frame(
      km = as.numeric(input$pred_ind_km),
      age = as.integer(2026 - input$pred_ind_year),
      power_ps = ps_val,
      engine_type = engine_val,
      fuel_consumption_l_100km = cons_val,
      brand = factor(br, levels = lvl$brand),
      model = factor(mo, levels = lvl$model),
      fuel_type = factor(fu, levels = lvl$fuel_type),
      transmission_type = factor(input$pred_ind_trans, levels = lvl$transmission_type),
      body_type = factor(body_val, levels = lvl$body_type),
      one_owner = factor(owner_val, levels = lvl$one_owner),
      drivetrain = factor(drive_val, levels = lvl$drivetrain),
      seller_type = factor(seller_val, levels = lvl$seller_type),
      state = factor(state_val, levels = lvl$state)
    )
    prezice_pret(model_ind(), date_noi, pred_ind)
  })

  # ============================================================================
  # ================================ SUA =======================================
  # ============================================================================
  observeEvent(input$train_sua, {
    antreneaza_piata("SUA", "SUA_Cars_Cleaned",
                     sql_cols = c("price_in_euro", "km", "year", "engine_type",
                                  "brand", "model", "fuel_type", "transmission_type",
                                  "drivetrain", "one_owner", "fuel_consumption_l_100km"),
                     factori = c("brand", "model", "fuel_type", "transmission_type", "drivetrain", "one_owner"),
                     n_trees = 200,
                     model_rv = model_sua, levels_rv = levels_sua, status_rv = status_sua,
                     filtru = function(df) df %>% filter(one_owner %in% c("Yes", "No")))
  })

  observeEvent(input$pred_sua_btn, {
    if (!verifica_model(model_sua())) return()
    req(input$pred_sua_model)
    lvl <- levels_sua(); TBL <- "SUA_Cars_Cleaned"
    br <- input$pred_sua_brand; mo <- input$pred_sua_model; fu <- input$pred_sua_fuel

    engine_val <- val_num("sua", "engine", TBL, "engine_type", br, mo, fu, 2.5)
    cons_val <- val_num("sua", "cons", TBL, "fuel_consumption_l_100km", br, mo, fu, 10.1)
    drive_val <- val_cat("sua", "drive", TBL, "drivetrain", br, mo, "FWD")
    owner_val <- val_cat("sua", "owner", TBL, "one_owner", br, mo, "Yes")
    if (fu == "Electric") engine_val <- 0

    date_noi <- data.frame(
      km = as.numeric(input$pred_sua_km),
      age = as.integer(2026 - input$pred_sua_year),
      engine_type = engine_val,
      fuel_consumption_l_100km = cons_val,
      brand = factor(br, levels = lvl$brand),
      model = factor(mo, levels = lvl$model),
      fuel_type = factor(fu, levels = lvl$fuel_type),
      transmission_type = factor(input$pred_sua_trans, levels = lvl$transmission_type),
      drivetrain = factor(drive_val, levels = lvl$drivetrain),
      one_owner = factor(owner_val, levels = lvl$one_owner)
    )
    prezice_pret(model_sua(), date_noi, pred_sua)
  })

}

shinyApp(ui = ui, server = server)
