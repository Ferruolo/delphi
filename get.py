
import requests
import io
import pandas
from bs4 import BeautifulSoup as BS
import nltk


def News(ticker):
    B = BS(requests.get(f"https://www.wsj.com/market-data/quotes/{ticker}", headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36'}).content, features="html.parser")
    News = B.find('ul', {'id': "newsSummary_c"})
    News = [a.getText() for a in News.find_all('a')]
    News = [nltk.word_tokenize(h) for h in News]
    return News
                  

api_key = 'MZE3U0MSR1DCE53Z'


def weekly(ticker, outputsize = 'compact'):
    return pandas.read_csv(io.StringIO(requests.get(f'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&&symbol={ticker}&apikey={api_key}&outputsize={outputsize}&datatype=csv').content.decode('utf-8')))
    
  

def intraday_data(ticker, time='1min', outputsize = 'compact'):
    return pandas.read_csv(io.StringIO(requests.get(f'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol={ticker}&interval={time}&apikey={api_key}&outputsize={outputsize}&datatype=csv').content.decode('utf-8')))


def tickers():
    return pandas.read_csv("NYSE_TICKERS.csv").iloc[:,0]
    00