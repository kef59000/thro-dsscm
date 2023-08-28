
# Libraries ---------------------------------------------------------------
# Database access
library(RSQLite)
library(DBI)

# Data Wrangling & Plotting
library(data.table)
library(tidyverse)

# Shiny
library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

# Map
library(leaflet)

# Machine Learning
library(forecast)


# Load Data ---------------------------------------------------------------
con <- dbConnect(RSQLite::SQLite(), 'shipments.db')

shpm <- dbGetQuery(con, "SELECT * FROM shpm") %>%
  as_tibble()


# Modules -----------------------------------------------------------------
source('app_descriptive.R')
source('app_predictive.R')
