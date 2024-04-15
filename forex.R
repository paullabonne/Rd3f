library(dplyr)
library(rvest)
library(lubridate)
library(stringr)
library(zoo)
library(magrittr)
library(tidyr)
library(arrow)
library(sjmisc) # str_contain

############################################################
###### generate the format of dates used in forex factory html links

gen_dates <- function(date_start, data_end) {
  date_range <- seq(as.Date(date_start), as.Date(data_end), by = "days")
  day_ref <- day(date_range)
  month_ref <- str_to_lower(month(date_range, label = TRUE))
  year_ref <- year(date_range)
  date_ref <- paste0(month_ref, day_ref, ".", year_ref)

  return(date_ref)
}

############################################################
###### creating or updating the dataframe from the html sources

build_df <- function(date_start, date_end, df = NULL, save = TRUE) {
  # if df is not given a dataset is created, otherwise df is updated
  # only a raw dataset (an output of function build_df()) can be updated.

  # generate dates used for html links
  dates <- gen_dates(date_start, date_end)

  if (is.null(df)) {
    df_ff_raw <- c()
  } else {
    df_ff_raw = df
  }

  for (i in 1:length(dates)) {
    page_link <- paste0("https://www.forexfactory.com/calendar?day=", dates[i])

    elements <- read_html(page_link) %>%
      html_elements(".calendar__table") %>%
      html_elements(".calendar__row--grey")

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

    impact <- elements %>%
      html_elements(".calendar__impact") %>%
      html_elements("span") %>%
      html_attr("class")
    
    impact = sub(".*-", "", impact)

    impact = str_replace_all(impact, "yel", "low")
    impact = str_replace_all(impact, "ora", "medium")
    impact = str_replace_all(impact, "red", "high")

    event_id <- elements %>%
      html_attr("data-event-id")

    df_day <- tibble(
      currency,
      event,
      forecast,
      observation,
      previous_obs,
      impact,
      event_id
    ) %>%
      mutate(date = as.Date(dates[i], format = "%b%d.%Y"))

    df_ff_raw <- rbind(
      df_ff_raw,
      df_day
    )

    # show progress
    print(paste(as.character(as.Date(dates[i], format = "%b%d.%Y")), "scraped"))
  }

  # remove duplicates
  df_ff_raw %<>%
  distinct()

  if (save) {
    write_parquet(df_ff_raw, "data/df_ff_raw.parquet")
  }

  message("\n dataframe successfully updated \n")

  return(df_ff_raw)
}


############################################################
###### cleaning
clean_df <- function(df) {
  df_ff <- df %>%
    mutate(
      event = tolower(event),
      geo = NA,
      geo = ifelse(currency == "AUD", "Australia", geo),
      geo = ifelse(currency == "USD", "USA", geo),
      geo = ifelse(currency == "CHF", "Switzerland", geo),
      geo = ifelse(currency == "GBP", "UK", geo),
      geo = ifelse(currency == "EUR", "Euro Area", geo),
      geo = ifelse(currency == "CAD", "Canada", geo),
      geo = ifelse(currency == "NZD", "New Zealand", geo),
      geo = ifelse(currency == "CNY", "China", geo),
      geo = ifelse(grepl("french", event), "France", geo),
      geo = ifelse(grepl("italian", event), "Italy", geo),
      geo = ifelse(grepl("spanish", event), "Spain", geo),
      geo = ifelse(grepl("german", event), "Germany", geo),
      event = str_remove(event, "french "),
      event = str_remove(event, "italian "),
      event = str_remove(event, "german "),
      event = str_remove(event, "spanish ")
    ) %>%
    filter(!is.na(geo))

  # cleaning numbers
  df_ff %<>%
    gather(forecast, observation, previous_obs, key = var, value = value) %>%
    mutate(
      value = str_remove(value, "%"),
      value = str_replace(value, "K", "000"),
      value = str_replace(value, "M", "000000"),
      value = str_replace(value, "B", "000000000"),
      value = str_remove(value, "<"),
      value = as.numeric(value)
    ) %>%
    pivot_wider(names_from = var, values_from = value) %>%
    relocate(date, geo, currency)

  # keeping only data event (excluding speeches and meetings for instance)
  df_ff %<>%
    filter(!is.na(observation))

  # finding problematic events (duplicates) and dropping them to keep only single events
  df_ff %<>%
    mutate(index = 1:nrow(df_ff)) %>%
    group_by(date, geo, event) %>%
    mutate(id_drop = ifelse(n() > 1 & index == max(index), 1, 0)) %>%
    ungroup() %>%
    filter(id_drop == 0) %>%
    select(-id_drop, -index)

  ############################################################
  ###### add some variables to the dataset

  # creating forecast error variable
  df_ff %<>%
    mutate(error = forecast - observation)

  # creating change variable
  df_ff %<>%
    mutate(change = observation - previous_obs)

  ############################################################
  ###### creating categories
  infl <- c(
    "price", "infl", "cpe", "cpi", "pce", "ppi", "pi", "hpi",
    "wage", "earnings", "earning", "wpi", "inflation", "labor cost", "cost"
  )

  empl <- c("employment", "unemployment", "claim", "claimant", "job", "labor market")

  econ_g <- c(
    "gdp", "ip", "manufacturing", "vehicle sales", "construction",
    "services", "orders", "retail sales", "economic expectations",
    "leading index", "wholesale sales", "cbi", "industrial new orders",
    "credit card spending", "capacity utilization", "corporate profits", "production", "spending", "income"
  )

  housing <- c("mortgage", "home", "building", "housing", "house", "home loans")

  confidence <- c("confidence", "sentiment", "climate", "pmi", "richmond", "chicago", "optimism", "manufacturing index", "empire state", "nfib")

  monetary_pol <- c("rate")

  df_ff %<>%
    group_by(geo, event) %>%
    mutate(
      type = NA,
      type = ifelse(any(str_contains(event, monetary_pol)) & is.na(type), "monetary_pol", type),
      type = ifelse(any(str_contains(event, empl)), "employment", type),
      type = ifelse(any(str_contains(event, econ_g)), "economic growth", type),
      type = ifelse(any(str_contains(event, confidence)), "confidence", type),
      type = ifelse(any(str_contains(event, housing)), "housing", type),
      type = ifelse(any(str_contains(event, infl)), "inflation", type),
      type = ifelse(event == "empire state manufacturing index", "confidence", type)
    ) %>%
    ungroup() %>%
    arrange(date)

  # save
  write_parquet(df_ff, "data/df_ff.parquet")

  message("\n dataframe successfully cleaned \n")

  return(df_ff)
}