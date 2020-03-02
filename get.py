

import requests
from bs4 import BeautifulSoup as BS
import nltk


def News(ticker):
    B = BS(requests.get(f"https://www.wsj.com/market-data/quotes/{ticker}", headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36'}).content, features="html.parser")
    News = B.find('ul', {'id': "newsSummary_c"})
    News = [a.getText() for a in News.find_all('a')]
    News = [nltk.word_tokenize(h) for h in News]
    return News
                  
                  