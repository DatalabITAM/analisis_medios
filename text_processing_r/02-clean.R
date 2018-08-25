library(tidyverse)
library(stringr)
library(tm)
library(lubridate)

newsdb_fp$fecha <- as_date(newsdb_fp$fecha)

#Limpiamos las fuentes (Juntamos las distintas versiones de una sola fuente)
newsdb_fp$fuente <- str_replace_all(newsdb_fp$fuente,".*ristegui.*","Aristegui Noticias") %>%
  str_replace_all(".*proceso.*","Proceso") %>%
  str_replace_all(".*Norte.*","El Norte") %>%
  str_replace_all(".*Milenio.*","Milenio") %>%
  str_replace_all(".*formador.*","El Informador") %>%
  str_replace_all(".*Animal.*","Animal Político") %>%
  str_replace_all(".*Reforma.*","Reforma") %>%
  str_replace_all(".*mbargo.*","Sin Embargo") %>%
  str_replace_all(".*ublimetro.*","Publímetro") %>%
  str_replace_all(".*no TV.*","Uno TV") %>%
  str_replace_all(".*noTV.*","Uno TV") %>%
  str_replace_all(".*ebate.*","El Debate") %>%
  str_replace_all(".*uff.*","Huffington Post") %>%
  str_replace_all(".*SDP.*","SDP Noticias")

newsdb_fp <- newsdb_fp[!is.na(newsdb_fp$fuente),]

unique(newsdb_fp$fuente)
# Limpiamos los encabezados

# Mapeamos nombres
newsdb_fp$encabezado <- str_replace_all(newsdb_fp$encabezado,"margarita zavala","zavala") %>%
  str_replace_all("enrique peña nieto","epn") %>%
  str_replace_all("peña nieto","epn") %>%
  str_replace_all("peña","epn") %>%
  str_replace_all("andr.s manuel","amlo") %>%
  str_replace_all("l.pez obrador","amlo") %>%
  str_replace_all("ricardo anaya","anaya") %>%
  str_replace_all("jaime rodr.*guez","bronco") %>%
  str_replace_all("felipe calder.n","calderón") %>%
  str_replace_all("eruviel .vila","eruviel") %>%
  str_replace_all("santiago nieto","sant_niet") %>%
  str_replace_all("moreno valle","mor_valle") %>%
  str_replace_all("margarita","zavala") %>%
  str_replace_all("osorio chong","chong") %>%
  str_replace_all("de jes.*s patricio","marichuy") %>%
  str_replace_all("meade","meade")

# Preparamos encabezados para TF-IDF
rwords<-c("van|sólo|días|mil|tres|san|fin|puede|sigue|pide|
          piden|dar|ser|parar|pedir|hacer|dejar|unir|casar|comer|
          tras|sobrar|reconocer|“|”|¿|¡|…")

newsdb_fp <- newsdb_fp %>% 
  mutate(enc_prep = removeWords(encabezado,stopwords("spanish"))) %>% #quitamos stopwords
  mutate(enc_prep = stem_df(enc_prep)) %>% # stemming
  mutate(enc_prep = str_replace_all(enc_prep,rwords,"")) %>% #quitamos mas stopwords
  mutate(enc_prep = removePunctuation(enc_prep)) %>% # quitamos puntuacion
  mutate(enc_prep = removeNumbers(enc_prep)) %>%
  mutate(enc_prep = str_trim(enc_prep)) %>%
  mutate(enc_prep = stripWhitespace(enc_prep))