# Shiny Dashboard Explorare — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construire `app.R` — dashboard Shiny interactiv pentru explorarea pietelor auto SH (SUA, Germania, India) cu cascade Piata → Brand, 4 KPI cu sparkline, 11 grafice principale.

**Architecture:** Single-file `app.R` cu `shinydashboard`, reactive pattern (`brand_options`, `date_curente`), query SQL parametrizat per schimbare de selectie, fara functii custom (tidyverse inline).

**Tech Stack:** R + Shiny + shinydashboard + DBI/RSQLite + tidyverse + scales.

**Spec:** `docs/superpowers/specs/2026-05-24-shiny-dashboard-explorare-design.md`

**Testare:** Manuala via `runApp()` in RStudio sau consola R. Verificare vizuala in browser dupa fiecare task. Fara `shinytest2`/teste automate (consistent cu stilul scripturilor existente).

---

## File Structure

**Fisier creat:**
- `app.R` — la radacina proiectului, alaturi de `SUA_R.R`, `Germany_R.R`, `India_R.R`

**Fisier modificat:** niciunul.

**Dependinte tabele SQLite (`identifier.sqlite`):**
- `SUA_Cars_Cleaned`
- `Germany_Cars_Cleaned`
- `India_Cars_Cleaned`

---

## Task 1: Setup initial app.R + verificare pachete

**Files:**
- Create: `app.R`

- [ ] **Step 1: Verifica si instaleaza pachete (in consola R)**

```r
# Verifica daca pachetele sunt instalate; instaleaza ce lipseste
pachete_necesare <- c("shiny", "shinydashboard", "DBI", "RSQLite",
                      "tidyverse", "scales")
pachete_lipsa <- pachete_necesare[!pachete_necesare %in%
                                    installed.packages()[, "Package"]]
if (length(pachete_lipsa) > 0) {
  install.packages(pachete_lipsa)
}
```

Expected: Toate pachetele disponibile fara erori.

- [ ] **Step 2: Creeaza `app.R` cu shell minimal**

```r
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
```

- [ ] **Step 3: Ruleaza aplicatia ca smoke test**

In consola R:
```r
shiny::runApp()
```

Expected:
- Browser-ul se deschide pe `http://127.0.0.1:XXXX`
- Apare un layout albastru cu titlu "Dashboard Auto SH" si textul "Dashboard in constructie"
- Consola afiseaza `Listening on http://127.0.0.1:XXXX`
- Niciun error/warning in consola

Inchide aplicatia: Stop button in RStudio sau `Ctrl+C` in consola.

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: shell initial app.R cu shinydashboard"
```

---

## Task 2: Sidebar — selector piata + brand dinamic

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga `selectInput` pentru piata + `uiOutput` pentru brand in sidebar**

Inlocuieste `dashboardSidebar()` din UI cu:

```r
  dashboardSidebar(
    selectInput("piata", "Selecteaza Piata:",
                choices = c("SUA", "Germania", "India"),
                selected = "Germania"),
    uiOutput("brand_selector")
  ),
```

- [ ] **Step 2: Adauga `brand_options` reactive si `output$brand_selector` in server**

Adauga in `server` (inlocuieste comentariul `# Va fi populat...`):

```r
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
```

- [ ] **Step 3: Verifica vizual**

In consola R: `shiny::runApp()`

Expected:
- Sidebar are 2 dropdown-uri: "Selecteaza Piata" (cu valoarea "Germania" preselectata) si "Selecteaza Brand" (populat cu branduri din Germany_Cars_Cleaned, ex: "BMW", "Audi", "Mercedes-Benz", etc.)
- Schimbi piata din "Germania" in "SUA": dropdown-ul brand se reincarca cu branduri SUA (ex: "Ford", "Toyota", "Chevrolet", etc.)
- Schimbi in "India": dropdown-ul brand se reincarca cu branduri India

