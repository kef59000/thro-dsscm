
setwd("/Users/kefo395/Library/CloudStorage/Dropbox/Uni/Uni Regensburg/Lehre/01 Lehrveranstaltungen/02 Master/05 BA-SCM/ba_scm")

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
