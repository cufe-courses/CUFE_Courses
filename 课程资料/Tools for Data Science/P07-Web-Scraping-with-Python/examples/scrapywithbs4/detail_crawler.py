#!/usr/bin/python3
# -*- coding: utf-8 -*-

####################################################################
# @Author: {Feng Li}
# @Date:   {2017-04-01}
# @Description: {Scrape news details for a give company from sina}
####################################################################


import logging
import requests
import sys

from bs4 import BeautifulSoup




def get_body(href):
    """Function to retrieve news content given its url.

    Args:
        href: url of the news to be crawled.

    Returns:
        content: the crawled news content.

    """
    html = requests.get(href)
    soup = BeautifulSoup(html.content, 'html.parser')
    div = soup.find('div', {"id": "artibody"})
    paras = div.findAll('p')
    content = ''
    for p in paras:
        ptext = p.get_text().strip().replace("\n", "")
        content += ptext
    return content



if __name__ == "__main__":
    logging.getLogger().setLevel(logging.INFO)
    # Getting and printing content for each url in the crawled web list pages
    for line in sys.stdin:
        title, date, source, abstract, href = line.strip().split('\001')
        # Printing progress onto console
        logging.info('Scraping ' + href)
        content = get_body(href)
        print('\001'.join([title, date, source, abstract, href, content]))
