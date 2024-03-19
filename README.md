rpyd3f
================

R and Python code for creating a dataframe out of the [Forex
Factory](https://www.forexfactory.com) online economic calendar.

- The `Python` code in `get_ff.py` scraps the html source page of the
  economic calendar for each day.
- The `R` code in `build_ff.Rmd` creates a dataframe out of these html
  source pages.
- The `R` code in `cleaning.Rmd` cleans the data and categorises the
  variables into groups, i.g. inflation.  
- The `R` code in `summary.Rmd` provides a summary of the resulting
  dataset.
- The data are saved with the Apache
  [parquet](https://arrow.apache.org/docs/python/parquet.html) so they
  can be loaded with different environment, e.g. `R`, `Pyhton`, `Matlab`
  etc.

``` r
df = arrow::read_parquet("data/df_FF_clean.parquet")

knitr::kable(tail(df), format = "html")
```

<table>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:left;">
date
</th>
<th style="text-align:left;">
release_time
</th>
<th style="text-align:left;">
geo
</th>
<th style="text-align:left;">
currency
</th>
<th style="text-align:left;">
event
</th>
<th style="text-align:left;">
event_id
</th>
<th style="text-align:left;">
impact
</th>
<th style="text-align:left;">
Description
</th>
<th style="text-align:left;">
FF Notes
</th>
<th style="text-align:left;">
FF Notice
</th>
<th style="text-align:left;">
Frequency
</th>
<th style="text-align:left;">
Measures
</th>
<th style="text-align:right;">
forecast
</th>
<th style="text-align:right;">
observation
</th>
<th style="text-align:right;">
previous_obs
</th>
<th style="text-align:right;">
error
</th>
<th style="text-align:right;">
change
</th>
<th style="text-align:left;">
freq
</th>
<th style="text-align:left;">
target
</th>
<th style="text-align:left;">
type
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
54488
</td>
<td style="text-align:left;">
2024-02-09
</td>
<td style="text-align:left;">
2024-02-09 08:00:00
</td>
<td style="text-align:left;">
China
</td>
<td style="text-align:left;">
CNY
</td>
<td style="text-align:left;">
new loans
</td>
<td style="text-align:left;">
135170
</td>
<td style="text-align:left;">
Medium Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Source does not have a reliable release schedule - this event will be
listed with a date range or as ‘Tentative’ until the data is released;
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, about 11 days after the month ends;
</td>
<td style="text-align:left;">
Value of new yuan-denominated loans issued to consumers and businesses
during the previous month;
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
4.92e+12
</td>
<td style="text-align:right;">
1.17e+12
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
3.75e+12
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Jan 2024
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
54489
</td>
<td style="text-align:left;">
2024-02-09
</td>
<td style="text-align:left;">
2024-02-09 08:00:00
</td>
<td style="text-align:left;">
China
</td>
<td style="text-align:left;">
CNY
</td>
<td style="text-align:left;">
m2 money supply y/y
</td>
<td style="text-align:left;">
135169
</td>
<td style="text-align:left;">
Low Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
Source does not have a reliable release schedule - this event will be
listed with a date range or as ‘Tentative’ until the data is released;
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, about 11 days after the month ends;
</td>
<td style="text-align:left;">
Change in the total quantity of domestic currency in circulation and
deposited in banks;
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
8.70e+00
</td>
<td style="text-align:right;">
9.70e+00
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
-1.00e+00
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Jan 2024
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
54490
</td>
<td style="text-align:left;">
2024-02-09
</td>
<td style="text-align:left;">
2024-02-09 08:00:00
</td>
<td style="text-align:left;">
Germany
</td>
<td style="text-align:left;">
EUR
</td>
<td style="text-align:left;">
final cpi m/m
</td>
<td style="text-align:left;">
139363
</td>
<td style="text-align:left;">
Low Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
The ‘Previous’ listed is the ‘Actual’ from the Preliminary release and
therefore the ‘History’ data will appear unconnected. There are 2
versions of CPI released about 15 days apart - Preliminary and Final.
The Preliminary release is the earliest and thus tends to have the most
impact;
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, about 11 days after the month ends;
</td>
<td style="text-align:left;">
Change in the price of goods and services purchased by consumers;
</td>
<td style="text-align:right;">
0.2
</td>
<td style="text-align:right;">
2.00e-01
</td>
<td style="text-align:right;">
2.00e-01
</td>
<td style="text-align:right;">
0.0
</td>
<td style="text-align:right;">
0.00e+00
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Jan 2024
</td>
<td style="text-align:left;">
inflation
</td>
</tr>
<tr>
<td style="text-align:left;">
54491
</td>
<td style="text-align:left;">
2024-02-09
</td>
<td style="text-align:left;">
2024-02-09 10:00:00
</td>
<td style="text-align:left;">
Italy
</td>
<td style="text-align:left;">
EUR
</td>
<td style="text-align:left;">
industrial production m/m
</td>
<td style="text-align:left;">
134724
</td>
<td style="text-align:left;">
Low Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, about 40 days after the month ends;
</td>
<td style="text-align:left;">
Change in the total inflation-adjusted value of output produced by
manufacturers, mines, and utilities;
</td>
<td style="text-align:right;">
0.8
</td>
<td style="text-align:right;">
1.10e+00
</td>
<td style="text-align:right;">
-1.30e+00
</td>
<td style="text-align:right;">
-0.3
</td>
<td style="text-align:right;">
2.40e+00
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Dec 2023
</td>
<td style="text-align:left;">
economic growth
</td>
</tr>
<tr>
<td style="text-align:left;">
54492
</td>
<td style="text-align:left;">
2024-02-09
</td>
<td style="text-align:left;">
2024-02-09 14:30:00
</td>
<td style="text-align:left;">
Canada
</td>
<td style="text-align:left;">
CAD
</td>
<td style="text-align:left;">
employment change
</td>
<td style="text-align:left;">
138082
</td>
<td style="text-align:left;">
High Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
This is vital economic data released shortly after the month ends. The
combination of importance and earliness makes for hefty market impacts;
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, about 8 days after the month ends;
</td>
<td style="text-align:left;">
Change in the number of employed people during the previous month;
</td>
<td style="text-align:right;">
16.0
</td>
<td style="text-align:right;">
3.73e+01
</td>
<td style="text-align:right;">
1.00e-01
</td>
<td style="text-align:right;">
-21.3
</td>
<td style="text-align:right;">
3.72e+01
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Jan 2024
</td>
<td style="text-align:left;">
employment
</td>
</tr>
<tr>
<td style="text-align:left;">
54493
</td>
<td style="text-align:left;">
2024-02-09
</td>
<td style="text-align:left;">
2024-02-09 14:30:00
</td>
<td style="text-align:left;">
Canada
</td>
<td style="text-align:left;">
CAD
</td>
<td style="text-align:left;">
unemployment rate
</td>
<td style="text-align:left;">
138083
</td>
<td style="text-align:left;">
High Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, about 8 days after the month ends;
</td>
<td style="text-align:left;">
Percentage of the total work force that is unemployed and actively
seeking employment during the previous month;
</td>
<td style="text-align:right;">
5.9
</td>
<td style="text-align:right;">
5.70e+00
</td>
<td style="text-align:right;">
5.80e+00
</td>
<td style="text-align:right;">
0.2
</td>
<td style="text-align:right;">
-1.00e-01
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Jan 2024
</td>
<td style="text-align:left;">
employment
</td>
</tr>
</tbody>
</table>
