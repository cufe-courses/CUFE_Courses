from scrapy.selector import Selector
from scrapy import Spider
from wikiPythonTable.items import Article
class WikiPythonTable(Spider):
    name="table"
    allowed_domains = ["en.wikipedia.org"]
    start_urls = ["http://en.wikipedia.org/wiki/Python_%28programming_language%29"]
    def parse(self, response):
        item = Article()

        table_path = response.xpath('//table[re:test(@class,"wikitable")]/tr')
        for i in range(1, len(table_path)):
            item['datatype'] = table_path[i].xpath('.//td[1]/code/text()').extract()[0]
            item['mutable'] = table_path[i].xpath('.//td[2]/descendant::text()').extract()
            item['description'] = ''.join(table_path[i].xpath('.//td[3]/descendant::text()').extract())
            item['syntax'] = ' '.join(table_path[i].xpath('.//td[4]/descendant::text()').extract())    
            yield item

