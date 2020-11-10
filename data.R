library(datavolley)
library(tidyverse)

#read in 6v6 data
files <- list.files(path = "./6v6_dvw_files", pattern = "\\.dvw$")
x <- read_dv(paste0("./6v6_dvw_files/", files[1]))
data_6v6 <- x$plays
data_6v6$match_id <- 1

if(length(files) > 1) {
  for(i in 2:length(files)) {
    x <- read_dv(paste0("./6v6_dvw_files/", files[i]))
    hold <- x$plays
    hold$match_id <- i
    data_6v6 <- rbind(data_6v6,hold)
  }
}
remove(hold, x, i, files)

#read in passing data
files <- list.files(path = "./servepass_dvw_files", pattern = "\\.dvw$")
x <- read_dv(paste0("./servepass_dvw_files/", files[1]))
data_servepass <- x$plays
data_servepass$match_id <- 1

if(length(files) > 1) {
  for(i in 2:length(files)) {
    x <- read_dv(paste0("./servepass_dvw_files/", files[i]))
    hold <- x$plays
    hold$match_id <- i
    data_servepass <- rbind(data_servepass,hold)
  }
}
remove(hold, x, i, files)