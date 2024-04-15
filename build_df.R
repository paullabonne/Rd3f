library(dplyr)
library(rvest)
library(lubridate)
library(stringr)
library(zoo)
library(magrittr)
library(tidyr)
library(arrow)

# load the dataset if it has already been created before and just need to be updated
read_parquet('data/df_FF_full.parquet')

# if created for the first time
# df_FF_full = c()

# load the html sources scrapped with the python code
full_html_source <- read_parquet('data/html_source.parquet')

# load the dates
date_range <- unlist(read_feather('data/dates'))
full_html_source %<>%
  filter(date %in% date_range)

# remove potential duplicated days
full_html_source %<>%
  mutate(date_new = as.Date(date, format = "%b%d.%Y")) %>% 
  arrange(date_new) %>%
  na.omit() %>%
  distinct(date_new, .keep_all = TRUE)

missing_days = c()

for (i in 1:length(date_range)) {
  
  page_i <- read_html(full_html_source$source[i])
  
  elements = page_i %>% 
    html_elements(".calendar__table") %>% 
    html_elements(".calendar__row--grey")
  
  if (length(elements) > 0) {
    
    currency <- elements %>%
      html_elements(".calendar__currency") %>%
      html_text2()
    
    event <- elements %>%
      html_elements(".calendar__event") %>%
      html_text2()
    
    forecast <- elements %>%
      html_elements(".calendar__forecast") %>%
      html_text2()
    
    observation <- elements %>%
      html_elements(".calendar__actual") %>%
      html_text2()
    
    previous_obs <- elements %>%
      html_elements(".calendar__previous") %>%
      html_text2()
    
    release_time <- elements %>%
      html_elements(".calendar__time") %>%
      html_text2()
    
    event_id = elements %>%
      html_attr("data-event-id")
    
    impact = elements %>%
      html_elements(".calendar__impact") %>%
      html_elements("span") %>%
      html_attr("title")
    
    details = page_i %>%
      html_elements(".overlay__content")
    
    if (length(details) != length(event_id)) stop("problem")
    
    if (length(details)>0) {
      # getting the details
      
      specs = page_i %>%
        html_elements(".flexBox .specs")
      
      df_details = list()
      
      for (j in 1:length(event_id)) {
        tables = specs[j] %>%
          html_elements("table")
        
        df_details[[j]] = tables[[2]] %>%
          html_table() %>%
          mutate(event_id = event_id[j])
      }
      df_details = bind_rows(df_details)
      df_details %<>% 
        spread(key = X1, value = X2)
      ##
      
      df_day = tibble(currency,
                      event,
                      forecast,
                      observation,
                      previous_obs,
                      release_time,
                      impact,
                      event_id) %>%
        mutate(release_time = ifelse(release_time == "", as.character(NA), release_time)) %>%
        fill(release_time) %>%
        mutate(date = full_html_source$date_new[i],
               release_time = paste0(date, " ", release_time),
               release_time = parse_date_time(release_time, "%Y %m %d %H:%M%p")) %>%
        full_join(df_details, by = "event_id") %>%
        gather(-date, -event_id, -release_time, key = var, value = value)
      
      df_FF_full = rbind(df_FF_full,
                         df_day)
    } else {
      missing_days = c(missing_days, full_html_source$date_new[i])
      print(paste0(full_html_source$date[i], " is missing!"))
      full_html_source %<>%
        filter(date != full_html_source$date[i])
    }
    
  }
  
  # show progress
  show(full_html_source$date_new[i])
  
}

# save
write_parquet(df_FF_full, "data/df_FF_full.parquet")