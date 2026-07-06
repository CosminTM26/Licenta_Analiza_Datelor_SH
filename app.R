# ==============================================================================
# Dashboard Auto SH + Predictor Pret (Random Forest)
# Licenta Cosmin
# ==============================================================================

library(shiny)
library(shinydashboard)
library(DBI)
library(RSQLite)
library(tidyverse)
library(ranger)

options(scipen = 999)
options(ranger.num.threads = 10)

# Paleta pe piete (aceleasi culori ca in Utile/Grafice_Helpers.R - steaguri nationale)
culori_piete <- c("Germania" = "#DD0000",   # rosu steag
                  "SUA" = "#0A3161",         # albastru steag
                  "India" = "#046A38")       # verde steag


# ==============================================================================
# INCARCARE DATE DIN SQLITE (in memorie)
# ==============================================================================

DB <- "identifier.sqlite"

con <- dbConnect(RSQLite::SQLite(), DB)
germany_data <- dbReadTable(con, "Germany_Cars_Cleaned")
india_data <- dbReadTable(con, "India_Cars_Cleaned")
sua_data <- dbReadTable(con, "SUA_Cars_Cleaned")
dbDisconnect(con)


# ==============================================================================
# HELPER-E GENERALE
# ==============================================================================

fmt <- function(x) {
  if (is.na(x) || is.nan(x)) return("N/A")
  format(round(x), big.mark = ",")
}

ger_brands <- unique(germany_data$brand) %>% sort()
ger_fuels <- unique(germany_data$fuel_type) %>% sort()
ger_trans <- unique(germany_data$transmission_type) %>% sort()

ind_brands <- unique(india_data$brand) %>% sort()
ind_fuels <- unique(india_data$fuel_type) %>% sort()
ind_trans <- unique(india_data$transmission_type) %>% sort()
ind_body <- unique(india_data$body_type) %>% sort()
ind_seller <- unique(india_data$seller_type) %>% sort()
ind_drive <- unique(india_data$drivetrain) %>% sort()

sua_brands <- unique(sua_data$brand) %>% sort()
sua_fuels <- unique(sua_data$fuel_type) %>% sort()
sua_trans <- unique(sua_data$transmission_type) %>% sort()
sua_drive <- unique(sua_data$drivetrain) %>% sort()


# ==============================================================================
# HELPER-E UI PENTRU PREDICTOR
# ==============================================================================

campuri_baza <- function(piata, brands, fuels, trans, year_default, km_default, min_year, max_year) {
  id <- function(s) paste0("pred_", piata, "_", s)
  tagList(
    selectInput(id("brand"), "Brand:", choices = brands),
    uiOutput(id("model_ui")),
    numericInput(id("km"), "Kilometraj (km):", value = km_default, min = 0, step = 10000),
    numericInput(id("year"), "An fabricatie:", value = year_default, min = min_year, max = max_year, step = 1),
    selectInput(id("fuel"), "Combustibil:", choices = fuels),
    selectInput(id("trans"), "Transmisie:", choices = trans)
  )
}

camp_num <- function(piata, nume, label_cb, label_inp, default, min_val = 1, step = 0.1) {
  id_inp <- paste0("pred_", piata, "_", nume)
  id_cb <- paste0("pred_", piata, "_use_", nume)
  tagList(
    checkboxInput(id_cb, label_cb, value = FALSE),
    conditionalPanel(condition = paste0("input.", id_cb, " == true"),
                     numericInput(id_inp, label_inp, value = default, min = min_val, step = step))
  )
}

camp_sel <- function(piata, nume, label_cb, label_inp, choices) {
  id_inp <- paste0("pred_", piata, "_", nume)
  id_cb <- paste0("pred_", piata, "_use_", nume)
  tagList(
    checkboxInput(id_cb, label_cb, value = FALSE),
    conditionalPanel(condition = paste0("input.", id_cb, " == true"),
                     selectInput(id_inp, label_inp, choices = choices))
  )
}

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
# HELPER-E MACHINE LEARNING (Random Forest)
# ==============================================================================

