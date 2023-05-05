import undetected_chromedriver as uc
from selenium import webdriver
from selenium.webdriver.common.by import By
import time
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import numpy as np
import pandas as pd
import pyarrow.feather as feather
import pyarrow as pa
import sys
from datetime import datetime
import os

os.chdir("code/rpyd3f")

date_ref = feather.read_table('data/dates').to_pandas()["date_ref"]

try:
  with open('data/arrow_source', 'rb') as f:
    arrow_source = feather.read_table(f)
    dates = arrow_source.column(0).to_pylist()
    html_sources = arrow_source.column(1).to_pylist()
except:
  html_sources = []
  dates = []
    
# launching the webdriver
options = webdriver.ChromeOptions() 
options.add_argument("start-maximized")
driver = uc.Chrome(options=options)
driver.set_page_load_timeout(30000)

date_ref_1 = date_ref[date_ref[date_ref == 'apr26.2010'].index[0]]
    
# forex factor partial url
ff_url = 'https://www.forexfactory.com/calendar?day='

for day in date_ref_1 :
  # url of the day
  ff_day_url = ff_url + day
    
  # go to the day url
  driver.get(ff_day_url)
  time.sleep(1)
  
  # find events
  calandar_elem_closed = driver.find_elements(By.CSS_SELECTOR, ".calendar_row > .detail > [title='Open Detail']")
    
  # open details section for each event
  while len(calandar_elem_closed)>0 :
    for i in range(0,len(calandar_elem_closed)) :
      driver.execute_script("arguments[0].click();", calandar_elem_closed[i]) 
      time.sleep(0.1)

    # check if some are still closed
    calandar_elem_closed = driver.find_elements(By.CSS_SELECTOR, ".calendar_row > .detail > [title='Open Detail']")

  time.sleep(1)  
  # store source html
  html_sources.append(driver.page_source)
  dates.append(day)

driver.quit()

arrow_source = pa.Table.from_arrays([dates, html_sources], names=["date", "source"])

with open('data/arrow_source', 'wb') as f:
    feather.write_feather(arrow_source, f)