Daca dropdown-ul Brand e gol: verifica conexiunea SQLite si numele tabelelor.

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: sidebar cu selector piata + brand dinamic"
```

---

## Task 3: Date curente reactive + titlu dinamic

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga `date_curente` reactive in server**

Adauga dupa `output$brand_selector` in `server`:

```r
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
```

- [ ] **Step 2: Inlocuieste `h2("Dashboard in constructie")` in UI**

In `dashboardBody`, inlocuieste cu:

```r
    h2(textOutput("titlu_dinamic"))
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Sub header apare titlu: "Analiza brand: BMW (Germania)" (sau primul brand din lista)
- Schimbi brand din BMW in Audi: titlu se actualizeaza in "Analiza brand: Audi (Germania)"
- Schimbi piata in SUA: titlu se actualizeaza in "Analiza brand: <primul brand SUA> (SUA)"

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: reactive date_curente + titlu dinamic"
```

---

## Task 4: KPI 1 — Listari + sparkline

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga randul KPIs in UI (cu doar primul KPI)**

In `dashboardBody`, sub `h2(textOutput("titlu_dinamic"))`, adauga:

```r
    # Rand KPIs
    fluidRow(
      column(width = 3,
        valueBoxOutput("kpi_listari", width = NULL),
        plotOutput("spark_listari", height = "60px"))
    ),
```

- [ ] **Step 2: Adauga `output$kpi_listari` si `output$spark_listari` in server**

Adauga dupa `output$titlu_dinamic`:

```r
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
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Sub titlu apare o caseta albastra cu numarul mare (ex: "1.245") si textul "Listari"
- Sub caseta apare un sparkline (bar chart mic) fara axe
- Schimbi brand: numarul si sparkline-ul se actualizeaza

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: KPI listari + sparkline"
```

---

## Task 5: KPI 2 — Pret median + sparkline

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Extinde `fluidRow` cu al doilea KPI**

Adauga o `column` noua in `fluidRow`-ul cu KPIs (sub prima `column`):

```r
      column(width = 3,
        valueBoxOutput("kpi_pret", width = NULL),
        plotOutput("spark_pret", height = "60px"))
