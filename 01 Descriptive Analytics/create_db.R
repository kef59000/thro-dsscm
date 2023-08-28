
library(RSQLite)
library(DBI)

library(data.table)


csv_customer <- fread("thro_shpm_csv/customer.csv", sep=";", header = TRUE, encoding = 'Latin-1')
csv_plant <- fread("thro_shpm_csv/plant.csv", sep=";", header = TRUE, encoding = 'Latin-1')
csv_shipment <- fread("thro_shpm_csv/shipment.csv", sep=";", header = TRUE, encoding = 'Latin-1')


con <- dbConnect(RSQLite::SQLite(), 'test_db.db')


dbWriteTable(con, "customer", csv_customer)
dbWriteTable(con, "plant", csv_plant)
dbWriteTable(con, "shipment", csv_shipment)


customer <- dbGetQuery(con, "SELECT * FROM customer")
plant <- dbGetQuery(con, "SELECT * FROM plant")
shipment <- dbGetQuery(con, "SELECT * FROM shipment")

dbDisconnect(con)