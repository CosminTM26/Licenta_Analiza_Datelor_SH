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


# ==============================================================================
# HELPER COMUNI (folosite atat de Dashboard cat si de Predictor)
# ==============================================================================

DB <- "identifier.sqlite"

# Formatare numere cu separator de mii
fmt <- function(x) {
  if (is.na(x) || is.nan(x)) return("N/A")
  format(round(x), big.mark = ",")
}

# Mapare piata -> tabel SQLite
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

# Preincarca valori pentru selectInput-urile din predictor (la pornire)
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
# UI
# ==============================================================================

ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Dashboard Auto SH"),

  dashboardSidebar(
    sidebarMenu(id = "main_menu",
                menuItem("Dashboard", tabName = "dashboard", icon = icon("chart-bar")),
                menuItem("Predictor Pret", tabName = "predictor", icon = icon("calculator"))
    ),
    hr(),
    selectInput("piata", "Selecteaza Piata:",
                choices = c("SUA", "Germania", "India"), selected = "Germania"),
    uiOutput("brand_selector")
  ),

  dashboardBody(
    # Spacing pentru o vizualizare mai aerisita
    tags$head(tags$style(HTML("
      .content-wrapper { padding: 20px; }
      .box { margin-bottom: 25px; }
      .row { margin-bottom: 10px; }
      .small-box, .info-box { margin-bottom: 20px; }
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
      tabItem(tabName = "predictor",
              h2("Predictor Pret (Random Forest)"),
              tabsetPanel(

                tabPanel("Germania",
                         fluidRow(
                           column(6,
                                  selectInput("pred_ger_brand", "Brand:", choices = ger_brands),
                                  uiOutput("pred_ger_model_ui"),
                                  numericInput("pred_ger_km", "Kilometraj (km):", value = 100000, min = 0, step = 10000),
                                  numericInput("pred_ger_year", "An fabricatie:", value = 2015),
                                  selectInput("pred_ger_fuel", "Combustibil:", choices = ger_fuels),
                                  selectInput("pred_ger_trans", "Transmisie:", choices = ger_trans),

                                  checkboxInput("pred_ger_use_ps", "Specific Putere (PS)", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ger_use_ps == true",
                                    numericInput("pred_ger_ps", "Putere (PS):", value = 120, min = 1, max = 1000)
                                  ),

                                  checkboxInput("pred_ger_use_engine", "Specific Capacitate cilindrica (L)", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ger_use_engine == true",
                                    numericInput("pred_ger_engine", "Capacitate cilindrica (L):", value = 1.6, min = 0.5, step = 0.1)
                                  ),

                                  checkboxInput("pred_ger_use_cons", "Specific Consum", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ger_use_cons == true",
                                    numericInput("pred_ger_consumption", "Consum (l/100km):", value = 6.0, min = 1, step = 0.1)
                                  ),

                                  checkboxInput("pred_ger_use_co2", "Specific Emisii CO2", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ger_use_co2 == true",
                                    numericInput("pred_ger_co2", "Emisii CO2 (g/km):", value = 140, min = 0)
                                  )
                           ),
                           column(6,
                                  actionButton("train_ger", "Antreneaza Model", icon = icon("cogs"),
                                               class = "btn-warning btn-block"),
                                  br(),
                                  verbatimTextOutput("train_ger_status", placeholder = TRUE),
                                  actionButton("pred_ger_btn", "Calculeaza Pret", icon = icon("calculator"),
                                               class = "btn-success btn-block"),
                                  uiOutput("pred_ger_result")
                           )
                         )
                ),

                tabPanel("India",
                         fluidRow(
                           column(6,
                                  selectInput("pred_ind_brand", "Brand:", choices = ind_brands),
                                  uiOutput("pred_ind_model_ui"),
                                  numericInput("pred_ind_km", "Kilometraj (km):", value = 60000, min = 0, step = 10000),
                                  numericInput("pred_ind_year", "An fabricatie:", value = 2018),
                                  selectInput("pred_ind_fuel", "Combustibil:", choices = ind_fuels),
                                  selectInput("pred_ind_trans", "Transmisie:", choices = ind_trans),

                                  checkboxInput("pred_ind_use_ps", "Specific Putere (PS)", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ind_use_ps == true",
                                    numericInput("pred_ind_ps", "Putere (PS):", value = 80, min = 1, max = 500)
                                  ),

                                  checkboxInput("pred_ind_use_engine", "Specific Capacitate cilindrica (L)", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ind_use_engine == true",
                                    numericInput("pred_ind_engine", "Capacitate cilindrica (L):", value = 1.5, min = 0.5, step = 0.1)
                                  ),

                                  checkboxInput("pred_ind_use_body", "Specific Tip caroserie", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ind_use_body == true",
                                    selectInput("pred_ind_body", "Tip caroserie:", choices = ind_body)
                                  ),

                                  checkboxInput("pred_ind_use_cons", "Specific Consum", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ind_use_cons == true",
                                    numericInput("pred_ind_consumption", "Consum (l/100km):", value = 5.4, min = 1, step = 0.1)
                                  ),

                                  checkboxInput("pred_ind_use_owner", "Specific Proprietar unic", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ind_use_owner == true",
                                    selectInput("pred_ind_owner", "Un proprietar:", choices = c("Yes", "No"))
                                  ),

                                  checkboxInput("pred_ind_use_drive", "Specific Tractiune", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ind_use_drive == true",
                                    selectInput("pred_ind_drive", "Tractiune:", choices = ind_drive)
                                  ),

                                  checkboxInput("pred_ind_use_seller", "Specific Tip vanzator", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ind_use_seller == true",
                                    selectInput("pred_ind_seller", "Tip vanzator:", choices = ind_seller)
                                  ),

                                  checkboxInput("pred_ind_use_state", "Specific Stat", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_ind_use_state == true",
                                    selectInput("pred_ind_state", "Stat:", choices = ind_states)
                                  )
                           ),
                           column(6,
                                  actionButton("train_ind", "Antreneaza Model", icon = icon("cogs"),
                                               class = "btn-warning btn-block"),
                                  br(),
                                  verbatimTextOutput("train_ind_status", placeholder = TRUE),
                                  actionButton("pred_ind_btn", "Calculeaza Pret", icon = icon("calculator"),
                                               class = "btn-success btn-block"),
                                  uiOutput("pred_ind_result")
                           )
                         )
                ),

                tabPanel("SUA",
                         fluidRow(
                           column(6,
                                  selectInput("pred_sua_brand", "Brand:", choices = sua_brands),
                                  uiOutput("pred_sua_model_ui"),
                                  numericInput("pred_sua_km", "Kilometraj (km):", value = 80000, min = 0, step = 10000),
                                  numericInput("pred_sua_year", "An fabricatie:", value = 2017),
                                  selectInput("pred_sua_fuel", "Combustibil:", choices = sua_fuels),
                                  selectInput("pred_sua_trans", "Transmisie:", choices = sua_trans),

                                  checkboxInput("pred_sua_use_engine", "Specific Capacitate cilindrica (L)", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_sua_use_engine == true",
                                    numericInput("pred_sua_engine", "Capacitate cilindrica (L):", value = 2.5, min = 0.5, step = 0.1)
                                  ),

                                  checkboxInput("pred_sua_use_cons", "Specific Consum", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_sua_use_cons == true",
                                    numericInput("pred_sua_consumption", "Consum (l/100km):", value = 10.1, min = 1, step = 0.1)
                                  ),

                                  checkboxInput("pred_sua_use_drive", "Specific Tractiune", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_sua_use_drive == true",
                                    selectInput("pred_sua_drive", "Tractiune:", choices = sua_drive)
                                  ),

                                  checkboxInput("pred_sua_use_owner", "Specific Proprietar unic", value = FALSE),
                                  conditionalPanel(
                                    condition = "input.pred_sua_use_owner == true",
                                    selectInput("pred_sua_owner", "Un singur proprietar:", choices = c("Yes", "No"))
                                  )
                           ),
                           column(6,
                                  actionButton("train_sua", "Antreneaza Model", icon = icon("cogs"),
                                               class = "btn-warning btn-block"),
                                  br(),
                                  verbatimTextOutput("train_sua_status", placeholder = TRUE),
                                  actionButton("pred_sua_btn", "Calculeaza Pret", icon = icon("calculator"),
                                               class = "btn-success btn-block"),
                                  uiOutput("pred_sua_result")
                           )
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

  # Selector dinamic brand (depinde de piata)
  output$brand_selector <- renderUI({
    req(input$piata)
    con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))
    brands <- dbGetQuery(con, paste0(
      "SELECT DISTINCT brand FROM `", tabel_piata(input$piata), "` ORDER BY brand"))$brand
    selectInput("brand", "Selecteaza Brand:",
                c("Toate Brandurile", brands), "Toate Brandurile")
  })

  # Sursa reactiva de date pentru dashboard
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

  # Sufix KPI ("Piata" cand toate brandurile, "Brand" altfel)
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

  # Distributia preturilor (histograma)
  output$price_dist_plot <- renderPlot({
    df <- car_data(); req(nrow(df) > 0)
    med <- median(df$price_in_euro, na.rm = TRUE)
    avg <- mean(df$price_in_euro, na.rm = TRUE)
    lim <- quantile(df$price_in_euro, 0.98, na.rm = TRUE)
    ggplot(df, aes(x = price_in_euro)) +
      geom_histogram(fill = "steelblue", bins = 80, na.rm = TRUE) +
      geom_vline(xintercept = med, color = "darkred", linetype = "dashed", linewidth = 0.9) +
      geom_vline(xintercept = avg, color = "darkgreen", linetype = "dotted", linewidth = 0.9) +
      annotate("text", x = med, y = Inf, label = paste0("Mediana: ", fmt(med)),
               vjust = 2, hjust = -0.1, color = "darkred") +
      annotate("text", x = avg, y = Inf, label = paste0("Media: ", fmt(avg)),
               vjust = 3.5, hjust = -0.1, color = "darkgreen") +
      scale_x_continuous(labels = function(x) format(x, big.mark = ","),
                         limits = c(0, lim), expand = c(0, 0)) +
      scale_y_continuous(labels = function(x) format(x, big.mark = ",")) +
      labs(x = "Pret (EUR)", y = "Nr. masini") +
      theme_minimal(base_size = 13)
  })

  # Distributia anilor (histograma cu etichete verticale)
  output$year_dist_plot <- renderPlot({
    df <- car_data(); req(nrow(df) > 0)
    df_f <- df %>% filter(year <= 2023)
    an_min <- max(min(df_f$year, na.rm = TRUE), 1985)
    ggplot(df_f, aes(x = year)) +
      geom_histogram(binwidth = 1, fill = "darkorange", color = "white") +
      geom_text(stat = "bin", binwidth = 1,
                aes(label = after_stat(ifelse(count > 0, format(count, big.mark = ","), ""))),
                angle = 90, hjust = -0.1, size = 2.8, na.rm = TRUE) +
      scale_x_continuous(breaks = seq(1985, 2023, by = 5)) +
      scale_y_continuous(labels = function(x) format(x, big.mark = ","),
                         expand = expansion(mult = c(0, 0.35))) +
      coord_cartesian(xlim = c(an_min, 2023), clip = "off") +
      labs(x = "An Fabricatie", y = "Nr. masini") +
      theme_minimal(base_size = 13)
  })

  # Helper: bar plot orizontal cu numere (top N)
  bar_plot <- function(df, col, y_label = "Nr. listari", n_top = 10) {
    df %>%
      count(.data[[col]]) %>%
      top_n(n_top, n) %>%
      ggplot(aes(x = reorder(.data[[col]], n), y = n)) +
      geom_col(fill = "steelblue", width = 0.7) +
      geom_text(aes(label = format(n, big.mark = ",")), hjust = -0.1, size = 3.8) +
      coord_flip(clip = "off") +
      scale_y_continuous(labels = function(x) format(x, big.mark = ","),
                         expand = expansion(mult = c(0, 0.25))) +
      labs(x = "", y = y_label) +
      theme_minimal(base_size = 13)
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
    df_p %>%
      count(one_owner) %>%
      ggplot(aes(x = one_owner, y = n, fill = one_owner)) +
      geom_col(width = 0.55, show.legend = FALSE) +
      geom_text(aes(label = format(n, big.mark = ",")), vjust = -0.5, size = 4) +
      scale_fill_manual(values = c("Yes" = "darkgreen", "No" = "darkred")) +
      scale_y_continuous(labels = function(x) format(x, big.mark = ","),
                         expand = expansion(mult = c(0, 0.15))) +
      labs(x = "Un singur proprietar?", y = "Nr. masini") +
      theme_minimal(base_size = 13)
  })

  # Tab-uri dinamice per piata
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
                    list()
    )
    do.call(tabBox, c(list(width = 12), comune, extra))
  })

  # ============================================================================
  # ========================== PARTEA 2: PREDICTOR =============================
  # ============================================================================
  # Random Forest: Germania 300 arbori, India 500, SUA 200 | Interval ±10% in jurul medianei

  # Helper: lista modele pentru un brand (pentru dropdown reactiv)
  get_models <- function(tbl, brand) {
    con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))
    dbGetQuery(con, paste0(
      "SELECT DISTINCT model FROM `", tbl,
      "` WHERE brand = ? AND model IS NOT NULL AND model != '' ORDER BY model"
    ), params = list(brand))$model
  }

  # Helper: calculeaza media unei valori din baza de date pentru imputare la predictie (daca utilizatorul nu o specifica)
  get_db_avg <- function(tbl, col, brand, model, fuel_type, fallback_val) {
    if (!is.null(fuel_type) &&
      fuel_type == "Electric" &&
      col %in% c("engine_type", "fuel_consumption_l_100km", "co2_g")) return(0)
    con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))

    # Incercam dupa model + brand
    res <- dbGetQuery(con, paste0(
      "SELECT AVG(`", col, "`) FROM `", tbl, "` WHERE brand = ? AND model = ? AND `", col, "` IS NOT NULL AND `", col, "` > 0"
    ), params = list(brand, model))[[1]]
    if (!is.na(res) && length(res) > 0 && res > 0) return(res)

    # Incercam dupa brand
    res <- dbGetQuery(con, paste0(
      "SELECT AVG(`", col, "`) FROM `", tbl, "` WHERE brand = ? AND `", col, "` IS NOT NULL AND `", col, "` > 0"
    ), params = list(brand))[[1]]
    if (!is.na(res) && length(res) > 0 && res > 0) return(res)

    return(fallback_val)
  }

  # Helper: gaseste cel mai frecvent element (modul statistic) pentru o categorie din baza de date
  get_db_mode <- function(tbl, col, brand, model, fallback_val) {
    con <- dbConnect(RSQLite::SQLite(), DB); on.exit(dbDisconnect(con))

    # Incercam dupa model + brand
    res <- dbGetQuery(con, paste0(
      "SELECT `", col, "`, COUNT(*) as c FROM `", tbl, "` WHERE brand = ? AND model = ? AND `", col, "` IS NOT NULL AND `", col, "` != '' GROUP BY `", col, "` ORDER BY c DESC LIMIT 1"
    ), params = list(brand, model))[[1]]
    if (length(res) > 0 && !is.na(res) && res != "") return(res)

    # Incercam dupa brand
    res <- dbGetQuery(con, paste0(
      "SELECT `", col, "`, COUNT(*) as c FROM `", tbl, "` WHERE brand = ? AND `", col, "` IS NOT NULL AND `", col, "` != '' GROUP BY `", col, "` ORDER BY c DESC LIMIT 1"
    ), params = list(brand))[[1]]
    if (length(res) > 0 && !is.na(res) && res != "") return(res)

    return(fallback_val)
  }

  train_rf <- function(df, factor_cols, n_trees, model_rv, levels_rv, status_rv) {
    # 1. Corectie electrici (engine_type = 0 pentru electrice) si Feature Engineering (age = 2023 - year)
    df <- df %>%
      mutate(engine_type = ifelse(fuel_type == "Electric", 0, engine_type),
             age = 2023 - year) %>%
      select(-year)

    # Corectie electrici pentru consum si co2 (daca exista in setul de date)
    if ("fuel_consumption_l_100km" %in% names(df)) {
      df <- df %>% mutate(fuel_consumption_l_100km = ifelse(fuel_type == "Electric", 0, fuel_consumption_l_100km))
    }
    if ("co2_g" %in% names(df)) {
      df <- df %>% mutate(co2_g = ifelse(fuel_type == "Electric", 0, co2_g))
    }

    # Imputare ierarhica engine_type (daca exista)
    if ("engine_type" %in% names(df)) {
      df <- df %>%
        group_by(brand, model) %>%
        mutate(engine_type = ifelse(
          is.na(engine_type),
          median(engine_type, na.rm = TRUE),
          engine_type
        )) %>%
        ungroup()
      global_eng <- median(df$engine_type, na.rm = TRUE)
      if (is.na(global_eng)) global_eng <- 1.6
      df <- df %>%
        mutate(engine_type = ifelse(is.na(engine_type), global_eng, engine_type))
    }

    # Imputare ierarhica consum (daca exista)
    if ("fuel_consumption_l_100km" %in% names(df)) {
      df <- df %>%
        group_by(brand, model) %>%
        mutate(fuel_consumption_l_100km = ifelse(
          is.na(fuel_consumption_l_100km),
          median(fuel_consumption_l_100km, na.rm = TRUE),
          fuel_consumption_l_100km
        )) %>%
        ungroup()
      global_cons <- median(df$fuel_consumption_l_100km, na.rm = TRUE)
      if (is.na(global_cons)) global_cons <- 6.0
      df <- df %>%
        mutate(fuel_consumption_l_100km = ifelse(is.na(fuel_consumption_l_100km), global_cons, fuel_consumption_l_100km))
    }

    # Imputare ierarhica co2 (daca exista)
    if ("co2_g" %in% names(df)) {
      df <- df %>%
        group_by(brand, model) %>%
        mutate(co2_g = ifelse(
          is.na(co2_g),
          median(co2_g, na.rm = TRUE),
          co2_g
        )) %>%
        ungroup()
      global_co2 <- median(df$co2_g, na.rm = TRUE)
      if (is.na(global_co2)) global_co2 <- 146.0
      df <- df %>%
        mutate(co2_g = ifelse(is.na(co2_g), global_co2, co2_g))
    }

    # 2. Doar randuri valide (outliers deja eliminati in pasul SQL de curatare)
    df <- df %>%
      filter(!is.na(price_in_euro), price_in_euro > 0) %>%
      drop_na()
    # 3. Transforma textul in factori
    for (c in factor_cols) df[[c]] <- as.factor(df[[c]])
    # 4. Antreneaza Random Forest cu hyperparametrii din studii
    # respect.unordered.factors = "order" realizeaza un Target Encoding nativ la nivel de C++ (ordoneaza nivelele marcii/modelului dupa pretul mediu, conform Wright & Konig, 2019)
    # quantreg = TRUE: salveaza predictia fiecarui arbore -> putem cere mediana
    m <- ranger(price_in_euro ~ ., data = df,
                num.trees = n_trees, max.depth = 20, min.node.size = 2,
                quantreg = TRUE, importance = "impurity",
                respect.unordered.factors = "order", seed = 42, verbose = FALSE)
    model_rv(m)
    # 5. Salveaza nivelele factor (necesare la predictie)
    lv <- list()
    for (c in factor_cols) lv[[c]] <- levels(df[[c]])
    levels_rv(lv)
    # 6. Status: R² OOB, top caracteristici cu impact
    r2 <- round(1 - m$prediction.error / var(df$price_in_euro), 3)
    imp <- sort(importance(m), decreasing = TRUE)
    pct <- round(100 * imp / sum(imp), 1)
    imp_str <- paste(names(pct), paste0(pct, "%"), sep = ": ", collapse = " | ")
    status_rv(paste0(
      "Antrenat pe ", fmt(nrow(df)), " masini (", n_trees, " arbori). R² OOB = ", r2,
      "\nCum decide modelul: ", imp_str
    ))
  }

  # Helper: caseta verde cu rezultatul predictiei
  result_box <- function(p) {
    if (is.null(p)) return(NULL)
    valueBox(
      paste0(fmt(p$med), " EUR"),
      paste0("Interval +/- 10%: ", fmt(p$low), " - ", fmt(p$high), " EUR"),
      icon = icon("euro-sign"), color = "green", width = 12
    )
  }

  # Stari reactive (model antrenat, nivele factor, predictie, status, extra)
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

  # Dropdown-uri model (se reactualizeaza cand schimbi brandul)
  output$pred_ger_model_ui <- renderUI({
    req(input$pred_ger_brand)
    selectInput("pred_ger_model", "Model:",
                choices = get_models("Germany_Cars_Cleaned", input$pred_ger_brand))
  })
  output$pred_ind_model_ui <- renderUI({
    req(input$pred_ind_brand)
    selectInput("pred_ind_model", "Model:",
                choices = get_models("India_Cars_Cleaned", input$pred_ind_brand))
  })
  output$pred_sua_model_ui <- renderUI({
    req(input$pred_sua_brand)
    selectInput("pred_sua_model", "Model:",
                choices = get_models("SUA_Cars_Cleaned", input$pred_sua_brand))
  })

  # -------- GERMANIA: antreneaza + prezice --------
  observeEvent(input$train_ger, {
    withProgress(message = "Antrenare RF Germania (300 arbori)", value = NULL, {
      con <- dbConnect(RSQLite::SQLite(), DB)
      df <- dbGetQuery(con, paste(
        "SELECT price_in_euro, km, year, power_ps, engine_type, brand, model,",
        "fuel_type, transmission_type, co2_g, fuel_consumption_l_100km FROM Germany_Cars_Cleaned"))
      dbDisconnect(con)
      train_rf(df, c("brand", "model", "fuel_type", "transmission_type"),
               n_trees = 300, model_ger, levels_ger, status_ger)
    })
  })

  observeEvent(input$pred_ger_btn, {
    if (is.null(model_ger())) {
      showNotification("Antreneaza modelul mai intai (butonul portocaliu)!",
                       type = "warning", duration = 5); return()
    }
    req(input$pred_ger_model)
    lvl <- levels_ger()

    # Preiau valori manuale sau din baza de date
    ps_val <- if (input$pred_ger_use_ps) {
      as.numeric(input$pred_ger_ps)
    } else {
      get_db_avg("Germany_Cars_Cleaned", "power_ps",
                 input$pred_ger_brand, input$pred_ger_model, input$pred_ger_fuel, 120)
    }

    engine_val <- if (input$pred_ger_use_engine) {
      as.numeric(input$pred_ger_engine)
    } else {
      get_db_avg("Germany_Cars_Cleaned", "engine_type",
                 input$pred_ger_brand, input$pred_ger_model, input$pred_ger_fuel, 1.6)
    }
    if (input$pred_ger_fuel == "Electric") engine_val <- 0

    cons_val <- if (input$pred_ger_use_cons) {
      as.numeric(input$pred_ger_consumption)
    } else {
      get_db_avg("Germany_Cars_Cleaned", "fuel_consumption_l_100km",
                 input$pred_ger_brand, input$pred_ger_model, input$pred_ger_fuel, 6.1)
    }

    co2_val <- if (input$pred_ger_use_co2) {
      as.numeric(input$pred_ger_co2)
    } else {
      get_db_avg("Germany_Cars_Cleaned", "co2_g",
                 input$pred_ger_brand, input$pred_ger_model, input$pred_ger_fuel, 146.5)
    }

    date_noi <- data.frame(
      km = as.numeric(input$pred_ger_km),
      age = as.integer(2026 - input$pred_ger_year),
      power_ps = ps_val,
      engine_type = engine_val,
      fuel_consumption_l_100km = cons_val,
      co2_g = co2_val,
      brand = factor(input$pred_ger_brand, levels = lvl$brand),
      model = factor(input$pred_ger_model, levels = lvl$model),
      fuel_type = factor(input$pred_ger_fuel, levels = lvl$fuel_type),
      transmission_type = factor(input$pred_ger_trans, levels = lvl$transmission_type)
    )
    med <- predict(model_ger(), data = date_noi, type = "quantiles",
                   quantiles = 0.5)$predictions[1, 1]
    pred_ger(list(low = med * 0.9, med = med, high = med * 1.1))
  })

  # -------- INDIA: antreneaza + prezice --------
  observeEvent(input$train_ind, {
    withProgress(message = "Antrenare RF India (500 arbori)", value = NULL, {
      con <- dbConnect(RSQLite::SQLite(), DB)
      df <- dbGetQuery(con, paste(
        "SELECT price_in_euro, km, year, power_ps, engine_type, brand, model,",
        "fuel_type, transmission_type, body_type, fuel_consumption_l_100km,",
        "one_owner, drivetrain, seller_type, state FROM India_Cars_Cleaned"))
      dbDisconnect(con)
      train_rf(df, c("brand", "model", "fuel_type", "transmission_type", "body_type",
                     "one_owner", "drivetrain", "seller_type", "state"),
               n_trees = 500, model_ind, levels_ind, status_ind)
    })
  })

  observeEvent(input$pred_ind_btn, {
    if (is.null(model_ind())) {
      showNotification("Antreneaza modelul mai intai (butonul portocaliu)!",
                       type = "warning", duration = 5); return()
    }
    req(input$pred_ind_model)
    lvl <- levels_ind()

    # Obținere valori manuale sau din baza de date
    ps_val <- if (input$pred_ind_use_ps) {
      as.numeric(input$pred_ind_ps)
    } else {
      get_db_avg("India_Cars_Cleaned", "power_ps",
                 input$pred_ind_brand, input$pred_ind_model, input$pred_ind_fuel, 80)
    }

    engine_val <- if (input$pred_ind_use_engine) {
      as.numeric(input$pred_ind_engine)
    } else {
      get_db_avg("India_Cars_Cleaned", "engine_type",
                 input$pred_ind_brand, input$pred_ind_model, input$pred_ind_fuel, 1.5)
    }
    if (input$pred_ind_fuel == "Electric") engine_val <- 0

    cons_val <- if (input$pred_ind_use_cons) {
      as.numeric(input$pred_ind_consumption)
    } else {
      get_db_avg("India_Cars_Cleaned", "fuel_consumption_l_100km",
                 input$pred_ind_brand, input$pred_ind_model, input$pred_ind_fuel, 5.4)
    }

    body_val <- if (input$pred_ind_use_body) {
      input$pred_ind_body
    } else {
      get_db_mode("India_Cars_Cleaned", "body_type", input$pred_ind_brand, input$pred_ind_model, "Hatchback")
    }

    owner_val <- if (input$pred_ind_use_owner) {
      input$pred_ind_owner
    } else {
      get_db_mode("India_Cars_Cleaned", "one_owner", input$pred_ind_brand, input$pred_ind_model, "Yes")
    }

    drive_val <- if (input$pred_ind_use_drive) {
      input$pred_ind_drive
    } else {
      get_db_mode("India_Cars_Cleaned", "drivetrain", input$pred_ind_brand, input$pred_ind_model, "FWD")
    }

    seller_val <- if (input$pred_ind_use_seller) {
      input$pred_ind_seller
    } else {
      get_db_mode("India_Cars_Cleaned", "seller_type", input$pred_ind_brand, input$pred_ind_model, "Dealer")
    }

    state_val <- if (input$pred_ind_use_state) {
      input$pred_ind_state
    } else {
      get_db_mode("India_Cars_Cleaned", "state", input$pred_ind_brand, input$pred_ind_model, "delhi")
    }

    date_noi <- data.frame(
      km = as.numeric(input$pred_ind_km),
      age = as.integer(2026 - input$pred_ind_year),
      power_ps = ps_val,
      engine_type = engine_val,
      fuel_consumption_l_100km = cons_val,
      brand = factor(input$pred_ind_brand, levels = lvl$brand),
      model = factor(input$pred_ind_model, levels = lvl$model),
      fuel_type = factor(input$pred_ind_fuel, levels = lvl$fuel_type),
      transmission_type = factor(input$pred_ind_trans, levels = lvl$transmission_type),
      body_type = factor(body_val, levels = lvl$body_type),
      one_owner = factor(owner_val, levels = lvl$one_owner),
      drivetrain = factor(drive_val, levels = lvl$drivetrain),
      seller_type = factor(seller_val, levels = lvl$seller_type),
      state = factor(state_val, levels = lvl$state)
    )
    med <- predict(model_ind(), data = date_noi, type = "quantiles",
                   quantiles = 0.5)$predictions[1, 1]
    pred_ind(list(low = med * 0.9, med = med, high = med * 1.1))
  })

  # -------- SUA: antreneaza + prezice --------
  observeEvent(input$train_sua, {
    withProgress(message = "Antrenare RF SUA (200 arbori)", value = NULL, {
      con <- dbConnect(RSQLite::SQLite(), DB)
      df <- dbGetQuery(con, paste(
        "SELECT price_in_euro, km, year, engine_type, brand, model, fuel_type,",
        "transmission_type, drivetrain, one_owner, fuel_consumption_l_100km FROM SUA_Cars_Cleaned"))
      dbDisconnect(con)
      df <- df %>% filter(one_owner %in% c("Yes", "No"))
      train_rf(df, c("brand", "model", "fuel_type", "transmission_type",
                     "drivetrain", "one_owner"),
               n_trees = 200, model_sua, levels_sua, status_sua)
    })
  })

  observeEvent(input$pred_sua_btn, {
    if (is.null(model_sua())) {
      showNotification("Antreneaza modelul mai intai (butonul portocaliu)!",
                       type = "warning", duration = 5); return()
    }
    req(input$pred_sua_model)
    lvl <- levels_sua()

    # Obținere valori manuale sau din baza de date
    engine_val <- if (input$pred_sua_use_engine) {
      as.numeric(input$pred_sua_engine)
    } else {
      get_db_avg("SUA_Cars_Cleaned", "engine_type",
                 input$pred_sua_brand, input$pred_sua_model, input$pred_sua_fuel, 2.5)
    }
    if (input$pred_sua_fuel == "Electric") engine_val <- 0

    cons_val <- if (input$pred_sua_use_cons) {
      as.numeric(input$pred_sua_consumption)
    } else {
      get_db_avg("SUA_Cars_Cleaned", "fuel_consumption_l_100km",
                 input$pred_sua_brand, input$pred_sua_model, input$pred_sua_fuel, 10.1)
    }

    drive_val <- if (input$pred_sua_use_drive) {
      input$pred_sua_drive
    } else {
      get_db_mode("SUA_Cars_Cleaned", "drivetrain", input$pred_sua_brand, input$pred_sua_model, "FWD")
    }

    owner_val <- if (input$pred_sua_use_owner) {
      input$pred_sua_owner
    } else {
      get_db_mode("SUA_Cars_Cleaned", "one_owner", input$pred_sua_brand, input$pred_sua_model, "Yes")
    }

    date_noi <- data.frame(
      km = as.numeric(input$pred_sua_km),
      age = as.integer(2026 - input$pred_sua_year),
      engine_type = engine_val,
      fuel_consumption_l_100km = cons_val,
      brand = factor(input$pred_sua_brand, levels = lvl$brand),
      model = factor(input$pred_sua_model, levels = lvl$model),
      fuel_type = factor(input$pred_sua_fuel, levels = lvl$fuel_type),
      transmission_type = factor(input$pred_sua_trans, levels = lvl$transmission_type),
      drivetrain = factor(drive_val, levels = lvl$drivetrain),
      one_owner = factor(owner_val, levels = lvl$one_owner)
    )
    med <- predict(model_sua(), data = date_noi, type = "quantiles",
                   quantiles = 0.5)$predictions[1, 1]
    pred_sua(list(low = med * 0.9, med = med, high = med * 1.1))
  })

}

shinyApp(ui = ui, server = server)
