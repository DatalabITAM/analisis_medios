# Se leen todos los archivos .csv de la carpeta /google_rss_DBs/ y se juntan en el tibble
# newsdb, eliminando los valores duplicados tomando la variable head

library(tidyverse)

archivos <- list.files("google_rss_DBs/",pattern="*.csv")

newsdb <- archivos %>% 
            map(function(x) { read_csv(paste0("./google_rss_DBs/", x)) }) %>%
            reduce(rbind) %>%
            filter(! duplicated(head))