# Design: Dashboard Shiny — Explorare per Piata + Brand

**Data:** 2026-05-24
**Autor:** Cosmin
**Proiect:** Licenta FEAA UAIC — Analiza Vanzari Auto SH
**Status:** Spec aprobat, gata pentru plan implementare

---

## 1. Context si scop

Proiectul de licenta analizeaza comparativ 3 piete auto second-hand (SUA, Germania, India) cu date din 2023.
Curatarea SQL si detectia outlierelor in R sunt finalizate (vezi `CLAUDE.md`).
Urmeaza componenta interactiva: un dashboard R Shiny ce permite explorarea statistica per piata si brand.

Aceasta spec acopera **doar sectiunea Explorare**. Comparatia intre piete si Predictor-ul ML sunt
piese separate, planificate pentru sesiuni ulterioare.

---

## 2. Arhitectura

**Fisier unic:** `app.R` la radacina proiectului, alaturi de scripturile R existente.

**Pachete:**

- `shiny` + `shinydashboard` — UI cu sidebar, header, boxes, valueBox
- `DBI` + `RSQLite` — conectare la `identifier.sqlite`
- `tidyverse` (`dplyr`, `ggplot2`, `tidyr`) — manipulare date + grafice
- `scales` — formatare numerica (`comma()`)

**Strategie incarcare date:**

- Nu se incarca tot in RAM la start (datele agregate sunt mari)
- La fiecare schimbare de `(Piata, Brand)`: query SQL parametrizat → `dbGetQuery` cu `?`
- Conexiune deschis/inchis per query (pattern din `Germany_R.R`, `SUA_R.R`)
- Lista brandurilor pentru dropdown: query separat `SELECT DISTINCT brand`

**Conventii stil cod:**

- Tidyverse exclusiv pentru manipulare si grafice
- Fara functii custom: `switch` direct in `reactive`, logica inline
- Fara `as.formula`, `sapply`, `lapply`, `sprintf`, `do.call`
- Comentarii in romana, pas cu pas
- `theme_minimal()` pentru toate ggplot-urile (consistent cu scripturile R existente)
- `after_stat(density)` in loc de `..density..` deprecated

---

## 3. UI Layout

```
+----------------------------------------------------------+
|   HEADER: "Dashboard Auto SH"                            |
+----------+-----------------------------------------------+
| SIDEBAR  |                                               |
|          |   TITLU dinamic: "Analiza brand: BMW (DE)"    |
| Piata:   |                                               |
| v SUA    |   +-----++-----++-----++-----+                |
|          |   | KPI || KPI || KPI || KPI |                |
| Brand:   |   |  1  ||  2  ||  3  ||  4  |                |
| v Toyota |   |spark||spark||spark||spark|                |
|          |   +-----++-----++-----++-----+                |
|          |                                               |
|          |   +--------------++--------------+            |
|          |   | Histogr.pret || Scatter km   |            |
|          |   +--------------++--------------+            |
|          |   ... (5 randuri grafice) ...                 |
+----------+-----------------------------------------------+
```

**Sidebar:**

- `selectInput("piata", ...)` — 3 optiuni: "SUA", "Germania", "India"
- `uiOutput("brand_selector")` — dropdown generat dinamic in server

**Body:**

- `h2(textOutput("titlu_dinamic"))` — afiseaza "Analiza brand: BMW (Germania)"
- 1 `fluidRow` cu 4 KPIs (`valueBox` + sparkline `plotOutput` sub fiecare)
- 6 `fluidRow` cu cate 2 `box()` continand `plotOutput()`

---

## 4. KPIs cu sparkline

| KPI | Calcul | Sparkline | Culoare |
|-----|--------|-----------|---------|
| Listari | `nrow(date)` | bar chart count pe ani | blue |
| Pret median | `median(price_in_euro, na.rm = TRUE)` | linie densitate pret | green |
| Km mediu | `mean(km, na.rm = TRUE)` | linie densitate km | purple |
| Varsta medie | `2024 - mean(year, na.rm = TRUE)` | bar chart count pe ani | yellow |

**An de referinta varsta:** `2024` (datele sunt din 2023, fix pentru licenta).

**Pattern UI per KPI:**

