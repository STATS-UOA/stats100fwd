library(tidyverse)
library(lubridate)

# https://www.stats.govt.nz/large-datasets/csv-files-for-download/

# release calender stats nz
# https://www.stats.govt.nz/release-calendar/

# use 20th of the current month for when new data avail

cur_date <- Sys.Date()
cur_day <- day(cur_date)
pre_date <- cur_date - months(2)
if(cur_day > 20){
  pre_date <- cur_date - months(1)
}

pre_month <- month(pre_date, label = TRUE, abbr = FALSE)
pre_year <- year(pre_date)

url_template <- "https://www.stats.govt.nz/assets/Uploads/Food-price-index/Food-price-index-month1-year/Download-data/food-price-index-month2-year-weighted-average-prices-csv.csv"

url <- url_template %>%
  str_replace("month1", pre_month %>% as.character())  %>%
  str_replace("month2", pre_month %>% as.character() %>% str_to_lower()) %>%
  str_replace_all("year", pre_year %>% as.character())

url <- "https://www.stats.govt.nz/assets/Uploads/Food-price-index/Food-price-index-September-2023/Download-data/food-price-index-september-2023-weighted-average-prices.csv"

nzfoodprices <- read_csv(url) %>%
  mutate(date = ymd(case_when(
    str_sub(Period, start= -2) == ".1" ~ paste0(Period,"0.1"),
    TRUE ~ paste0(Period,".1")))) %>%
  rename(value = Data_value, food = Series_title_1) %>%
  select(date, value, food) %>%
  mutate(food = food %>% str_remove_all(","))

usethis::use_data(nzfoodprices, compress = "xz", overwrite = T)
