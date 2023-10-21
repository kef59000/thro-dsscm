

# Basics ------------------------------------------------------------------
1+1

my_var <- 1
my_var <- "shpm"

my_vec <- c(1,2,3,4,5)

class(my_vec)

# Loop
for (i in 1:10) {
  print(paste("Nummer:", i))
}

if (my_var == 1) {
  print("my_var is 1")
} else if (my_var > 1) {
  print("grosser 1")
} else {
  print("kleiner 1")
}


my_func <- function(my_arg) {
  print(paste0("Hallo ", my_arg))
}

my_func("OTH")


# Data Wrangling ----------------------------------------------------------
library(tidyverse)

shpm <- shipment %>%
  inner_join(customer, by = c("Ship-to2" = "ID")) %>%
  inner_join(plant, by = c("Plant" = "ID"), suffix = c("_customer", "_plant")) %>%
  as_tibble() %>%
  mutate(del_date = dmy(Delivery_day))


head(shpm,5)
shpm %>% head(5)
shpm %>% tail(5)

shpm %>% glimpse()


eda_plant <- shpm %>% select(Plant) %>% distinct()

shpm %>% filter(Plant == 'DE17')

eda_shpm_to <- shpm %>% mutate(tons = GWkg/1000)

eda_temp <- eda_shpm_to %>%
  group_by(Plant) %>%
  summarise(to = sum(tons)) %>%
  ungroup()

eda_temp_wider <- eda_temp %>% pivot_wider(names_from = Plant, values_from = to)
eda_temp_lnger <- eda_temp_wider %>% pivot_longer(cols = everything(), names_to = "Plant", values_to = "to")

eda_temp <- shpm %>%
  group_by(del_date) %>%
  summarise(pal = sum(Pallets, na.rm=TRUE)) %>%
  ungroup()

eda_temp <- shpm %>%
  group_by(del_date, Plant) %>%
  summarise(pal = sum(Pallets, na.rm=TRUE)) %>%
  ungroup()

sum(shpm$GWkg)
min(shpm$GWkg)
mean(shpm$GWkg)
max(shpm$GWkg)


eda_temp <- eda_shpm_to %>%
  group_by(Plant) %>%
  summarise(sum_to = sum(tons, na.rm=TRUE),
            min_to = min(tons, na.rm=TRUE),
            mean_to = mean(tons, na.rm=TRUE),
            max_to = max(tons, na.rm=TRUE)) %>%
  ungroup()

eda_temp %>% fwrite('eda_temp.csv', dec=",", sep=";")


# Data Viz ----------------------------------------------------------------

data <- shpm %>%
  group_by(del_date) %>%
  summarise(pal = sum(Pallets, na.rm=TRUE)) %>%
  ungroup()

ggplot(data) +
  geom_line(aes(x=del_date, y=pal), color="red") +
  theme_bw() +
  labs(x="Date", y="Pallets") +
  ggtitle("Pallets per Day") +
  theme(plot.title=element_text(size=12, face=4, hjust=1))


data <- shpm %>%
  group_by(del_date, Plant) %>%
  summarise(pal = sum(Pallets, na.rm = TRUE)) %>%
  ungroup()

ggplot(data) +
  geom_line(aes(x=del_date, y=pal, color=Plant)) +
  theme_bw() +
  labs(x="Date", y="Pallets") +
  ggtitle("Pallets per Day") +
  theme(plot.title=element_text(size=12, face=4, hjust=1))


ggplot(data) +
  geom_line(aes(x=del_date, y=pal)) +
  theme_bw() +
  labs(x="Date", y="Pallets") +
  ggtitle("Pallets per Day") +
  theme(plot.title=element_text(size=12, face=4, hjust=1)) +
  facet_wrap(~Plant, nrow=1)



ggplot(data) +
  geom_line(aes(x=del_date, y=pal)) +
  theme_bw() +
  labs(x="Date", y="Pallets") +
  ggtitle("Pallets per Day") +
  theme(plot.title=element_text(size=12, face=4, hjust=1)) +
  facet_wrap(~Plant, nrow=1) +
  geom_violin(aes(x=del_date, y=pal), fill="gray80", alpha=0.5)



















