### Build test data
df2 <- as.data.frame(cbind(c(1:5),
                           c("20120331", "20120401", "20130331", "20130401",
                             "20140331"),
                           c("01042014", "31032015", "01042015", "31032016",
                             "01042016"),
                           c("31-Mar-2017", "01-Apr-2017", "31-Mar-2018",
                             "04-Apr-2018", "31-Mar-2019")))
names(df2) <- c("id", "date.Ymd", "date.dmY", "date.dMY")
df2$date.Ymd <- as.Date(df2$date.Ymd, "%Y%m%d")
df2$date.dmY <- as.Date(df2$date.dmY, "%d%m%Y")
df2$date.dMY <- as.Date(df2$date.dMY, "%d-%B-%Y")


### Test to see if error handling works when variable supplied is not in date
### format
# Test data
df2 <- df2 %>%
  mutate(fyear.1 = fin_year(id))

### Test fn on test data
df2 <- df2 %>%
  mutate(fyear.Ymd = fin_year(date.Ymd),
         fyear.dmY = fin_year(date.dmY),
         fyear.dMY = fin_year(date.dMY))

### Test on several years worth of dates
date_list <- seq(as.Date("01-01-2000", "%d-%m-%Y"), as.Date("31-03-2018", "%d-%m-%Y"), by="days")
fyears <- fin_year(date_list)
table(fyears)
