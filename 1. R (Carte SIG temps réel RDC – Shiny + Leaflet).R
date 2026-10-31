############################################################
# CARTE SIG TEMPS REEL RDC (SHINY + LEAFLET)
############################################################

library(shiny)
library(leaflet)
library(DBI)
library(RPostgres)
library(dplyr)

# Connexion PostgreSQL
con <- dbConnect(RPostgres::Postgres(),
                 dbname="epidemiologie",
                 host="postgres",
                 user="postgres",
                 password="password")

ui <- fluidPage(
  titlePanel("Surveillance Epidemiologique RDC (Temps Réel)"),
  leafletOutput("map", height = "700px")
)

server <- function(input, output, session){
  
  get_data <- reactivePoll(
    intervalMillis = 3000,
    session,
    checkFunc = function(){
      dbGetQuery(con, "SELECT MAX(date) FROM cas_epidemio")
    },
    valueFunc = function(){
      dbGetQuery(con, "SELECT * FROM cas_epidemio")
    }
  )
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = 23.65, lat = -2.88, zoom = 5)
  })
  
  observe({
    df <- get_data()
    
    leafletProxy("map", data = df) %>%
      clearMarkers() %>%
      addCircleMarkers(
        lng = ~lon,
        lat = ~lat,
        radius = ~cas/50,
        color = "red",
        popup = ~paste0(
          "<b>Région:</b> ", region, "<br>",
          "<b>Cas:</b> ", cas, "<br>",
          "<b>Décès:</b> ", deces
        )
      )
  })
}

shinyApp(ui, server)