```r
column(width = 3,
  valueBoxOutput("kpi_listari", width = NULL),
  plotOutput("spark_listari", height = "60px")
)
```

**Pattern sparkline ggplot:**

```r
output$spark_listari <- renderPlot({
  date_curente() %>%
    count(year) %>%
    ggplot(aes(x = year, y = n)) +
    geom_col(fill = "#3c8dbc") +
    theme_void()
})
```

---

## 5. Cele 11 grafice principale

**Layout 6 randuri × 2 coloane:**

| Rand | Stanga | Dreapta |
|------|--------|---------|
| 1 | Histograma pret + densitate | Scatter pret-vs-km + linie trend |
| 2 | Scatter pret-vs-an + linie trend | Top 10 modele (bar orizontal) |
| 3 | Boxplot pret pe `fuel_type` | Histograma distributie an |
| 4 | Histograma distributie km | Plot specific piata (vezi sectiunea 7) |
| 5 | Bar chart `transmission_type` | Bar chart `fuel_type` |
| 6 | Bar chart top 8 culori | (rezervat extindere viitoare) |

**Conventii vizuale:**

- `theme_minimal()` consistent
- Culori: `"#3c8dbc"` (blue), `"#00a65a"` (green), `"#f39c12"` (yellow), `"#dd4b39"` (red)
- `scale_x_continuous(labels = comma)` pentru pret, km
- `geom_smooth(method = "lm", color = "red")` pentru scattere
- Titluri scurte in romana

---

## 6. Flux de date si reactivitate

**Schema reactiva:**

```
input$piata
  |
  +--> brand_options (reactive)
  |     +-> SELECT DISTINCT brand FROM <tabel piata>
  |         +-> updateSelectInput pentru "brand"
  |
  +--> input$brand
        |
        +--> date_curente (reactive)
              +-> SELECT * FROM <tabel piata> WHERE brand = ?
                |
                +--> 4 valueBox (KPIs)
                +--> 4 sparkline
                +--> 11 plot principal
```

**Pattern in cod:**

```r
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
```

**Securitate SQL:**

- Numele tabelului: hard-coded via `switch` (sigur, nu vine de la user)
- Valoarea `brand`: prin parametru `?` (sigur, fara SQL injection)

**Validari cu `req()`:**

- `req(input$piata, input$brand)` inainte de query-uri
- `req(nrow(date_curente()) > 0)` inainte de grafice

---

## 7. Diferente intre piete

**Coloane per piata:**

| Coloana | SUA | Germania | India |
|---------|-----|----------|-------|
| `brand`, `model`, `color`, `year`, `price_in_euro`, `km`, `fuel_type`, `transmission_type`, `engine_type` | DA | DA | DA |
| `power_ps` | **NU** | DA | DA |
| `drivetrain` | DA | NU | DA |
| `one_owner` | DA | NU | DA |
| `body_type` | NU | NU | DA |
| `co2_g` | NU | DA | NU |
| `seller_type`, `state` | NU | NU | DA |

**Plot specific piata (rand 4 dreapta):**

```r
output$plot_specific <- renderPlot({
  date <- date_curente()
  if (input$piata == "SUA") {
    ggplot(date, aes(x = engine_type)) +
      geom_histogram(fill = "#f39c12", color = "white", bins = 15) +
      labs(title = "Distributie capacitate motor (litri)",
           x = "Litri", y = "Numar masini") +
      theme_minimal()
  } else {
    ggplot(date %>% filter(!is.na(power_ps), power_ps > 0),
           aes(x = power_ps)) +
      geom_histogram(fill = "#f39c12", color = "white", bins = 20) +
      labs(title = "Distributie putere (PS)",
           x = "Power PS", y = "Numar masini") +
      theme_minimal()
  }
})

output$titlu_box_specific <- renderText({
  if (input$piata == "SUA") "Capacitate motor"
  else "Putere motor (PS)"
})
```

**Coloane neutilizate in aceasta versiune:** `drivetrain`, `one_owner`, `body_type`, `co2_g`,
`seller_type`, `state` — disponibile pentru extindere viitoare daca apare nevoie.

---

## 8. Structura fisier `app.R`

