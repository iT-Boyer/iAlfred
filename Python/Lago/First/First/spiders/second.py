# -*- coding: utf-8 -*-
import scrapy
from First.items import FirstItem

class SecondSpider(scrapy.Spider):
    name = 'second'
    allowed_domains = ['lagou']
    start_urls = ['https://www.lagou.com/']

    allowed_domains = ['http://www.lagou.com']
    start_urls = ['https://www.lagou.com/']

    def parse(self, response):
        for item in response.xpath('//div[@class="menu_box"]/div/dl/dd/a'):
            jobClass = item.xpath('text()').extract()#提取文本内容
            jobUrl = item.xpath("@href").extract_first()#提取链接内容

            oneItem = FirstItem()#实例化一个item对象，将获取到的数据存入
            oneItem["jobClass"] =jobClass
            oneItem["jobUrl"] = jobUrl
            yield oneItem#输出item
