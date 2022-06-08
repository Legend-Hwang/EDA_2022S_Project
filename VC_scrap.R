getwd()
setwd("C:/R_selenium/VC_scrap")


install.packages("rJava")


library(rJava)

## R selenium 활용한 "더브이씨" 크롤링 ##
library(RSelenium)
library(seleniumPipes)
library(rvest)
library(httr)
library(dplyr)
library(xml2)
library(writexl)
library(stringr)

# 크롤링테스트 10건 #
url <- "https://thevc.kr"

res <- read_html(url)
Sys.setlocale("LC_ALL", "C") 
tab <- res %>% 
  html_table() %>% 
  .[[1]]
Sys.setlocale("LC_ALL", "Korean")

View(tab)



#  "C:\Selenium" 에서 크롬드라이버 실행, 게코드라이브 실행 후!!
#접속할 사이트 입력한다, 4444, 4445 가끔변한다
## Selenium 시작
rD <- rsDriver(port=3101L,chromever="99.0.4844.51")
remDr <- rD$client


remDr$navigate("https://thevc.kr/auth/login") 


#enter username
element <- remDr$findElement(using = "css", "#input-email")
element$sendKeysToElement(list("smyoon01@hanafn.com"))


#enter password
element <- remDr$findElement(using = "css", "#input-password")
element$sendKeysToElement(list("hanafn~2002*"))

#click login button
pattern <- "#layout-wrap > div > div.vc-responsive-follow.vc-margin-vertical-5.inner > div > div > div.body > form > button" # Chrome Developer
element <- remDr$findElement(using = "css", pattern)
element$clickElement()


for (k in 1:13) {
  # 로그인 후 "더보기" 3번 클릭
  for (i in 1:100) {
    pattern <- "#layout-wrap > div > div:nth-child(4) > div.vc-responsive-fill.vc-margin-top-5 > button" # Chrome Developer
    element <- remDr$findElement(using = "css", pattern)
    element$clickElement()
    
    # 5초간 대기
    Sys.sleep(2)
  }
  
  # 소스페이지 읽기
  txt <- remDr$getPageSource()[[1]]
  res <- read_html(txt)
  
  Sys.setlocale("LC_ALL", "C") 
  tab <- res %>% 
    html_table() %>% 
    .[[1]]
  Sys.setlocale("LC_ALL", "Korean")
  
  #View(tab)
  
  #write_xlsx(tab, "투자TAB3.xlsx")
  
  RST <- str_c("투자TAB", k, ".xlsx")
  write_xlsx(tab, RST)
  
  Sys.sleep(2)
}















