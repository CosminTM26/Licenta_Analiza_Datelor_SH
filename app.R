# ==============================================================
# DASHBOARD INTERACTIV: Piata auto SH (SUA, Germania, India)
# Surse: tabele *_Cars_Cleaned din identifier.sqlite
# ==============================================================

library(shiny)
library(shinydashboard)
library(DBI)
library(RSQLite)
library(tidyverse)
library(scales)

# --------------------------------------------------------------
# UI
# --------------------------------------------------------------
ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Dashboard Auto SH"),
  dashboardSidebar(
    selectInput("piata", "Selecteaza Piata:",
                choices = c("SUA", "Germania", "India"),
                selected = "Germania"),
    uiOutput("brand_selector")
  ),
  dashboardBody(
    h2(textOutput("titlu_dinamic")),
    # Rand KPIs
    fluidRow(
      column(width = 3,
        valueBoxOutput("kpi_listari", width = NULL),
        plotOutput("spark_listari", height = "60px"))
    )
  )
)

# --------------------------------------------------------------
# SERVER
# --------------------------------------------------------------
server <- function(input, output, session) {
  # ---- Reactive: lista branduri pentru piata aleasa ----
  brand_options <- reactive({
    req(input$piata)
    tabel <- switch(input$piata,
                    "SUA" = "SUA_Cars_Cleaned",
                    "Germania" = "Germany_Cars_Cleaned",
                    "India" = "India_Cars_Cleaned")
    con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
    rezultat <- dbGetQuery(con,
      paste0("SELECT DISTINCT brand FROM ", tabel, " ORDER BY brand"))
    dbDisconnect(con)
    rezultat$brand
  })

  # ---- Dropdown brand dinamic ----
  output$brand_selector <- renderUI({
    selectInput("brand", "Selecteaza Brand:",
                choices = brand_options())
  })

  # ---- Reactive: date pentru piata + brand selectate ----
  date_curente <- reactive({
    req(input$piata, input$brand)
    tabel <- switch(input$piata,
                    "SUA" = "SUA_Cars_Cleaned",
                    "Germania" = "Germany_Cars_Cleaned",
                    "India" = "India_Cars_Cleaned")
    con <- dbConnect(RSQLite::SQLite(), "identifier.sqlite")
    rezultat <- dbGetQuery(con,
      paste0("SELECT * FROM ", tabel, " WHERE brand = ?"),
      params = list(input$brand))
    dbDisconnect(con)
    rezultat
  })

  # ---- Titlu dinamic ----
  output$titlu_dinamic <- renderText({
    req(input$piata, input$brand)
    paste0("Analiza brand: ", input$brand, " (", input$piata, ")")
  })

  # ---- KPI 1: Numar listari ----
  output$kpi_listari <- renderValueBox({
    date <- date_curente()
    valueBox(
      value = comma(nrow(date)),
      subtitle = "Listari",
      icon = icon("car"),
      color = "blue"
    )
  })

  # ---- Sparkline listari: count pe ani ----
  output$spark_listari <- renderPlot({
    req(nrow(date_curente()) > 0)
    date_curente() %>%
      count(year) %>%
      ggplot(aes(x = year, y = n)) +
      geom_col(fill = "#3c8dbc") +
      theme_void()
  })
}

# --------------------------------------------------------------
shinyApp(ui = ui, server = server)
