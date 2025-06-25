# -*- coding: utf-8 -*-
import scrapy
from wikiSpider.items import WikiSpiderItem

class titleSpider(scrapy.Spider):
    name="title"
    allowed_domains = ["en.wikipedia.org"]
    start_urls = ["https://en.wikipedia.org/wiki/Main_Page",
                  "https://en.wikipedia.org/wiki/Python_%28programming_language%29"]
    def parse(self, response):
        item = WikiSpiderItem()
        title = response.xpath('//h1/text()')[0].extract()
        
        item['title'] = title
        yield(item)
