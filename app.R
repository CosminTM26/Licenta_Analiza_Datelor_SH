# ==============================================================================
# Proiect Licenta: Dashboard Shiny - Analiza autovehiculelor SH
# Autor: Cosmin
# ==============================================================================

library(shiny)
library(shinydashboard)
library(DBI)
library(RSQLite)
library(tidyverse)

options(scipen = 999)

# Formatare numere cu separator de mii
fmt <- function(x) {
  if (is.na(x) || is.nan(x)) return("N/A")
  format(round(x), big.mark = ",")
}

# Tema vizuala pentru grafice
tema <- function() {
  theme_minimal(base_size = 13) +
    theme(
      plot.background  = element_rect(fill = "#f7f9fc", color = NA),
      panel.background = element_rect(fill = "#ffffff", color = NA),
      panel.grid.major = element_line(color = "#dde3ec", linewidth = 0.4),
      panel.grid.minor = element_blank(),
      panel.border     = element_rect(color = "#dde3ec", fill = NA, linewidth = 0.5),
      axis.text        = element_text(color = "#4a5568"),
      axis.title       = element_text(color = "#2d3748", face = "bold"),
      plot.margin      = margin(10, 14, 10, 14),
      legend.position  = "none"
    )
}

# Paleta de culori pentru grafice categoriale
pal <- c("#2b6cb0", "#2f855a", "#b7791f", "#9b2c2c", "#553c9a",
         "#2c7a7b", "#c05621", "#285e61", "#744210", "#1a365d",
         "#276749", "#742a2a")

# Mapare piata -> tabel SQLite
tabel_piata <- function(piata) {
  switch(piata, "India" = "India_Cars_Cleaned",
         "Germania" = "Germany_Cars_Cleaned", "SUA" = "SUA_Cars_Cleaned")
}

# Citire branduri din baza de date
get_brands <- function(market) {
  tbl <- tabel_piata(market)
  if (!file.exists("identifier.sqlite")) return(character(0))
  con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
  on.exit(dbDisconnect(con))
  if (!dbExistsTable(con, tbl)) return(character(0))
  dbGetQuery(con, paste0("SELECT DISTINCT brand FROM `", tbl, "` ORDER BY brand"))$brand
}

