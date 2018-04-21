# Function to fetch the rss feed and return the parsed RSS
import time
import datetime
import feedparser
import pandas as pd

def parseRSS( rss_url ):
    return feedparser.parse( rss_url ) 

def getHedlineFeed( rss_url ):
    headlines = []
    
    feed = parseRSS( rss_url )
    for newsitem in feed['items']:
        head = newsitem['title']
        date = newsitem['published_parsed']
        link = newsitem['link']

        headlines.append({'head':head, 'date':str(time.strftime('%Y-%m-%d', date)), 'link':link})
    
    return headlines
 
# A list to hold all headlines
allheadlines = []

keywords = [
    "PRI","PAN","PRD","MORENA","MARGARITA","ZAVALA","AMLO","ANDRES MANUEL","LOPEZ OBRADOR","OSORIO CHONG",
    "MARICHUY","JAIME RODRIGUEZ","RODRIGUEZ CALDERON","EL BRONCO","MEADE","NARRO","ERUVIEL","ANAYA","EPN",
    "ENRIQUE PENA NIETO"
]
medios = [
    "www.eluniversal.com.mx","www.proceso.com.mx","www.excelsior.com.mx","www.informador.com.mx","www.reforma.com",
    "www.animalpolitico.com","www.sinembargo.mx","www.milenio.com","www.elnorte.com","www.sdpnoticias.com",
    "aristeguinoticias","huffingtonpost","unotv","www.debate.com.mx","publimetro"
]

urlnews = []

# Generates a list of desired urls to query
for j in range(len(keywords)):
    urlnews.append("https://news.google.com.mx/news/feeds?q="+keywords[j]+"&output=rss&num=250&ie=utf-8")
    for k in range(len(medios)):
        urlnews.append("https://news.google.com.mx/news/feeds?q="+keywords[j]+"+and+"+medios[k]+"&output=rss&num=250&ie=utf-8")
 
 
# Iterate over the feed urls
for url in urlnews:
    # Call getHedlineFeed() and combine the returned headlines with allheadlines
    allheadlines.extend( getHedlineFeed( url ) )

news_df = pd.DataFrame(allheadlines)

csv_file_name = "/Users/alfredolozano/Dropbox/FredoDatalab/google_rss_DBs/" + \
    datetime.date.today().strftime("%d%m%Y") + ".csv"

news_df.to_csv(path_or_buf = csv_file_name, index = False, encoding='UTF-8')