train_rf <- function(date, coloane_factor, nr_arbori, model_rv, levels_rv, status_rv) {
  coloane_electric <- intersect(c("engine_type", "fuel_consumption_l_100km", "co2_g"), names(date))

  date <- date %>%
    # Datele sunt din 2023, deci la ANTRENARE varsta = 2023 - an fabricatie.
    # La PREDICTIE folosim 2026 - an (vezi observatorii de mai jos), ca sa
    # proiectam deprecierea pana in prezent. Diferenta este intentionata.
    mutate(age = 2023 - year, year = NULL) %>%
    mutate(across(all_of(coloane_electric), ~if_else(fuel_type == "Electric" & is.na(.), 0, .))) %>%
    filter(!is.na(price_in_euro), price_in_euro > 0) %>%
    drop_na() %>%
    mutate(across(all_of(coloane_factor), as.factor))

  # Antrenam pe log(pret): stabilizeaza distributia asimetrica a preturilor (vezi DECIZII 13.5)
  padure <- ranger(log(price_in_euro) ~ ., data = date,
                   num.trees = nr_arbori, max.depth = 20, min.node.size = 2,
                   quantreg = TRUE, importance = "impurity",
                   respect.unordered.factors = "order", seed = 42)

  model_rv(padure)
  levels_rv(lapply(date[coloane_factor], levels))

  r2 <- round(padure$r.squared, 3)

  # RMSE si MAE pe predictiile Out-of-Bag (aduse din log in EUR). Afisate DOAR in consola R,
  # nu in interfata web: servesc la evaluarea din lucrare (Tabelul 4.1), nu utilizatorului final.
  pret_oob <- exp(padure$predictions)
  rmse <- round(sqrt(mean((date$price_in_euro - pret_oob)^2)))
  mae  <- round(mean(abs(date$price_in_euro - pret_oob)))
  cat("Metrici model (", nr_arbori, "arbori): R2 OOB =", r2,
      "| RMSE =", rmse, "EUR | MAE =", mae, "EUR\n")

  importanta <- sort(importance(padure), decreasing = TRUE)
  procente <- round(100 * importanta / sum(importanta), 1)
  text_importanta <- paste(names(procente), paste0(procente, "%"), sep = ": ", collapse = " | ")
  status_rv(paste0("Antrenat pe ", fmt(nrow(date)), " masini (", nr_arbori, " arbori). ",
                   "R² OOB = ", r2,
                   "\nCum decide modelul: ", text_importanta))
}

antreneaza_piata <- function(piata_nume, date_piata, coloane_pastrate, coloane_factor,
                             nr_arbori, model_rv, levels_rv, status_rv, filtru = NULL) {
  withProgress(message = paste0("Antrenare RF ", piata_nume, " (", nr_arbori, " arbori)"),
    value = NULL, {
    date_antrenare <- date_piata %>% select(all_of(coloane_pastrate))
    if (!is.null(filtru)) date_antrenare <- filtru(date_antrenare)
    train_rf(date_antrenare, coloane_factor, nr_arbori, model_rv, levels_rv, status_rv)
  })
}

prezice_pret <- function(model, date_noi, pred_rv) {
  # exp() readuce predictia din scara log inapoi in EUR reali (mediana se pastreaza)
  pret <- exp(predict(model, data = date_noi,
                      type = "quantiles", quantiles = 0.5)$predictions[1, 1])
  pred_rv(list(low = pret * 0.9, med = pret, high = pret * 1.1))
}


# ==============================================================================
# HELPER-E GRAFICE
# ==============================================================================

breaks_cu_max <- function(max_val, n = 10) {
  ticks <- pretty(c(0, max_val), n = n)
  ticks <- ticks[ticks > 0 & ticks < (max_val - max_val * 0.035)]
  c(0, ticks, max_val)
}

