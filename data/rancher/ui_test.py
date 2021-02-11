from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import time

if __name__ == '__main__' :
  driver = webdriver.Firefox()
  wait=WebDriverWait(driver, 5)

  driver.get("https://localhost:10443")
  time.sleep(2)

  # Check page started
  assert "Rancher" in driver.title

  # Initial page: Change password page
  wait.until(EC.visibility_of_element_located((By.XPATH, "//input[@type='password']")))
  inputs = driver.find_elements_by_xpath("//input[@type='password']")

  for input in inputs:
    input.send_keys("123456asdfgh")

  checkboxes = driver.find_elements_by_xpath("//input[@type='checkbox']")
  checkboxes[1].click()

  driver.find_element_by_xpath("//button[@type='submit']").click()

  # Initial page: set the URL
  time.sleep(2)
  wait.until(EC.visibility_of_element_located((By.XPATH, "//button[@type='submit']")))
  driver.find_element_by_xpath("//button[@type='submit']").click()

  # Welcome page
  #driver.get("https://localhost:10443/c/local")
  time.sleep(2)
  wait.until(EC.visibility_of_element_located((By.XPATH, "//div[@class='welcome-copy']")))

  # Cluster explorer
  driver.get("https://localhost:10443/dashboard/c/local")
  time.sleep(2)
  wait.until(EC.visibility_of_element_located((By.XPATH, "//*[contains(text(),'Cluster Explorer')]")))

  driver.close()
