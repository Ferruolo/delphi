#!/usr/bin/env python
# coding: utf-8



from nltk.tokenize import sent_tokenize, word_tokenize 
import requests
from bs4 import BeautifulSoup
import gensim

w2v = gensim.models.KeyedVectors.load_word2vec_format("text_resources/w2vfile", binary=True)
