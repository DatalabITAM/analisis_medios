library(tm)
library(RColorBrewer)
library(wordcloud)
library(SnowballC)
library(ggplot2)

# Wordcloud

# funcion que recibe un vector de headlines y genera un wordcloud, removiendo las palabras
# recibidas en el vector rwords
wordcl_tm <- function(headlines, extra_rw = ""){
  rwords<-c(c("van","sólo","días","mil","tres","san","fin","puede","sigue","pide",
            "piden","dar","ser","parar","pedir","hacer","dejar","unir","casar","comer",
            "tras","sobrar","reconocer"),extra_rw)
  tm_encab <- Corpus(VectorSource(headlines))
  toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
  tm_encab <- tm_map(tm_encab, toSpace, "/")
  tm_encab <- tm_map(tm_encab, toSpace, "@")
  tm_encab <- tm_map(tm_encab, toSpace, "\\|")
  tm_encab <- tm_map(tm_encab, removeNumbers)
  tm_encab <- tm_map(tm_encab, removeWords, stopwords("spanish"))
  tm_encab <- tm_map(tm_encab, removeWords, rwords)
  tm_encab <- tm_map(tm_encab, stripWhitespace)
  
  set.seed(1231)
  wordcloud(tm_encab,scale=c(2.5, 0.2),max.words = 50,colors=brewer.pal(12, "Paired"))
  warnings()
  # dtm <- TermDocumentMatrix(docs)
  # m <- as.matrix(dtm)
  # v <- sort(rowSums(m),decreasing=TRUE)
  # d <- data.frame(word = names(v),freq=v)
  
  # wordcloud(words = d$word, freq = d$freq, min.freq = 1,
  #           max.words=200, random.order=FALSE, rot.per=0.35, 
  #           colors=brewer.pal(8, "Dark2"))
}

# análisis temporal de menciones

# función que recibe un keyword y grafíca su frecuencia en los medios principales usando la 
# base newsdb_fp
frecuenciaenmedios <- function(kw){
  news_kw <- newsdb_fp[str_detect(newsdb_fp$encabezado,kw),]
  frec_kw <- table(news_kw$fuente)
  ggplot(news_kw,aes(fuente)) + 
    geom_bar(aes(y = (..count..)))
}