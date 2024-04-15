# Rd3f

R code for creating a dataframe out of the [Forex
Factory](https://www.forexfactory.com) online economic calendar.

- `build_df()` creates or update a dataframe out of Forex Factory HTML
  source pages.
- `clean_df()` cleans and categorises the data.

``` r
source("forex.R")
```

``` r
# load the raw dataset generated previously (optional)
df = read_parquet("data/df_ff_raw.parquet")

# set the dates to scrap from forex factory 
date_start = "2024-04-07"
date_end = "2024-04-11"

# update the dataset
df_updated = build_df(date_start, date_end, df) # can be left empty if a new dataframe should be created
```

    [1] "2024-04-07 scraped"
    [1] "2024-04-08 scraped"
    [1] "2024-04-09 scraped"
    [1] "2024-04-10 scraped"
    [1] "2024-04-11 scraped"


     dataframe successfully updated 

``` r
# clean the dataset
df_clean = clean_df(df_updated)
```


     dataframe successfully cleaned 

#### Snapshot of the dataframe

``` r
library(dplyr)
library(knitr)

df_day = df %>%
  filter(date == "2024-04-11")

kable(df_day, format = "html")
```

| currency | event                             | forecast | observation | previous_obs | impact | event_id | date       |
|:---------|:----------------------------------|:---------|:------------|:-------------|:-------|:---------|:-----------|
| GBP      | RICS House Price Balance          | -6%      | -4%         | -10%         | low    | 135799   | 2024-04-11 |
| JPY      | M2 Money Stock y/y                | 2.4%     | 2.5%        | 2.4%         | low    | 139618   | 2024-04-11 |
| AUD      | MI Inflation Expectations         |          | 4.6%        | 4.3%         | low    | 137249   | 2024-04-11 |
| CNY      | CPI y/y                           | 0.4%     | 0.1%        | 0.7%         | medium | 135149   | 2024-04-11 |
| CNY      | PPI y/y                           | -2.8%    | -2.8%       | -2.7%        | medium | 135150   | 2024-04-11 |
| EUR      | Italian Industrial Production m/m | 0.6%     | 0.1%        | -1.4%        | low    | 134726   | 2024-04-11 |
| GBP      | BOE Credit Conditions Survey      |          |             |              | low    | 135702   | 2024-04-11 |
| EUR      | Eurogroup Meetings                |          |             |              | low    | 135586   | 2024-04-11 |
| EUR      | Main Refinancing Rate             | 4.50%    | 4.50%       | 4.50%        | high   | 135510   | 2024-04-11 |
| EUR      | Monetary Policy Statement         |          |             |              | high   | 135511   | 2024-04-11 |
| USD      | Core PPI m/m                      | 0.2%     | 0.2%        | 0.3%         | high   | 136015   | 2024-04-11 |
| USD      | PPI m/m                           | 0.3%     | 0.2%        | 0.6%         | high   | 136014   | 2024-04-11 |
| USD      | Unemployment Claims               | 216K     | 211K        | 222k         | high   | 136537   | 2024-04-11 |
| EUR      | ECB Press Conference              |          |             |              | high   | 135509   | 2024-04-11 |
| USD      | FOMC Member Williams Speaks       |          |             |              | low    | 140132   | 2024-04-11 |
| USD      | FOMC Member Barkin Speaks         |          |             |              | medium | 140140   | 2024-04-11 |
| USD      | Natural Gas Storage               | 14B      | 24B         | -37B         | low    | 135935   | 2024-04-11 |
| GBP      | MPC Member Greene Speaks          |          |             |              | low    | 140133   | 2024-04-11 |
| USD      | 30-y Bond Auction                 |          | 4.67\|2.4   | 4.33\|2.5    | high   | 137320   | 2024-04-11 |
| USD      | FOMC Member Bostic Speaks         |          |             |              | low    | 140141   | 2024-04-11 |

- Note that these data are protected by the
  [copyright](https://www.forexfactory.com/notices#copyrightof) of Fair
  Economy, Inc.
