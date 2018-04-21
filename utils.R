library("fastmatch")
library("purrr")

con <- unz("lemmatization-es.zip", "lemmatization-es.txt")
tab <- read.delim(con, header=FALSE, stringsAsFactors = FALSE)
names(tab) <- c("stem", "term")

tab$stem <- lapply(tab$stem,FUN = function(x){
  enc2utf8(x)
})

tab$term <- lapply(tab$term,FUN = function(x){
  enc2utf8(x)
})

# Morena es una palabra importante
tab$stem[352453] <- "morena"

# Construimos un stemmer en español basado en lexiconista

stem_list <- function(sentence){
  word_vec <- strsplit(sentence, " ")
  sapply(word_vec[[1]],stem_word) %>% paste(collapse = " ") %>% return()
}

stem_word <- function(term) {
  i <- fmatch(term, tab$term)
  if (is.na(i)) {
    stem <- term
  } else {
    stem <- tab$stem[i]
  }
  stem
}

stem_df <- function(dataf){
  map_chr(dataf,stem_list)
}

str_remove_all <- function(x,words){
  spaces <- rep("",length(words))
  names(spaces) <- words
  str_replace_all(x,words,spaces)
}

#funcion que recibe el inicio y fin de un mes y genera el inicio y fin del siguiente mes en formato AAAA-MM-DD
gen_fecha_prox_mes <- function(inicio,fin){
  meses31 <- c(1,3,5,7,8,10,12)
  meses30 <- c(4,6,9,11)
  if(month(inicio)==2) return(c(inicio+28,fin+31))
  else{
    if(month(inicio) %in% meses31){
      inicio <- inicio+31
      if(month(fin+1)==2) fin <- fin+28
      else{
        if((month(fin+1)) %in% meses31) fin <- fin+31 else (fin <- fin+30)
      }
    }else{
      inicio <- inicio+30
      if((month(fin+1)) %in% meses31) fin <- fin+31 else (fin <- fin+30)
    }
    return(c(inicio,fin))
  }
}
