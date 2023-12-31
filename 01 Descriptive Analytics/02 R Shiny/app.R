
setwd("/Users/kefo395/coding/thro-dsscm/01 Descriptive Analytics/02 R Shiny")

source('app_global.R')


ui <- dashboardPage(skin="green",
                    dashboardHeader(title = "BA-SCM App"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Descriptive Analytics", tabName = "descriptive_analytics", icon=icon("dashboard")),
                        menuItem("Predictive Analytics", tabName = "predictive_analytics", icon=icon("chart-line"))
                      )
                    ),
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = "descriptive_analytics", descriptive_analytics_UI("descriptive_analytics")),
                        tabItem(tabName = "predictive_analytics", predictive_analytics_UI("predictive_analytics"))
                      )
                    ))


server <- function(input, output) {
  
  callModule(descriptive_analytics, "descriptive_analytics")
  callModule(predictive_analytics, "predictive_analytics")
  
}


shinyApp(ui = ui, server = server)