tema_plot <- function(top = 10, right = 25, bottom = 10, left = 10) {
  theme_minimal(base_size = 13) +
    theme(plot.margin = margin(t = top, r = right, b = bottom, l = left))
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
    tags$head(tags$style(HTML("
      .content-wrapper { padding: 20px; }
      .box { margin-bottom: 25px; }
      .row { margin-bottom: 10px; }
      .small-box, .info-box { margin-bottom: 20px; }
      .small-box h3, .small-box p { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
      .small-box h3 { font-size: clamp(18px, 2.2vw, 30px) !important; font-weight: bold !important; line-height: 1.2 !important; margin: 0 0 5px 0 !important; }
      .small-box p  { font-size: clamp(11px, 1vw, 13px) !important; }
    "))),

    tabItems(

      # --- DASHBOARD ---
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

      # --- PREDICTOR ---
      tabItem(tabName = "predictor",
              h2("Predictor Pret (Random Forest)"),
              tabsetPanel(

                tabPanel("Germania",
                         fluidRow(
                           column(6,
                                  campuri_baza("ger", ger_brands, ger_fuels, ger_trans,
                                               year_default = 2015, km_default = 100000,
                                               min_year = 1995, max_year = 2026),
                                  camp_num("ger", "ps", "Specific Putere (PS)", "Putere (PS):", 120, min_val = 1, step = 1),
                                  camp_num("ger", "engine", "Specific Capacitate cilindrica", "Capacitate cilindrica (L):", 1.6, min_val = 0.5, step = 0.1),
                                  camp_num("ger", "cons", "Specific Consum", "Consum (l/100km):", 6.0, min_val = 1, step = 0.1),
                                  camp_num("ger", "co2", "Specific Emisii CO2", "Emisii CO2 (g/km):", 140, min_val = 0, step = 1)
                           ),
                           column(6, coloana_actiuni("ger"))
                         )
                ),

                tabPanel("India",
                         fluidRow(
                           column(6,
                                  campuri_baza("ind", ind_brands, ind_fuels, ind_trans,
                                               year_default = 2018, km_default = 60000,
                                               min_year = 1983, max_year = 2026),
                                  camp_num("ind", "ps", "Specific Putere (PS)", "Putere (PS):", 80, min_val = 1, step = 1),
                                  camp_num("ind", "engine", "Specific Capacitate cilindrica", "Capacitate cilindrica (L):", 1.5, min_val = 0.5, step = 0.1),
                                  camp_sel("ind", "body", "Specific Tip caroserie", "Tip caroserie:", ind_body),
                                  camp_num("ind", "cons", "Specific Consum", "Consum (l/100km):", 5.4, min_val = 1, step = 0.1),
                                  camp_sel("ind", "owner", "Specific Proprietar unic", "Un proprietar:", c("Yes", "No")),
                                  camp_sel("ind", "drive", "Specific Tractiune", "Tractiune:", ind_drive),
                                  camp_sel("ind", "seller", "Specific Tip vanzator", "Tip vanzator:", ind_seller)
                           ),
                           column(6, coloana_actiuni("ind"))
                         )
                ),

                tabPanel("SUA",
                         fluidRow(
                           column(6,
                                  campuri_baza("sua", sua_brands, sua_fuels, sua_trans,
                                               year_default = 2017, km_default = 80000,
                                               min_year = 1915, max_year = 2026),
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

  # --- DASHBOARD ---

  output$brand_selector <- renderUI({
    req(input$piata)
    date <- switch(input$piata,
                   "India" = india_data,
                   "Germania" = germany_data,
                   "SUA" = sua_data)
    marci <- unique(date$brand) %>% sort()
    selectInput("brand", "Selecteaza Brand:",
                c("Toate Brandurile", marci), "Toate Brandurile")
  })

  car_data <- reactive({
    req(input$piata, input$brand)
    date <- switch(input$piata,
                   "India" = india_data,
                   "Germania" = germany_data,
                   "SUA" = sua_data)
    if (input$brand != "Toate Brandurile") {
      date <- date %>% filter(brand == input$brand)
    }
    date
  })

  output$titlu_dinamic <- renderText({
    req(input$piata, input$brand)
    if (input$brand == "Toate Brandurile") paste("Analiza Generala:", input$piata)
    else paste("Analiza Brand:", input$brand, paste0("(", input$piata, ")"))
  })

  sfx <- function() if (input$brand == "Toate Brandurile") "Piata" else "Brand"


  # --- KPI-uri ---

  output$kpi_listings <- renderValueBox({
    date <- car_data(); req(nrow(date) > 0)
    valueBox(fmt(nrow(date)), paste("Listari"), icon = icon("car"), color = "blue")
  })
  output$kpi_price <- renderValueBox({
    date <- car_data(); req(nrow(date) > 0)
    valueBox(paste0(fmt(mean(date$price_in_euro, na.rm = TRUE)), " EUR"),
             paste("Pret Mediu"), icon = icon("euro-sign"), color = "green")
  })
  output$kpi_km <- renderValueBox({
    date <- car_data(); req(nrow(date) > 0)
    valueBox(paste0(fmt(mean(date$km, na.rm = TRUE)), " km"),
             paste("Kilometraj Mediu"), icon = icon("road"), color = "purple")
  })
  output$kpi_age <- renderValueBox({
    date <- car_data(); req(nrow(date) > 0)
    valueBox(paste0(round(2023 - mean(date$year, na.rm = TRUE), 1), " ani"),
             paste("Varsta Medie"), icon = icon("calendar-alt"), color = "yellow")
  })
  output$kpi_pop_model <- renderValueBox({
    date <- car_data(); req(nrow(date) > 0)
    coloana <- if (input$brand == "Toate Brandurile") "brand" else "model"
    eticheta <- if (input$brand == "Toate Brandurile") "Brand Popular" else "Model Popular"
    cel_mai_frecvent <- date %>%
      count(.data[[coloana]], sort = TRUE) %>%
      slice(1) %>%
      pull(.data[[coloana]])
    valueBox(if (length(cel_mai_frecvent) > 0) cel_mai_frecvent else "N/A", eticheta,
             icon = icon("star"), color = "orange")
  })
  output$kpi_pop_listings <- renderValueBox({
    date <- car_data(); req(nrow(date) > 0)
    coloana <- if (input$brand == "Toate Brandurile") "brand" else "model"
    eticheta <- if (input$brand == "Toate Brandurile") "Listari Brand Popular" else "Listari Model Popular"
    nr_listari <- date %>%
      count(.data[[coloana]], sort = TRUE) %>%
      slice(1) %>%
      pull(n)
    if (length(nr_listari) == 0) nr_listari <- 0
    procent <- round((nr_listari / nrow(date)) * 100, 1)
    valueBox(paste0(fmt(nr_listari), " (", procent, "%)"), eticheta, icon = icon("list"), color = "blue")
  })
  output$kpi_consum <- renderValueBox({
    date <- car_data(); req(nrow(date) > 0)
    valoare <- mean(date$fuel_consumption_l_100km, na.rm = TRUE)
    text <- if (is.nan(valoare) || valoare <= 0) "N/A" else paste0(round(valoare, 1), " l/100km")
    valueBox(text, paste("Consum Mediu"), icon = icon("gas-pump"), color = "aqua")
  })
  output$kpi_spec1 <- renderValueBox({
    date <- car_data(); req(nrow(date) > 0)
    if (input$piata == "Germania") {
      valoare <- mean(date$co2_g, na.rm = TRUE)
      valueBox(if (is.nan(valoare) || valoare <= 0) "N/A" else paste0(round(valoare, 1), " g/km"),
               paste("CO2 Mediu"), icon = icon("leaf"), color = "olive")
    } else if (input$piata == "India") {
      valoare <- mean(date$power_ps, na.rm = TRUE)
      valueBox(if (is.nan(valoare) || valoare <= 0) "N/A" else paste0(round(valoare), " PS"),
               paste("Putere Medie"), icon = icon("bolt"), color = "orange")
    } else {
      tractiune_top <- date %>%
        filter(!is.na(drivetrain), drivetrain != "", drivetrain != "Unknown") %>%
        count(drivetrain, sort = TRUE) %>%
        slice(1) %>%
        pull(drivetrain)
      valueBox(if (length(tractiune_top) == 0) "N/A" else tractiune_top,
               paste("Tractiune Majoritara"), icon = icon("cog"), color = "teal")
    }
  })
  output$kpi_spec2 <- renderValueBox({
    date <- car_data(); req(nrow(date) > 0)
    if (input$piata == "Germania") {
      valoare <- mean(date$power_ps, na.rm = TRUE)
      valueBox(if (is.nan(valoare) || valoare <= 0) "N/A" else paste0(round(valoare), " PS"),
               paste("Putere Medie"), icon = icon("bolt"), color = "orange")
    } else if (input$piata == "India") {
      caroserie_top <- date %>%
        filter(!is.na(body_type), body_type != "") %>%
        count(body_type, sort = TRUE) %>%
        slice(1) %>%
        pull(body_type)
      valueBox(if (length(caroserie_top) == 0) "N/A" else caroserie_top,
               paste("Caroserie Majoritara"), icon = icon("car-side"), color = "navy")
    } else {
      date_valide <- date %>% filter(!is.na(one_owner), one_owner != "Unknown")
      text <- if (nrow(date_valide) == 0) "N/A"
      else paste0(round(sum(date_valide$one_owner == "Yes") / nrow(date_valide) * 100, 1), "%")
      valueBox(text, paste("Un Proprietar"), icon = icon("user-check"), color = "green")
    }
  })


  # --- GRAFICE ---

  output$price_dist_plot <- renderPlot({
    date <- car_data(); req(nrow(date) > 0)
    mediana <- median(date$price_in_euro, na.rm = TRUE)
    medie <- mean(date$price_in_euro, na.rm = TRUE)
    limita_99 <- quantile(date$price_in_euro, 0.99, na.rm = TRUE)
    pret_minim <- max(0, floor(min(date$price_in_euro, na.rm = TRUE) / 1000) * 1000)

    marcaje <- pretty(c(pret_minim, limita_99), n = 12)
    marcaje <- marcaje[marcaje > pret_minim & marcaje < (limita_99 - (limita_99 - pret_minim) * 0.035)]
    marcaje_x <- c(pret_minim, marcaje, limita_99)

    date %>%
      mutate(price_plot = pmin(price_in_euro, limita_99, na.rm = TRUE)) %>%
      ggplot(aes(x = price_plot)) +
      geom_histogram(fill = culori_piete[[input$piata]], color = "white", linewidth = 0.3, bins = 100, na.rm = TRUE) +
      geom_vline(xintercept = mediana, color = "darkred", linetype = "dashed", linewidth = 0.9) +
      geom_vline(xintercept = medie, color = "darkgreen", linetype = "dotted", linewidth = 0.9) +
      annotate("text", x = mediana, y = Inf, label = paste0("Mediana: ", fmt(mediana)),
               vjust = 2, hjust = -0.1, color = "darkred") +
      annotate("text", x = medie, y = Inf, label = paste0("Media: ", fmt(medie)),
               vjust = 3.5, hjust = -0.1, color = "darkgreen") +
      scale_x_continuous(breaks = marcaje_x,
                         labels = function(x) {
                           etichete <- format(round(x), big.mark = ",")
                           etichete[abs(x - limita_99) < 1e-3] <- paste0(">", etichete[abs(x - limita_99) < 1e-3])
                           etichete
                         },
                         limits = c(pret_minim, limita_99), expand = c(0, 0)) +
      scale_y_continuous(breaks = function(x) pretty(x, n = 10),
                         labels = function(x) format(x, big.mark = ",")) +
      labs(x = "Pret (EUR)", y = "Nr. masini") +
      tema_plot()
  })

  output$year_dist_plot <- renderPlot({
    date <- car_data(); req(nrow(date) > 0)

    min_an <- min(date$year[date$year <= 2023], na.rm = TRUE)
    prag <- max(as.integer(quantile(date$year[date$year <= 2023], 0.01, na.rm = TRUE)), min_an)
    are_grup <- prag > min_an
    grup_eticheta <- if (are_grup) paste("Sub", prag) else as.character(prag)
    grupuri <- c(if (are_grup) grup_eticheta, as.character(prag:2023))

    date_grafic <- date %>%
      filter(year <= 2023) %>%
      mutate(year_group = factor(
        if_else(year < prag, grup_eticheta, as.character(year)),
        levels = grupuri
      )) %>%
      filter(!is.na(year_group)) %>%
      count(year_group, .drop = FALSE)

    numar_max <- max(date_grafic$n, na.rm = TRUE)
    ani_mijloc <- if (prag + 1 <= 2021) as.character(seq(prag + 1, 2021, by = 2)) else character(0)
    marcaje_x <- c(grup_eticheta, ani_mijloc, "2023")

    date_grafic %>%
      ggplot(aes(x = year_group, y = n)) +
      geom_col(fill = culori_piete[[input$piata]], color = "white", width = 0.8) +
      geom_text(aes(label = ifelse(n > 0, format(n, big.mark = ","), "")),
                angle = 90, hjust = -0.1, size = 2.8, na.rm = TRUE) +
      scale_x_discrete(breaks = marcaje_x) +
      scale_y_continuous(breaks = breaks_cu_max(numar_max),
                         labels = function(x) format(round(x), big.mark = ","),
                         limits = c(0, numar_max), expand = c(0, 0)) +
      coord_cartesian(clip = "off") +
      labs(x = "An Fabricatie", y = "Nr. masini") +
      tema_plot(top = 35, right = 15)
  })

  bar_plot <- function(date, coloana, eticheta_y = "Nr. listari", top_n = 10) {
    date_grafic <- date %>%
      count(.data[[coloana]], sort = TRUE) %>%
      slice_max(n, n = top_n, with_ties = FALSE)
    valoare_max <- max(date_grafic$n, na.rm = TRUE)

    date_grafic %>%
      ggplot(aes(x = reorder(.data[[coloana]], n), y = n)) +
      geom_col(fill = culori_piete[[input$piata]], width = 0.7) +
      geom_text(aes(label = format(n, big.mark = ",")), hjust = -0.1, size = 3.8) +
      coord_flip(clip = "off") +
      scale_y_continuous(breaks = breaks_cu_max(valoare_max),
                         labels = function(x) format(round(x), big.mark = ","),
                         limits = c(0, valoare_max), expand = c(0, 0)) +
      labs(x = "", y = eticheta_y) +
      tema_plot(right = 55)
  }

  output$models_plot <- renderPlot({
    date <- car_data(); req(nrow(date) > 0)
    coloana <- if (input$brand == "Toate Brandurile") "brand" else "model"
    eticheta <- if (input$brand == "Toate Brandurile") "Top 5 Branduri" else "Top 5 Modele"
    bar_plot(date, coloana, eticheta, top_n = 5)
  })
  output$trans_plot <- renderPlot({ date <- car_data(); req(nrow(date) > 0); bar_plot(date, "transmission_type") })
  output$fuel_plot <- renderPlot({ date <- car_data(); req(nrow(date) > 0); bar_plot(date, "fuel_type") })

  output$india_extra_plot <- renderPlot({
    date <- car_data()
    validate(need("body_type" %in% names(date), "Lipsa coloana"))
    date_filtrate <- date %>% filter(!is.na(body_type), body_type != "")
    validate(need(nrow(date_filtrate) > 0, "Fara date"))
    bar_plot(date_filtrate, "body_type", "Nr. masini")
  })

  output$sua_drivetrain_plot <- renderPlot({
    date <- car_data()
    validate(need("drivetrain" %in% names(date), "Lipsa coloana"))
    date_filtrate <- date %>% filter(!is.na(drivetrain), drivetrain != "", drivetrain != "Unknown")
    validate(need(nrow(date_filtrate) > 0, "Fara date"))
    bar_plot(date_filtrate, "drivetrain", "Nr. masini")
  })

  output$sua_owner_plot <- renderPlot({
    date <- car_data()
    validate(need("one_owner" %in% names(date), "Lipsa coloana"))

    date_grafic <- date %>%
      filter(!is.na(one_owner), one_owner != "", one_owner != "Unknown") %>%
      count(one_owner)
    validate(need(nrow(date_grafic) > 0, "Fara date"))
    valoare_max <- max(date_grafic$n, na.rm = TRUE)

    date_grafic %>%
      ggplot(aes(x = one_owner, y = n, fill = one_owner)) +
      geom_col(width = 0.55, show.legend = FALSE) +
      geom_text(aes(label = format(n, big.mark = ",")), vjust = -0.5, size = 4) +
      scale_fill_manual(values = c("Yes" = "darkgreen", "No" = "darkred")) +
      scale_y_continuous(breaks = breaks_cu_max(valoare_max),
                         labels = function(x) format(round(x), big.mark = ","),
                         limits = c(0, valoare_max), expand = c(0, 0)) +
      labs(x = "Un singur proprietar?", y = "Nr. masini") +
      tema_plot(top = 35, right = 15)
  })

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


  # --- PREDICTOR: helper-e si stari reactive ---

  get_avg <- function(date, coloana, marca, model_ales, combustibil = NULL) {
    if (!is.null(combustibil) &&
      combustibil == "Electric" &&
      coloana %in% c("engine_type", "fuel_consumption_l_100km", "co2_g")) return(0)

    media <- function(d) d %>%
      summarise(mean(.data[[coloana]], na.rm = TRUE)) %>%
      pull()

    rezultat <- date %>%
      filter(brand == marca, model == model_ales,
             !is.na(.data[[coloana]]), .data[[coloana]] > 0) %>%
      media()
    if (!is.na(rezultat) && rezultat > 0) return(rezultat)

    rezultat <- date %>%
      filter(brand == marca,
             !is.na(.data[[coloana]]), .data[[coloana]] > 0) %>%
      media()
    if (!is.na(rezultat) && rezultat > 0) return(rezultat)

    mean(date[[coloana]], na.rm = TRUE)
  }

  get_mode <- function(date, coloana, marca, model_ales) {

    cel_mai_frecvent <- function(d) d %>%
      count(.data[[coloana]]) %>%
      slice_max(n, n = 1, with_ties = FALSE) %>%
      pull(.data[[coloana]])

    rezultat <- date %>%
      filter(brand == marca, model == model_ales,
             !is.na(.data[[coloana]]), .data[[coloana]] != "") %>%
      cel_mai_frecvent()
    if (length(rezultat) > 0) return(as.character(rezultat))

    rezultat <- date %>%
      filter(brand == marca,
             !is.na(.data[[coloana]]), .data[[coloana]] != "") %>%
      cel_mai_frecvent()
    if (length(rezultat) > 0) return(as.character(rezultat))

    as.character(date %>%
                   filter(!is.na(.data[[coloana]]), .data[[coloana]] != "") %>%
                   cel_mai_frecvent())
  }

  val_num <- function(piata, nume, date, coloana, marca, model_ales, combustibil = NULL) {
    if (isTRUE(input[[paste0("pred_", piata, "_use_", nume)]])) {
      as.numeric(input[[paste0("pred_", piata, "_", nume)]])
    } else get_avg(date, coloana, marca, model_ales, combustibil)
  }

  val_cat <- function(piata, nume, date, coloana, marca, model_ales) {
    if (isTRUE(input[[paste0("pred_", piata, "_use_", nume)]])) {
      input[[paste0("pred_", piata, "_", nume)]]
    } else get_mode(date, coloana, marca, model_ales)
  }

  verifica_model <- function(model_antrenat) {
    if (is.null(model_antrenat)) {
      showNotification("Antreneaza modelul mai intai (butonul portocaliu)!",
                       type = "warning", duration = 5)
      return(FALSE)
    }
    TRUE
  }

  result_box <- function(predictie) {
    if (is.null(predictie)) return(NULL)
    valueBox(
      paste0(fmt(predictie$med), " EUR"),
      paste0("Interval +/- 10%: ", fmt(predictie$low), " - ", fmt(predictie$high), " EUR"),
      icon = icon("euro-sign"), color = "green", width = 12
    )
  }

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

  register_model_dropdown <- function(piata, date_piata) {
    output[[paste0("pred_", piata, "_model_ui")]] <- renderUI({
      marca_aleasa <- input[[paste0("pred_", piata, "_brand")]]
      req(marca_aleasa)
      modele <- date_piata %>%
        filter(brand == marca_aleasa, !is.na(model), model != "") %>%
        pull(model) %>%
        unique() %>%
        sort()
      selectInput(paste0("pred_", piata, "_model"), "Model:",
                  choices = modele)
    })
  }

  register_model_dropdown("ger", germany_data)
  register_model_dropdown("ind", india_data)
  register_model_dropdown("sua", sua_data)


  # --- GERMANIA ---

  observeEvent(input$train_ger, {
    antreneaza_piata("Germania", germany_data,
                     coloane_pastrate = c("price_in_euro", "km", "year", "power_ps", "engine_type",
                                          "brand", "model", "fuel_type", "transmission_type",
                                          "co2_g", "fuel_consumption_l_100km"),
                     coloane_factor = c("brand", "model", "fuel_type", "transmission_type"),
                     nr_arbori = 300,
                     model_rv = model_ger, levels_rv = levels_ger, status_rv = status_ger)
  })

  observeEvent(input$pred_ger_btn, {
    if (!verifica_model(model_ger())) return()
    req(input$pred_ger_model)

    nivele <- levels_ger()
    date_piata <- germany_data
    marca <- input$pred_ger_brand
    model_ales <- input$pred_ger_model
    combustibil <- input$pred_ger_fuel

    ps_val <- val_num("ger", "ps", date_piata, "power_ps", marca, model_ales, combustibil)
    engine_val <- val_num("ger", "engine", date_piata, "engine_type", marca, model_ales, combustibil)
    cons_val <- val_num("ger", "cons", date_piata, "fuel_consumption_l_100km", marca, model_ales, combustibil)
    co2_val <- val_num("ger", "co2", date_piata, "co2_g", marca, model_ales, combustibil)
    if (combustibil == "Electric") engine_val <- 0

    km_total <- as.numeric(input$pred_ger_km)
    year_input <- as.integer(input$pred_ger_year)
    year_clamped <- pmax(1995, pmin(2026, year_input))
    age_val <- as.integer(2026 - year_clamped)  # 2026 (an curent), nu 2023: proiectam deprecierea pana azi

    date_noi <- data.frame(
      km = km_total,
      age = age_val,
      power_ps = ps_val,
      engine_type = engine_val,
      fuel_consumption_l_100km = cons_val,
      co2_g = co2_val,
      brand = factor(marca, levels = nivele$brand),
      model = factor(model_ales, levels = nivele$model),
      fuel_type = factor(combustibil, levels = nivele$fuel_type),
      transmission_type = factor(input$pred_ger_trans, levels = nivele$transmission_type)
    )
    prezice_pret(model_ger(), date_noi, pred_ger)
  })


  # --- INDIA ---

  observeEvent(input$train_ind, {
    antreneaza_piata("India", india_data,
                     coloane_pastrate = c("price_in_euro", "km", "year", "power_ps", "engine_type",
                                          "brand", "model", "fuel_type", "transmission_type",
                                          "body_type", "fuel_consumption_l_100km", "one_owner",
                                          "drivetrain", "seller_type"),
                     coloane_factor = c("brand", "model", "fuel_type", "transmission_type", "body_type",
                                        "one_owner", "drivetrain", "seller_type"),
                     nr_arbori = 500,
                     model_rv = model_ind, levels_rv = levels_ind, status_rv = status_ind)
  })

  observeEvent(input$pred_ind_btn, {
    if (!verifica_model(model_ind())) return()
    req(input$pred_ind_model)

    nivele <- levels_ind()
    date_piata <- india_data
    marca <- input$pred_ind_brand
    model_ales <- input$pred_ind_model
    combustibil <- input$pred_ind_fuel

    ps_val <- val_num("ind", "ps", date_piata, "power_ps", marca, model_ales, combustibil)
    engine_val <- val_num("ind", "engine", date_piata, "engine_type", marca, model_ales, combustibil)
    cons_val <- val_num("ind", "cons", date_piata, "fuel_consumption_l_100km", marca, model_ales, combustibil)
    body_val <- val_cat("ind", "body", date_piata, "body_type", marca, model_ales)
    owner_val <- val_cat("ind", "owner", date_piata, "one_owner", marca, model_ales)
    drive_val <- val_cat("ind", "drive", date_piata, "drivetrain", marca, model_ales)
    seller_val <- val_cat("ind", "seller", date_piata, "seller_type", marca, model_ales)
    if (combustibil == "Electric") engine_val <- 0

    km_total <- as.numeric(input$pred_ind_km)
    year_input <- as.integer(input$pred_ind_year)
    year_clamped <- pmax(1983, pmin(2026, year_input))
    age_val <- as.integer(2026 - year_clamped)  # 2026 (an curent), nu 2023: proiectam deprecierea pana azi

    date_noi <- data.frame(
      km = km_total,
      age = age_val,
      power_ps = ps_val,
      engine_type = engine_val,
      fuel_consumption_l_100km = cons_val,
      brand = factor(marca, levels = nivele$brand),
      model = factor(model_ales, levels = nivele$model),
      fuel_type = factor(combustibil, levels = nivele$fuel_type),
      transmission_type = factor(input$pred_ind_trans, levels = nivele$transmission_type),
      body_type = factor(body_val, levels = nivele$body_type),
      one_owner = factor(owner_val, levels = nivele$one_owner),
      drivetrain = factor(drive_val, levels = nivele$drivetrain),
      seller_type = factor(seller_val, levels = nivele$seller_type)
    )
    prezice_pret(model_ind(), date_noi, pred_ind)
  })


  # --- SUA ---

  observeEvent(input$train_sua, {
    antreneaza_piata("SUA", sua_data,
                     coloane_pastrate = c("price_in_euro", "km", "year", "engine_type",
                                          "brand", "model", "fuel_type", "transmission_type",
                                          "drivetrain", "one_owner", "fuel_consumption_l_100km"),
                     coloane_factor = c("brand", "model", "fuel_type", "transmission_type", "drivetrain", "one_owner"),
                     nr_arbori = 200,
                     model_rv = model_sua, levels_rv = levels_sua, status_rv = status_sua,
                     filtru = function(d) d %>% filter(one_owner %in% c("Yes", "No")))
  })

  observeEvent(input$pred_sua_btn, {
    if (!verifica_model(model_sua())) return()
    req(input$pred_sua_model)

    nivele <- levels_sua()
    date_piata <- sua_data
    marca <- input$pred_sua_brand
    model_ales <- input$pred_sua_model
    combustibil <- input$pred_sua_fuel

    engine_val <- val_num("sua", "engine", date_piata, "engine_type", marca, model_ales, combustibil)
    cons_val <- val_num("sua", "cons", date_piata, "fuel_consumption_l_100km", marca, model_ales, combustibil)
    drive_val <- val_cat("sua", "drive", date_piata, "drivetrain", marca, model_ales)
    owner_val <- val_cat("sua", "owner", date_piata, "one_owner", marca, model_ales)
    if (combustibil == "Electric") engine_val <- 0

    km_total <- as.numeric(input$pred_sua_km)
    year_input <- as.integer(input$pred_sua_year)
    year_clamped <- pmax(1915, pmin(2026, year_input))
    age_val <- as.integer(2026 - year_clamped)  # 2026 (an curent), nu 2023: proiectam deprecierea pana azi

    date_noi <- data.frame(
      km = km_total,
      age = age_val,
      engine_type = engine_val,
      fuel_consumption_l_100km = cons_val,
      brand = factor(marca, levels = nivele$brand),
      model = factor(model_ales, levels = nivele$model),
      fuel_type = factor(combustibil, levels = nivele$fuel_type),
      transmission_type = factor(input$pred_sua_trans, levels = nivele$transmission_type),
      drivetrain = factor(drive_val, levels = nivele$drivetrain),
      one_owner = factor(owner_val, levels = nivele$one_owner)
    )
    prezice_pret(model_sua(), date_noi, pred_sua)
  })

}

shinyApp(ui = ui, server = server)