# --- UI ---
ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Dashboard Auto SH"),
  dashboardSidebar(
    selectInput("piata", "Selecteaza Piata:",
                choices = c("SUA", "Germania", "India"), selected = "Germania"),
    uiOutput("brand_selector")
  ),
  dashboardBody(
    tags$head(tags$style(HTML("
      .box { border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
      .value-box { border-radius: 8px; }
    "))),
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
  )
)

# --- SERVER ---
server <- function(input, output, session) {
  
  # Selector dinamic brand
  output$brand_selector <- renderUI({
    req(input$piata)
    brands <- get_brands(input$piata)
    if (length(brands) == 0) return(p(style = "color:red;padding:15px;", "Eroare: Lipsa date."))
    selectInput("brand", "Selecteaza Brand:", c("Toate Brandurile", brands), "Toate Brandurile")
  })
  
  # Sursa reactiva de date
  car_data <- reactive({
    req(input$piata, input$brand)
    tbl <- tabel_piata(input$piata)
    if (!file.exists("identifier.sqlite")) return(data.frame())
    con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
    on.exit(dbDisconnect(con))
    if (!dbExistsTable(con, tbl)) return(data.frame())
    if (input$brand == "Toate Brandurile") {
      dbGetQuery(con, paste0("SELECT * FROM `", tbl, "`"))
    } else {
      dbGetQuery(con, paste0("SELECT * FROM `", tbl, "` WHERE brand = ?"), params = list(input$brand))
    }
  })
  
  # Titlu dinamic
  output$titlu_dinamic <- renderText({
    req(input$piata, input$brand)
    if (input$brand == "Toate Brandurile") paste("Analiza Generala:", input$piata)
    else paste("Analiza Brand:", input$brand, paste0("(", input$piata, ")"))
  })
  
  # Helper: suffix KPI
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
    valueBox(paste0(round(2026 - mean(df$year, na.rm = TRUE), 1), " ani"),
             paste("Varsta Medie", sfx()), icon = icon("calendar-alt"), color = "yellow")
  })
  output$kpi_pop_model <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    if (input$brand == "Toate Brandurile") {
      top <- df %>% count(brand) %>% arrange(desc(n))
      valueBox(if(nrow(top) > 0) top$brand[1] else "N/A", "Brand Popular", icon = icon("star"), color = "orange")
    } else {
      top <- df %>% count(model) %>% arrange(desc(n))
      valueBox(if(nrow(top) > 0) top$model[1] else "N/A", "Model Popular", icon = icon("star"), color = "orange")
    }
  })
  output$kpi_pop_listings <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    col <- if (input$brand == "Toate Brandurile") "brand" else "model"
    lbl <- if (input$brand == "Toate Brandurile") "Listari Brand Popular" else "Listari Model Popular"
    top <- df %>% count(.data[[col]]) %>% arrange(desc(n))
    nl <- if(nrow(top) > 0) top$n[1] else 0
    pct <- round((nl / nrow(df)) * 100, 1)
    valueBox(paste0(fmt(nl), " (", pct, "%)"), lbl, icon = icon("list"), color = "blue")
  })
  output$kpi_consum <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0)
    v <- mean(df$fuel_consumption_l_100km, na.rm = TRUE)
    val <- if(is.nan(v) || is.na(v) || v <= 0) "N/A" else paste0(round(v, 1), " l/100km")
    valueBox(val, paste("Consum Mediu", sfx()), icon = icon("gas-pump"), color = "aqua")
  })
  output$kpi_spec1 <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0); s <- sfx()
    if (input$piata == "Germania") {
      v <- mean(df$co2_g, na.rm = TRUE)
      val <- if(is.nan(v) || is.na(v) || v <= 0) "N/A" else paste0(round(v, 1), " g/km")
      valueBox(val, paste("CO2 Mediu", s), icon = icon("leaf"), color = "olive")
    } else if (input$piata == "India") {
      v <- mean(df$power_ps, na.rm = TRUE)
      val <- if(is.nan(v) || is.na(v) || v <= 0) "N/A" else paste0(round(v), " PS")
      valueBox(val, paste("Putere Medie", s), icon = icon("bolt"), color = "orange")
    } else {
      dc <- df %>% filter(!is.na(drivetrain), drivetrain != "", drivetrain != "Unknown") %>% count(drivetrain) %>% arrange(desc(n))
      valueBox(if(nrow(dc) == 0) "N/A" else dc$drivetrain[1], paste("Tractiune Majoritara", s), icon = icon("cog"), color = "teal")
    }
  })
  output$kpi_spec2 <- renderValueBox({
    df <- car_data(); req(nrow(df) > 0); s <- sfx()
    if (input$piata == "Germania") {
      v <- mean(df$power_ps, na.rm = TRUE)
      val <- if(is.nan(v) || is.na(v) || v <= 0) "N/A" else paste0(round(v), " PS")
      valueBox(val, paste("Putere Medie", s), icon = icon("bolt"), color = "orange")
    } else if (input$piata == "India") {
      bc <- df %>% filter(!is.na(body_type), body_type != "") %>% count(body_type) %>% arrange(desc(n))
      valueBox(if(nrow(bc) == 0) "N/A" else bc$body_type[1], paste("Caroserie Majoritara", s), icon = icon("car-side"), color = "navy")
    } else {
      vd <- df %>% filter(!is.na(one_owner), one_owner != "Unknown")
      val <- if(nrow(vd) == 0) "N/A" else paste0(round(sum(vd$one_owner == "Yes") / nrow(vd) * 100, 1), "%")
      valueBox(val, paste("Un Proprietar", s), icon = icon("user-check"), color = "green")
    }
  })
  
  # --- GRAFICE ---
  
  # Distributia preturilor (density cu Nr. masini pe axa Y)
  output$price_dist_plot <- renderPlot({
    df <- car_data(); req(nrow(df) > 0)
    med <- median(df$price_in_euro, na.rm = TRUE)
    avg <- mean(df$price_in_euro, na.rm = TRUE)
    lim <- quantile(df$price_in_euro, 0.98, na.rm = TRUE)
    pmax <- max(df$price_in_euro, na.rm = TRUE)
    ggplot(df, aes(x = price_in_euro)) +
      geom_density(aes(y = after_stat(count)), fill = "#2b6cb0", color = "#1a365d",
                   alpha = 0.55, linewidth = 0.9) +
      geom_vline(xintercept = med, color = "#c05621", linewidth = 0.9, linetype = "dashed") +
      geom_vline(xintercept = avg, color = "#2f855a", linewidth = 0.9, linetype = "dotted") +
      annotate("text", x = med, y = Inf, label = paste0("Mediana: ", fmt(med)),
               vjust = 2, hjust = -0.1, color = "#c05621", size = 3.8, fontface = "bold") +
      annotate("text", x = avg, y = Inf, label = paste0("Media: ", fmt(avg)),
               vjust = 3.5, hjust = -0.1, color = "#2f855a", size = 3.8, fontface = "bold") +
      annotate("text", x = lim, y = 0, label = paste0("Max: ", fmt(pmax), " EUR"),
               hjust = 1, vjust = -0.5, color = "#4a5568", size = 3.5, fontface = "italic") +
      scale_x_continuous(labels = function(x) format(x, big.mark = ",")) +
      coord_cartesian(xlim = c(0, lim)) +
      labs(x = "Pret (EUR)", y = "Nr. masini") + tema()
  })
  
  # Distributia anilor
  output$year_dist_plot <- renderPlot({
    df <- car_data(); req(nrow(df) > 0)
    df_f <- df %>% filter(year <= 2023)
    an_min <- max(min(df_f$year, na.rm = TRUE), 1985)
    ggplot(df_f, aes(x = year)) +
      geom_histogram(aes(fill = after_stat(count)), binwidth = 1, color = "white", linewidth = 0.3) +
      scale_fill_gradient(low = "#fbd38d", high = "#c05621", guide = "none") +
      scale_x_continuous(labels = function(x) format(x, scientific = FALSE, big.mark = ""),
                         breaks = seq(1985, 2023, by = 5)) +
      scale_y_continuous(labels = function(x) format(x, big.mark = ",")) +
      coord_cartesian(xlim = c(an_min, 2023)) +
      labs(x = "An Fabricatie", y = "Nr. masini") + tema()
  })
  
  # Helper: grafic de bare orizontale cu etichete
  bar_plot <- function(df, col, y_label = "Nr. listari") {
    df %>%
      count(.data[[col]]) %>%
      top_n(10, n) %>%
      ggplot(aes(x = reorder(.data[[col]], n), y = n, fill = reorder(.data[[col]], n))) +
      geom_col(show.legend = FALSE, width = 0.7) +
      geom_text(aes(label = format(n, big.mark = ",")),
                hjust = -0.1, size = 3.8, color = "#2d3748", fontface = "bold") +
      coord_flip() +
      scale_fill_manual(values = pal) +
      scale_y_continuous(labels = function(x) format(x, big.mark = ","),
                         expand = expansion(mult = c(0, 0.25))) +
      labs(x = "", y = y_label) + tema()
  }
  
  # Top branduri / modele
  output$models_plot <- renderPlot({
    df <- car_data(); req(nrow(df) > 0)
    col <- if (input$brand == "Toate Brandurile") "brand" else "model"
    lbl <- if (input$brand == "Toate Brandurile") "Nr. listari (Top 5 Branduri)" else "Nr. listari (Top 5 Modele)"
    df %>% count(.data[[col]]) %>% top_n(5, n) %>%
      ggplot(aes(x = reorder(.data[[col]], n), y = n, fill = reorder(.data[[col]], n))) +
      geom_col(show.legend = FALSE, width = 0.7) +
      geom_text(aes(label = format(n, big.mark = ",")),
                hjust = -0.1, size = 3.8, color = "#2d3748", fontface = "bold") +
      coord_flip() + scale_fill_manual(values = pal) +
      scale_y_continuous(labels = function(x) format(x, big.mark = ","),
                         expand = expansion(mult = c(0, 0.25))) +
      labs(x = "", y = lbl) + tema()
  })
  
  # Transmisie / Combustibil
  output$trans_plot <- renderPlot({ df <- car_data(); req(nrow(df) > 0); bar_plot(df, "transmission_type") })
  output$fuel_plot  <- renderPlot({ df <- car_data(); req(nrow(df) > 0); bar_plot(df, "fuel_type") })
  
  # India: caroserie
  output$india_extra_plot <- renderPlot({
    df <- car_data()
    validate(need(nrow(df) > 0, "Fara date"), need("body_type" %in% names(df), "Lipsa date"))
    df_p <- df %>% filter(!is.na(body_type), body_type != "")
    validate(need(nrow(df_p) > 0, "Nu exista date."))
    bar_plot(df_p, "body_type", "Nr. masini")
  })
  
  # SUA: tractiune
  output$sua_drivetrain_plot <- renderPlot({
    df <- car_data()
    validate(need(nrow(df) > 0, "Fara date"), need("drivetrain" %in% names(df), "Lipsa date"))
    df_p <- df %>% filter(!is.na(drivetrain), drivetrain != "", drivetrain != "Unknown")
    validate(need(nrow(df_p) > 0, "Nu exista date."))
    bar_plot(df_p, "drivetrain", "Nr. masini")
  })
  
  # SUA: proprietar unic
  output$sua_owner_plot <- renderPlot({
    df <- car_data()
    validate(need(nrow(df) > 0, "Fara date"), need("one_owner" %in% names(df), "Lipsa date"))
    df_p <- df %>% filter(!is.na(one_owner), one_owner != "", one_owner != "Unknown")
    validate(need(nrow(df_p) > 0, "Nu exista date."))
    df_p %>% count(one_owner) %>%
      ggplot(aes(x = one_owner, y = n, fill = one_owner)) +
      geom_col(show.legend = FALSE, width = 0.55) +
      geom_text(aes(label = format(n, big.mark = ",")),
                vjust = -0.5, size = 4, color = "#2d3748", fontface = "bold") +
      scale_fill_manual(values = c("Yes" = "#2f855a", "No" = "#9b2c2c")) +
      scale_y_continuous(labels = function(x) format(x, big.mark = ","),
                         expand = expansion(mult = c(0, 0.15))) +
      labs(x = "Un singur proprietar?", y = "Nr. masini") + tema()
  })
  
  # Tab-uri dinamice per piata
  output$market_tabs_ui <- renderUI({
    req(input$piata)
    tab_lbl <- if (!is.null(input$brand) && input$brand == "Toate Brandurile") "Branduri Populare" else "Modele Populare"
    tabs_comune <- list(
      tabPanel(tab_lbl, plotOutput("models_plot", height = "250px")),
      tabPanel("An Fabricatie", plotOutput("year_dist_plot", height = "250px")),
      tabPanel("Transmisie", plotOutput("trans_plot", height = "250px")),
      tabPanel("Combustibil", plotOutput("fuel_plot", height = "250px"))
    )
    tabs_extra <- switch(input$piata,
      "India" = list(tabPanel("Tip Caroserie", plotOutput("india_extra_plot", height = "250px"))),
      "SUA"   = list(tabPanel("Tractiune", plotOutput("sua_drivetrain_plot", height = "250px")),
                     tabPanel("Un Proprietar", plotOutput("sua_owner_plot", height = "250px"))),
      list()
    )
    do.call(tabBox, c(list(width = 12, id = "market_tabs"), tabs_comune, tabs_extra))
  })
}

shinyApp(ui = ui, server = server)