```r
library(shiny)
library(shinydashboard)
library(DBI)
library(RSQLite)
library(tidyverse)
library(scales)

ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Dashboard Auto SH"),
  dashboardSidebar(
    selectInput("piata", ...),
    uiOutput("brand_selector")
  ),
  dashboardBody(
    h2(textOutput("titlu_dinamic")),
    fluidRow(...),       # KPIs + sparkline
    fluidRow(...),       # Rand 1: histograma pret + scatter km
    fluidRow(...),       # Rand 2: scatter an + top10
    fluidRow(...),       # Rand 3: boxplot fuel + hist an
    fluidRow(...),       # Rand 4: hist km + plot specific
    fluidRow(...),       # Rand 5: bars transmisie + fuel
    fluidRow(...)        # Rand 6: bars culori
  )
)

server <- function(input, output, session) {
  brand_options <- reactive({...})
  date_curente <- reactive({...})

  output$brand_selector <- renderUI({...})
  output$titlu_dinamic <- renderText({...})

  # 4 KPIs
  output$kpi_listari <- renderValueBox({...})
  output$kpi_pret <- renderValueBox({...})
  output$kpi_km <- renderValueBox({...})
  output$kpi_varsta <- renderValueBox({...})

  # 4 sparkline
  output$spark_listari <- renderPlot({...})
  output$spark_pret <- renderPlot({...})
  output$spark_km <- renderPlot({...})
  output$spark_varsta <- renderPlot({...})

  # 11 grafice principale
  output$plot_hist_pret <- renderPlot({...})
  output$plot_scatter_km <- renderPlot({...})
  output$plot_scatter_an <- renderPlot({...})
  output$plot_top10_modele <- renderPlot({...})
  output$plot_box_fuel <- renderPlot({...})
  output$plot_hist_an <- renderPlot({...})
  output$plot_hist_km <- renderPlot({...})
  output$plot_specific <- renderPlot({...})
  output$plot_transmisie <- renderPlot({...})
  output$plot_fuel <- renderPlot({...})
  output$plot_culori <- renderPlot({...})

  output$titlu_box_specific <- renderText({...})
}

shinyApp(ui = ui, server = server)
```

**Lungime estimata:** ~400-500 linii cu toate graficele expandate + comentarii in romana.

**Rulare:**

- RStudio: deschide `app.R` → buton "Run App"
- Consola: `shiny::runApp()` cu working directory pe radacina proiectului

---

## 9. Testare si validare

**Smoke test (calea fericita):**

1. Pornire: `app.R` → "Run App" → browser cu dashboard
2. Selecteaza "Germania" → dropdown Brand se populeaza
3. Selecteaza "BMW" → titlu se schimba in "Analiza brand: BMW (Germania)"
4. Cele 4 KPIs afiseaza numere reale (nu `NA`/0)
5. Sparkline-urile apar sub fiecare KPI
6. Cele 11 grafice afisate fara warning-uri in consola

**Edge cases:**

- Schimb piata "Germania" → "SUA": dropdown Brand se reincarca
- Brand cu putine masini (< 10): graficele apar dar pot fi sparse
- Piata "SUA": graficul specific arata "Capacitate motor", NU "Putere PS"
- Piata "Germania"/"India": graficul specific arata "Putere PS"
- Brand cu `power_ps` doar `NULL`: filter() goleste, grafic gol (graceful)

**Verificare consola R:**

- `Listening on http://127.0.0.1:XXXX` — app ruleaza OK
- Absenta `Warning: NAs introduced by coercion`
- Absenta `Error in dbGetQuery`

**Cleanup post-test:**

Conform `AGENTS.md`: fara fisiere de debug/test in proiect dupa rulare.

---

## 10. Out of scope

Urmatoarele NU sunt incluse in aceasta spec (planificate separat):

- **Sectiune Comparatie intre piete** — side-by-side analytics
- **Sectiune Predictor** — modele ML (Regresie Liniara, Random Forest)
- **Tabel DT cu datele brute** — decizie explicita: fara tabel
- **Grafice pentru `drivetrain`, `one_owner`, `body_type`, `co2_g`, `state`, `seller_type`**
- **Plotly** — toate graficele raman ggplot static (interactivitate prin filtre reactive)
- **Performance tuning** — daca brand cu 50.000+ masini face lag, optimizam ulterior
