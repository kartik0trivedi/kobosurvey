#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Load libraries
library(shiny)
library(httr)
library(jsonlite)
library(DT)
library(rsconnect)

# Function to fetch KoBo data
fetch_kobo_data <- function(assetid, token, host = Sys.getenv("KOBO_HOST", "kf.kobotoolbox.org")) {
  url <- paste0("https://", host, "/api/v2/assets/", assetid, "/data/?format=json")
  res <- GET(url, add_headers(Authorization = paste("Token", token)))
  stop_for_status(res)
  df <- fromJSON(content(res, "text", encoding = "UTF-8"), flatten = TRUE)
  as.data.frame(df$results)
}

# UI
ui <- fluidPage(
  titlePanel("Intelehealth CBAC Form"),
  DTOutput("table")
)

# Server
server <- function(input, output, session) {
  token <- Sys.getenv("KOBO_TOKEN")      # Read from environment variable
  asset <- Sys.getenv("KOBO_ASSETID")    # Your Form ID
  
  # Fetch data once at startup
  df <- fetch_kobo_data(asset, token)
  
  output$table <- renderDT({
    datatable(df, options = list(pageLength = 10))
  })
}

# Run app
shinyApp(ui, server)

# Deploy app
#rsconnect::deployApp() #commented out to avoid deploying to shinyapps.io - uncomment to deploy or copy paste the code to terminal to deploy to shinyapps.io