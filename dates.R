library(arrow)
library(stringr)

date_range = seq(as.Date("2023-08-04"), as.Date("2024-02-09"), by = "days")
day_ref = day(date_range)
month_ref = str_to_lower(month(date_range, label = TRUE))
year_ref = year(date_range)
date_ref = paste0(month_ref, day_ref, ".", year_ref)

write_feather(arrow_table(as.data.frame(date_ref)), "data/dates")