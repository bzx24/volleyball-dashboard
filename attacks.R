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
attacks <- data_6v6 %>%
  filter(skill == "Attack") %>%
  group_by(player_name) %>%
  mutate(attack_kill = sum(evaluation == "Winning attack"),
         attack_error = sum(evaluation %in% c("Blocked", "Error"))) %>%
  group_by(player_name,
           attack_kill,
           attack_error) %>%
  summarise(attack_att = n()) %>%
  mutate(attack_eff = (attack_kill - attack_error) / attack_att)

#remove coach
attacks <- attacks[-c(9),]

