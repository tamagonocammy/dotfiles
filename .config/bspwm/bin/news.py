#!/usr/bin/python

import requests
import os.path

#path where news are saved in txt (default current directory)
save_path ='/home/cammy/.config/bspwm/bin/news'

#get your api key at https://newsapi.org/
api_key = "2c3192e575fe4623a4968f838908ccc6"

#find sources & country codes at https://newsapi.org/sources
sources = ""
country = "co"

# save_url saves URL so that it is possible to open the news in the browser
# the url will always be the most recent, enable if number_news = 1
save_url = False
number_news = 3

try:
    data = requests.get('https://newsapi.org/v2/top-headlines?apiKey='+api_key+'&sources='+sources+'&country='+country).json()

    news_string = ""

    for x in range(number_news):
      sourceName = data['articles'][x]['source']['name']
      title = data['articles'][x]['title']
      news_string += '['+sourceName+ '] '+ title + ' '   
      
    path = os.path.join(save_path,"current_news.txt")         
    f = open(path, "w")
    f.write(news_string)
    f.close()
    
    if save_url == True:
      url = data['articles'][0]['url']
      path = os.path.join(save_path,"current_url.txt")         
      f = open(path, "w")
      f.write(url)
      f.close() 
      
      
except requests.exceptions.RequestException as e:
    print ('Something went wrong!')
    
    
    
    
    
    
    
    
    
  
    