```

Asigura-te ca virgula este corecta intre column-uri.

- [ ] **Step 2: Adauga outputs in server**

Adauga dupa `output$spark_listari`:

```r
  # ---- KPI 2: Pret median ----
  output$kpi_pret <- renderValueBox({
    req(nrow(date_curente()) > 0)
    pret_med <- median(date_curente()$price_in_euro, na.rm = TRUE)
    valueBox(
      value = paste0(comma(pret_med), " EUR"),
      subtitle = "Pret median",
      icon = icon("euro-sign"),
      color = "green"
    )
  })

  # ---- Sparkline pret: densitate ----
  output$spark_pret <- renderPlot({
    req(nrow(date_curente()) > 0)
    ggplot(date_curente(), aes(x = price_in_euro)) +
      geom_density(fill = "#00a65a", color = "#00a65a", alpha = 0.5) +
      theme_void()
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Apar 2 KPI-uri side-by-side: Listari (albastru) + Pret median (verde)
- Pret median afiseaza valoare formatata cu virgula (ex: "18,500 EUR")
- Sparkline pret = linie de densitate verde

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: KPI pret median + sparkline densitate"
```

---

## Task 6: KPI 3 — Km mediu + sparkline

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Extinde `fluidRow` cu al treilea KPI**

Adauga in `fluidRow`-ul KPIs (dupa column kpi_pret):

```r
      column(width = 3,
        valueBoxOutput("kpi_km", width = NULL),
        plotOutput("spark_km", height = "60px"))
```

- [ ] **Step 2: Adauga outputs in server**

Adauga dupa `output$spark_pret`:

```r
  # ---- KPI 3: Km mediu ----
  output$kpi_km <- renderValueBox({
    req(nrow(date_curente()) > 0)
    km_med <- mean(date_curente()$km, na.rm = TRUE)
    valueBox(
      value = paste0(comma(round(km_med)), " km"),
      subtitle = "Km mediu",
      icon = icon("road"),
      color = "purple"
    )
  })

  # ---- Sparkline km: densitate ----
  output$spark_km <- renderPlot({
    req(nrow(date_curente()) > 0)
    ggplot(date_curente(), aes(x = km)) +
      geom_density(fill = "#605ca8", color = "#605ca8", alpha = 0.5) +
      theme_void()
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- 3 KPI-uri: Listari + Pret + Km mediu
- Km mediu in mov, ex: "85,432 km"
- Sparkline = densitate mov

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: KPI km mediu + sparkline densitate"
```

---

## Task 7: KPI 4 — Varsta medie + sparkline

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Extinde `fluidRow` cu al patrulea KPI**

Adauga in `fluidRow`-ul KPIs (dupa column kpi_km):

```r
      column(width = 3,
        valueBoxOutput("kpi_varsta", width = NULL),
        plotOutput("spark_varsta", height = "60px"))
```

- [ ] **Step 2: Adauga outputs in server**

Adauga dupa `output$spark_km`:

```r
  # ---- KPI 4: Varsta medie ----
  output$kpi_varsta <- renderValueBox({
    req(nrow(date_curente()) > 0)
    # Anul de referinta este 2024 (datele sunt din 2023)
    varsta_med <- 2024 - mean(date_curente()$year, na.rm = TRUE)
    valueBox(
      value = paste0(round(varsta_med, 1), " ani"),
      subtitle = "Varsta medie",
      icon = icon("calendar-alt"),
      color = "yellow"
    )
  })

  # ---- Sparkline varsta: count pe ani ----
  output$spark_varsta <- renderPlot({
    req(nrow(date_curente()) > 0)
    date_curente() %>%
      count(year) %>%
      ggplot(aes(x = year, y = n)) +
      geom_col(fill = "#f39c12") +
      theme_void()
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- 4 KPI-uri side-by-side: Listari + Pret + Km + Varsta
- Varsta in galben, ex: "5.2 ani"
- Sparkline = bar chart galben pe ani

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: KPI varsta medie + sparkline (4 KPIs complete)"
```

---

## Task 8: Grafic 1 — Histograma pret + densitate

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga `fluidRow` cu primul grafic in UI**

Sub `fluidRow`-ul cu KPIs, adauga:

```r
    # Rand 1: histograma pret + scatter km
    fluidRow(
      box(title = "Distributie pret", status = "primary",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_hist_pret"))
    ),
```

- [ ] **Step 2: Adauga `output$plot_hist_pret` in server**

Adauga dupa `output$spark_varsta`:

```r
  # ---- Grafic 1: Histograma pret + densitate ----
  output$plot_hist_pret <- renderPlot({
    req(nrow(date_curente()) > 0)
    ggplot(date_curente(), aes(x = price_in_euro)) +
      geom_histogram(aes(y = after_stat(density)),
                     fill = "#3c8dbc", color = "white", bins = 20) +
      geom_density(color = "black", size = 0.8) +
      scale_x_continuous(labels = comma) +
      labs(title = "Distributia preturilor",
           x = "Pret (EUR)", y = "Densitate") +
      theme_minimal()
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Sub KPIs apare un box albastru cu titlul "Distributie pret"
- Inauntru: histograma cu bars albastri + linie densitate neagra peste
- Axa X: preturi formatate cu virgula

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: grafic 1 histograma pret + densitate"
```

---

## Task 9: Grafic 2 — Scatter pret vs km

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga al doilea box in `fluidRow` randul 1**

In `fluidRow` cu graficul 1, adauga al doilea `box`:

```r
      box(title = "Pret vs Kilometraj", status = "success",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_scatter_km"))
```

Asigura-te ca virgula este corecta intre box-uri.

- [ ] **Step 2: Adauga `output$plot_scatter_km` in server**

Adauga dupa `output$plot_hist_pret`:

```r
  # ---- Grafic 2: Scatter pret vs km cu linie trend ----
  output$plot_scatter_km <- renderPlot({
    req(nrow(date_curente()) > 0)
    ggplot(date_curente(), aes(x = km, y = price_in_euro)) +
      geom_point(alpha = 0.5, color = "#00a65a") +
      geom_smooth(method = "lm", color = "red", se = TRUE) +
      scale_x_continuous(labels = comma) +
      scale_y_continuous(labels = comma) +
      labs(title = "Pret vs Kilometraj",
           x = "Kilometraj (km)", y = "Pret (EUR)") +
      theme_minimal()
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Pe rand 1, 2 box-uri side-by-side: Histograma pret + Scatter pret vs km
- Scatter are puncte verzi + linie de regresie rosie cu interval de incredere
- Axele x si y formatate cu virgula

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: grafic 2 scatter pret vs km"
```

---

## Task 10: Grafic 3 — Scatter pret vs an

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga `fluidRow` randul 2 cu primul box**

Sub `fluidRow`-ul cu randul 1, adauga:

```r
    # Rand 2: scatter an + top 10 modele
    fluidRow(
      box(title = "Pret vs An Fabricatie", status = "warning",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_scatter_an"))
    ),
```

- [ ] **Step 2: Adauga `output$plot_scatter_an` in server**

Adauga dupa `output$plot_scatter_km`:

```r
  # ---- Grafic 3: Scatter pret vs an cu linie trend ----
  output$plot_scatter_an <- renderPlot({
    req(nrow(date_curente()) > 0)
    ggplot(date_curente(), aes(x = year, y = price_in_euro)) +
      geom_point(alpha = 0.5, color = "#f39c12") +
      geom_smooth(method = "lm", color = "blue", se = TRUE) +
      scale_y_continuous(labels = comma) +
      labs(title = "Pret vs An fabricatie",
           x = "An fabricatie", y = "Pret (EUR)") +
      theme_minimal()
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Pe randul 2 apare 1 box galben (warning): "Pret vs An Fabricatie"
- Puncte galbene + linie albastra de regresie

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: grafic 3 scatter pret vs an"
```

---

## Task 11: Grafic 4 — Top 10 modele

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga al doilea box in `fluidRow` randul 2**

In `fluidRow` randul 2, adauga:

```r
      box(title = "Top 10 modele (numar listari)", status = "info",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_top10_modele"))
```

- [ ] **Step 2: Adauga `output$plot_top10_modele` in server**

Adauga dupa `output$plot_scatter_an`:

```r
  # ---- Grafic 4: Top 10 modele cele mai listate ----
  output$plot_top10_modele <- renderPlot({
    req(nrow(date_curente()) > 0)
    date_curente() %>%
      count(model, sort = TRUE) %>%
      head(10) %>%
      ggplot(aes(x = reorder(model, n), y = n)) +
      geom_col(fill = "#00c0ef") +
      coord_flip() +
      labs(title = "Top 10 modele",
           x = "", y = "Numar listari") +
      theme_minimal()
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Pe randul 2, 2 box-uri: Scatter an + Top 10 modele
- Top 10 = bar chart orizontal cu modelele brandului ales, ordonate descrescator
- Brand-uri cu mai putin de 10 modele afiseaza toate disponibile

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: grafic 4 top 10 modele"
```

---

## Task 12: Grafic 5 + 6 — Boxplot pret/fuel + Histograma an

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga `fluidRow` randul 3 cu doua box-uri**

Sub `fluidRow` randul 2, adauga:

```r
    # Rand 3: boxplot fuel + histograma an
    fluidRow(
      box(title = "Pret pe tip combustibil", status = "primary",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_box_fuel")),
      box(title = "Distributie an fabricatie", status = "success",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_hist_an"))
    ),
```

- [ ] **Step 2: Adauga ambele outputs in server**

Adauga dupa `output$plot_top10_modele`:

```r
  # ---- Grafic 5: Boxplot pret pe fuel_type ----
  output$plot_box_fuel <- renderPlot({
    req(nrow(date_curente()) > 0)
    ggplot(date_curente(),
           aes(x = fuel_type, y = price_in_euro, fill = fuel_type)) +
      geom_boxplot(show.legend = FALSE) +
      scale_y_continuous(labels = comma) +
      labs(title = "Distributia pretului pe combustibil",
           x = "Combustibil", y = "Pret (EUR)") +
      theme_minimal()
  })

  # ---- Grafic 6: Histograma distributie an ----
  output$plot_hist_an <- renderPlot({
    req(nrow(date_curente()) > 0)
    ggplot(date_curente(), aes(x = year)) +
      geom_histogram(fill = "#00a65a", color = "white", bins = 15) +
      labs(title = "Distributia anului de fabricatie",
           x = "An", y = "Numar masini") +
      theme_minimal()
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Pe randul 3, 2 box-uri: Boxplot pret/fuel (albastru) + Histograma an (verde)
- Boxplot are cate o cutie per tip de combustibil
- Histograma an arata distributia anilor de fabricatie

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: grafice 5+6 boxplot fuel si histograma an"
```

---

## Task 13: Grafic 7 + 8 — Histograma km + Plot specific piata

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga `fluidRow` randul 4 cu doua box-uri**

Sub `fluidRow` randul 3, adauga:

```r
    # Rand 4: histograma km + plot specific piata
    fluidRow(
      box(title = "Distributie kilometraj", status = "warning",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_hist_km")),
      box(title = textOutput("titlu_box_specific"), status = "info",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_specific"))
    ),
```

- [ ] **Step 2: Adauga outputs in server**

Adauga dupa `output$plot_hist_an`:

```r
  # ---- Grafic 7: Histograma distributie km ----
  output$plot_hist_km <- renderPlot({
    req(nrow(date_curente()) > 0)
    ggplot(date_curente(), aes(x = km)) +
      geom_histogram(fill = "#f39c12", color = "white", bins = 20) +
      scale_x_continuous(labels = comma) +
      labs(title = "Distributia kilometrajului",
           x = "Km", y = "Numar masini") +
      theme_minimal()
  })

  # ---- Titlu dinamic pentru box-ul specific piata ----
  output$titlu_box_specific <- renderText({
    req(input$piata)
    if (input$piata == "SUA") {
      "Capacitate motor (litri)"
    } else {
      "Putere motor (PS)"
    }
  })

  # ---- Grafic 8: Plot specific piata ----
  output$plot_specific <- renderPlot({
    req(nrow(date_curente()) > 0)
    date <- date_curente()
    if (input$piata == "SUA") {
      # SUA nu are power_ps; aratam engine_type in litri
      ggplot(date %>% filter(!is.na(engine_type)),
             aes(x = engine_type)) +
        geom_histogram(fill = "#00c0ef", color = "white", bins = 15) +
        labs(title = "Distributia capacitatii motor",
             x = "Litri", y = "Numar masini") +
        theme_minimal()
    } else {
      # Germania + India au power_ps
      ggplot(date %>% filter(!is.na(power_ps), power_ps > 0),
             aes(x = power_ps)) +
        geom_histogram(fill = "#00c0ef", color = "white", bins = 20) +
        labs(title = "Distributia puterii motorului",
             x = "Power PS", y = "Numar masini") +
        theme_minimal()
    }
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Pe randul 4, 2 box-uri: Histograma km (galben) + Plot specific (albastru deschis)
- Cu piata "Germania" sau "India": titlu box specific = "Putere motor (PS)", grafic distributie power_ps
- Schimbi piata in "SUA": titlu = "Capacitate motor (litri)", grafic distributie engine_type

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: grafice 7+8 histograma km si plot specific piata"
```

---

## Task 14: Grafic 9 + 10 — Bar transmisie + Bar fuel

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga `fluidRow` randul 5 cu doua box-uri**

Sub `fluidRow` randul 4, adauga:

```r
    # Rand 5: bar transmisie + bar fuel
    fluidRow(
      box(title = "Distributie transmisie", status = "primary",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_transmisie")),
      box(title = "Distributie combustibil", status = "success",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_fuel"))
    ),
```

- [ ] **Step 2: Adauga outputs in server**

Adauga dupa `output$plot_specific`:

```r
  # ---- Grafic 9: Bar chart transmisie ----
  output$plot_transmisie <- renderPlot({
    req(nrow(date_curente()) > 0)
    date_curente() %>%
      count(transmission_type) %>%
      ggplot(aes(x = reorder(transmission_type, n), y = n,
                 fill = transmission_type)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      labs(title = "Distributia tipurilor de transmisie",
           x = "", y = "Numar masini") +
      theme_minimal()
  })

  # ---- Grafic 10: Bar chart fuel ----
  output$plot_fuel <- renderPlot({
    req(nrow(date_curente()) > 0)
    date_curente() %>%
      count(fuel_type) %>%
      ggplot(aes(x = reorder(fuel_type, n), y = n,
                 fill = fuel_type)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      labs(title = "Distributia tipurilor de combustibil",
           x = "", y = "Numar masini") +
      theme_minimal()
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Pe randul 5, 2 box-uri: Bar transmisie + Bar fuel
- Bar charts orizontale, ordonate descrescator, fiecare bara colorata diferit

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: grafice 9+10 bar charts transmisie si fuel"
```

---

## Task 15: Grafic 11 — Bar chart top 8 culori

**Files:**
- Modify: `app.R`

- [ ] **Step 1: Adauga `fluidRow` randul 6 cu un box**

Sub `fluidRow` randul 5, adauga:

```r
    # Rand 6: bar culori
    fluidRow(
      box(title = "Top 8 culori cele mai frecvente", status = "warning",
          solidHeader = TRUE, width = 6,
          plotOutput("plot_culori"))
    )
```

Nota: Fara virgula la final (este ultimul `fluidRow` in `dashboardBody`).

- [ ] **Step 2: Adauga `output$plot_culori` in server**

Adauga dupa `output$plot_fuel`:

```r
  # ---- Grafic 11: Bar chart top 8 culori ----
  output$plot_culori <- renderPlot({
    req(nrow(date_curente()) > 0)
    date_curente() %>%
      count(color, sort = TRUE) %>%
      head(8) %>%
      ggplot(aes(x = reorder(color, n), y = n, fill = color)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      labs(title = "Top 8 culori",
           x = "", y = "Numar masini") +
      theme_minimal()
  })
```

- [ ] **Step 3: Verifica vizual**

`shiny::runApp()`

Expected:
- Pe randul 6, 1 box galben cu top 8 culori (bar orizontal)
- Coloane colorate cu numele culorii (negru = negru, alb = alb, etc., daca culorile ggplot mapeaza textul la culoare; altfel culori implicite)

- [ ] **Step 4: Commit**

```bash
git add app.R
git commit -m "feat: grafic 11 top 8 culori (toate 11 complete)"
```

---

## Task 16: Smoke test final + cleanup

**Files:**
- Modify: niciun fisier nou. Verificare finala.

- [ ] **Step 1: Smoke test complet pe toate cele 3 piete**

`shiny::runApp()`

Pentru fiecare piata (Germania, SUA, India), executa:

1. Selecteaza piata
2. Asteapta ca dropdown-ul Brand sa se populeze
3. Selecteaza primul brand din lista
4. Verifica:
   - Titlul se actualizeaza
   - Cele 4 KPIs afiseaza numere reale (nu NA, nu 0)
   - Cele 4 sparkline-uri apar
   - Cele 11 grafice se afiseaza
   - Plot specific arata corect: "Capacitate motor" pentru SUA, "Putere PS" pentru DE+IN
5. Selecteaza un al doilea brand (verifica reactivitatea)

Expected output in consola: doar `Listening on http://127.0.0.1:XXXX`. Niciun `Warning` sau `Error`.

- [ ] **Step 2: Verifica edge case — brand cu putine masini**

Pentru piata SUA, selecteaza un brand rar (ex: dropdown-ul are si branduri cu sub 10 masini — alege unul).

Expected:
- Graficele apar (pot fi sparse, dar fara erori)
- Niciun `Error in dbGetQuery`
- Top 10 modele afiseaza doar cate sunt disponibile

- [ ] **Step 3: Verifica edge case — brand fara power_ps in India**

Pentru piata "India", incearca branduri diferite (Mahindra, Maruti Suzuki, etc.).

Expected:
- Daca `power_ps` exista: grafic specific arata distributia
- Daca `power_ps` e NULL/0 in toate randurile: graficul arata gol cu axe (nu eroare)

- [ ] **Step 4: Verificare cleanup**

```bash
ls -la
```

Expected:
- Niciun fisier de test/debug in radacina proiectului
- Doar fisierele oficiale: `app.R`, scripturile R, scripturile SQL, `CLAUDE.md`, `AGENTS.md`, etc.

Daca apar fisiere nedorite (`.RData`, `Rplots.pdf`, fisiere temporare), sterge-le inainte de commit final.

- [ ] **Step 5: Update CLAUDE.md cu statusul "Finalizat"**

Modifica `CLAUDE.md` sectiunea "Status Curent":

Sub `**Finalizat:**` adauga:
```markdown
- Dashboard Shiny Explorare (`app.R`) — selector Piata + Brand, 4 KPI cu sparkline, 11 grafice
```

Sub `**De facut:**` elimina linia despre "Dashboard interactiv Shiny — Explorare, Comparatie, Predictor" si inlocuieste cu:
```markdown
- Dashboard Shiny: sectiunea Comparatie intre piete
- Dashboard Shiny: sectiunea Predictor (Regresie Liniara + Random Forest)
- Analiza exploratorie (EDA) — statistici descriptive, corelatii, vizualizari
- Modele predictive — tidymodels
```

Modifica si lista "Structura Fisiere":

Adauga linia:
```
app.R                        # dashboard Shiny explorare per piata+brand
```

- [ ] **Step 6: Commit final**

```bash
git add app.R CLAUDE.md
git commit -m "feat: finalizare dashboard Shiny Explorare + update CLAUDE.md"
```

---

## Self-Review Checklist

- [ ] **Spec coverage:** Toate sectiunile spec-ului (2-9) au taskuri corespondente:
  - Arhitectura → Task 1
  - UI Layout → Tasks 1, 2
  - KPIs → Tasks 4-7
  - 11 grafice → Tasks 8-15
  - Flux date → Tasks 2-3
  - Diferente piete → Task 13 (plot specific)
  - Testare → Task 16

- [ ] **Placeholder scan:** Niciun "TBD", "TODO", "implement later". Cod complet in fiecare step.

- [ ] **Type consistency:** Nume reactive consistente (`date_curente`, `brand_options`). ID-uri Shiny consistente (`input$piata`, `input$brand`, `output$kpi_*`, `output$spark_*`, `output$plot_*`).

- [ ] **Pas mic per step:** Fiecare step e 2-5 minute de munca.

- [ ] **Verificari vizuale dupa fiecare task:** Da, `shiny::runApp()` dupa fiecare task.

- [ ] **Commits frecvente:** 16 commits = unul per task.
