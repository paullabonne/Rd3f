from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import numpy as np
import pyarrow as pa
import pyarrow.feather as feather
import pyarrow.parquet as pq
import sys
from datetime import datetime
import os

os.chdir(os.path.dirname(__file__))

# load the dates to scrap
date_ref = feather.read_table("data/dates").to_pandas()["date_ref"]

try:
    with open("data/html_source.parquet", "rb") as f:
        arrow_source = pq.read_table(f)
        dates = arrow_source.column(0).to_pylist()
        html_sources = arrow_source.column(1).to_pylist()
except:
    html_sources = []
    dates = []

# launching the browser
from seleniumbase import Driver

options = webdriver.ChromeOptions()
options.add_argument("start-maximized")
driver = Driver(uc=True, incognito=True)

### these are alternative webdrivers
# import undetected_chromedriver as uc
## drver = uc.Chrome(driver_executable_path = "chromedriver", options=options)
# driver.set_page_load_timeout(30000)

# from selenium.webdriver.chrome.service import Service
# options.add_argument('--start-maximized')
# driver = webdriver.Chrome(service=Service(), options=options)
###

# forex factor partial url
ff_url = "https://www.forexfactory.com/calendar?day="

for day in date_ref:
    # url of the day
    ff_day_url = ff_url + day

    # go to the day url
    driver.get(ff_day_url)

    # wait for the page to be fully loaded
    time.sleep(1)
    print(ff_day_url)

    # find events
    calandar_elem_closed = driver.find_elements(
        By.CSS_SELECTOR, ".calendar__cell > [title='Open Detail']"
    )

    # open details section for each event
    while len(calandar_elem_closed) > 0:
        for i in range(0, len(calandar_elem_closed)):
            driver.execute_script("arguments[0].click();", calandar_elem_closed[i])
            time.sleep(0.1)

        # check if some are still closed
        calandar_elem_closed = driver.find_elements(
            By.CSS_SELECTOR, ".calendar__cell > [title='Open Detail']"
        )

    time.sleep(1)
    # store source html
    html_sources.append(driver.page_source)
    dates.append(day)

driver.quit()

arrow_source = pa.Table.from_arrays([dates, html_sources], names=["date", "source"])

# save
with open("data/html_source.parquet", "wb") as f:
    pq.write_table(arrow_source, f, compression="brotli")
