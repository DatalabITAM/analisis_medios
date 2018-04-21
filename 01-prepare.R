library(tidyverse)
library(stringr)
library("tidyr")
library("tidytext")

names(newsdb)[1] <- "fecha"

newsdb <- newsdb %>%
            separate(head,c("encabezado","fuente")," - ") %>%
            mutate(encabezado = tolower(encabezado)) %>%
            mutate(incompleta = str_detect(encabezado,"\\.\\.\\.$")) %>%
            mutate(link = gsub(".*url=","",link))

# Guardamos las fuentes únicas
fuentes_unicas <- unique(newsdb$fuente)

# Tabla de frecuencia de aparición de cada fuente
fuente_frec <- table(newsdb$fuente)

# Removemos las que aparecen solo una vez
fuente_frec_1 <- names(fuente_frec[fuente_frec==1])
newsdb <- newsdb[ ! newsdb$fuente %in% fuente_frec_1, ]

fuentes_principales <- c("niversal|ilenio|lsior|mbargo|roceso|nformador|eforma|Norte|nimal|inanciero|eforma|ristegui|uff|blimetro|conomista|Uno|SDP")
# falta debate.com.mx porque crasheaba al no tener datos de anaya

excluir <- c("olombia|erú|hile|SéUno|unom|L'|reece|enezuela|anada|eracruz|másU|UK")

newsdb_fp <- filter(newsdb,str_detect(fuente,fuentes_principales)) %>%
  filter(!str_detect(fuente,excluir))
