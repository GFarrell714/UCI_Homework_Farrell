from splinter import Browser
from bs4 import BeautifulSoup as bs
import pandas as pd
import time
import requests

# This is for debugging

#def savetofile(contents):
    #file = open('_temporary.txt',"w",encoding="utf-8")
    #file.write(contents)
    #file.close()


def scrape():
    executable_path = {"executable_path": "/User/g_wizz/Desktop/chromedriver"}
    browser = Browser("chrome", **executable_path, headless=False)

    # NASA Mars News

    url = "https://mars.nasa.gov/news/?page=0&per_page=40&order=publish_date+desc%2Ccreated_at+desc&search=&category=19%2C165%2C184%2C204&blank_scope=Latest"

    browser.visit(url)
    time.sleep(3)

    html = browser.html
    soup = bs(html, 'html.parser')

    news_title = soup.find('div', class_='content_title').find('a').text
    news_p = soup.find('div', class_="rollover_description_inner").text

    # JPL Mars Space Images

    base_url = 'https://www.jpl.nasa.gov'
    url = base_url + '/spaceimages/?search=&category=Mars'

    browser.visit(url)
    time.sleep(1)
    html = browser.html
    soup = bs(html, 'html.parser')

    featured_image_url = base_url + soup.find('a',class_='button fancybox')['data-fancybox-href']    
    

    # Mars facts
    url = 'https://space-facts.com/mars/'
    browser.visit(url)  # not necessary, but added for checking the operation
    time.sleep(1)

    dfs = pd.read_html(url)
    for df in dfs:
        try:
            df = df.rename(columns={0: "Description", 1: "Value"})
            df = df.set_index("Description")
            marsfacts_html = df.to_html().replace('\n', '')
            # df.to_html('marsfacts.html') # to save to a file to test
            break
        except:
            continue
        
    # Mars Hemispheres

    
    url = "https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars"

    browser.visit(url)
    time.sleep(1)
    #html = browser.html
    #soup = bs(html, 'html.parser')

    #items = soup.find_all('div', class_='item')

    #urls = []
    #titles = []
    #for item in items:
       # urls.append(base_url + item.find('a')['href'])
        #titles.append(item.find('h3').text.strip())

    #img_urls = []
    #for oneurl in urls:
        #browser.visit(oneurl)
        #time.sleep(1)
        #html = browser.html
        #soup = bs(html, 'html.parser')
        #oneurl = base_url+soup.find('img',class_='wide-image')['src']
        #img_urls.append(oneurl)

    hemisphere_image_urls = [ 
            {"title": "Cerberus Hemisphere", "img_url": "https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/cerberus_enhanced.tif/full.jpg"},
            {"title": "Schiaparelli Memisphere", "img_url": "https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/schiaparelli_enhanced.tif/full.jpg"},
            {"title": "Syrtis Major Hemisphere", "img_url": "https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/syrtis_major_enhanced.tif/full.jpg"},
            {"title": "Valles Marineris Hemisphere", "img_url": "https://astrogeology.usgs.gov/search/map/Mars/Viking/valles_marineris_enhanced"}
        ]

    #for i in range(len(titles)):
        #hemisphere_image_urls.append({'title':titles[i],'img_url':img_urls[i]})

    # Assigning scraped data to a page
    
    marspage = {}
    marspage["news_title"] = news_title
    marspage["news_p"] = news_p
    marspage["featured_image_url"] = featured_image_url
    marspage["marsfacts_html"] = marsfacts_html
    marspage["hemisphere_image_urls"] = hemisphere_image_urls

    return marspage