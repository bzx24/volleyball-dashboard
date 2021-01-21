library(datavolley)
library(lubridate)
library(tidyverse)

#read in serve and pass data
files <- grep(list.files(path = "Data"), pattern = "\\_6v6.dvw$", invert = TRUE, value = TRUE)
x <- read_dv(paste0("./Data/", files[1]))
serve_pass <- x$plays
serve_pass$date <- as_date(x$meta$match$date)

for(i in 2:length(files)) {
  x <- read_dv(paste0("./Data/", files[i]))
  hold <- x$plays
  hold$date <- as_date(x$meta$match$date)
  serve_pass <- rbind(serve_pass,hold)
}
remove(hold, x, i, files)

#creating serving metric