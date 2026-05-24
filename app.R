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
  dashboardSidebar(),
  dashboardBody(
    h2("Dashboard in constructie")
  )
)

# --------------------------------------------------------------
# SERVER
# --------------------------------------------------------------
server <- function(input, output, session) {
  # Va fi populat in pasii urmatori
}

# --------------------------------------------------------------
shinyApp(ui = ui, server = server)
