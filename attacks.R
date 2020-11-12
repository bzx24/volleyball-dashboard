#import packages
library(datavolley)
library(lubridate)
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
  mutate(efficiency = round((kill - unforced_error - blocked_error)/attempts,3)) %>%
  ungroup()

#remove coach
attacks <- subset(attacks, attacks$player_name != "unknown player" & attacks$attempts > 0)

#attack efficiency vs date plot
attack_eff <- ggplot(attacks,
       aes(x= date,
           y= efficiency,
           group=player_name)) +
  labs(y= "Attack Efficiency", x = "Date") +
  geom_point(aes(color = player_name)) +
  geom_line(aes(color = player_name)) +
  geom_hline(yintercept = 0, color = "red")
plot(attack_eff)

#create cumulative stats
attacks_cum <- practice %>%
  filter(skill == "Attack") %>%
  group_by(player_name) %>%
  summarise(kills = sum(evaluation_code == "#"),
            unforced_errors = sum(evaluation_code == "="),
            blocked_errors = sum(evaluation_code == "/"),
            attempts = n()) %>%
  mutate(efficiency = round((kills - unforced_errors - blocked_errors)/attempts, 3))

#remove coach
attacks_cum <- subset(attacks_cum, attacks_cum$player_name != "unknown player" & attacks_cum$attempts > 0)

#cumulative attack efficiency vs date plot
ggplot(attacks_cum, aes(x = player_name, y = efficiency)) +
  labs(y = "Attack Efficiency", x = "Name") +
  geom_bar(stat = "identity", fill = "steelblue")+
  theme_minimal()