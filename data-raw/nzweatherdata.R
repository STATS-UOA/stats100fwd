library(tidyverse)

nzweatherdata <- readRDS("data-raw/weatherdata.rds") %>%
  mutate(id = row_number())

usethis::use_data(nzweatherdata, compress = "xz", overwrite = T)

nzweatherdata_training <- nzweatherdata  %>%
  group_by(location) %>%
  sample_frac(0.5) %>%
  ungroup()

nzweatherdata_testing <- nzweatherdata %>%
  anti_join(nzweatherdata_training, by = "id")

usethis::use_data(nzweatherdata_training, compress = "xz", overwrite = T)

usethis::use_data(nzweatherdata_testing, compress = "xz", overwrite = T)
