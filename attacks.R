#import packages
library(datavolley)
library(lubridate)
library(dplyr)
library(tidyverse)

#read in 6v6 data
files <- list.files(path = "./data", pattern = "\\_6v6.dvw$")
x <- read_dv(paste0("./data/", files[1]))
practice <- x$plays
practice$date <- as_date(x$meta$match$date)

for(i in 2:length(files)) {
    x <- read_dv(paste0("./data/", files[i]))
    hold <- x$plays
    hold$date <- as_date(x$meta$match$date)
    practice <- rbind(practice,hold)
  }
remove(hold, x, i, files)

#create attack efficiency metric
attacks <- practice %>%
  filter(skill == "Attack") %>%
  group_by(player_name, date) %>%
  summarise(kill = sum(evaluation_code == "#"),
            unforced_error = sum(evaluation_code == "="),
            blocked_error = sum(evaluation_code == "/"),
            attempts = n()) %>%
  arrange(date) %>%
  mutate(kills_cum = cumsum(kill),
         unforced_errors_cum = cumsum(unforced_error),
         blocked_errors_cum = cumsum(blocked_error),
         attempts_cum = cumsum(attempts),
         efficiency = round((kill - unforced_error - blocked_error)/attempts,3),
         efficiency_cum = round((kills_cum - unforced_errors_cum - blocked_errors_cum)/attempts_cum, 3))

#remove coach
attacks <- subset(attacks, attacks$player_name != "unknown player")
