import scrapy
from Movies.items import MoviesItem


class MovieSpider(scrapy.Spider):
    name = 'movie'

    allowed_domains = []
    start_urls = ['http://www.66ys.tv/']

    def parse(self, response):
        for item in response.xpath('//div[@class="menutv"]/ul/li/a'):
            movClass = item.xpath('string()').extract()
            movUrl = item.xpath("@href").extract_first()
            oneItem = MoviesItem()
            oneItem["movClass"] =movClass
            oneItem["movUrl"] = movUrl
            for i in range(150):
                mvUrl2 = movUrl+str('index_%s.html'%i)
                try:
                    yield scrapy.Request(url=mvUrl2,
                                         callback=lambda response, mvclass=movClass: self.parse_url(response, mvclass))
                except:
                    pass
            # yield scrapy.Request(url=movUrl,callback=lambda response,mvclass=movClass: self.parse_url(response,mvclass))

    def parse_url(self, response,mvclass):

        for sel2 in response.xpath('//div[@class="listBox"]/ul/li'):
            imgurl = sel2.xpath("div/a/img/@src").extract()  # 电影海报链接
            mvname = sel2.xpath('div/h3/a/text()').extract()#电影名字
            mvurl = sel2.xpath("div/h3/a/@href").extract_first()#电影链接
            yield scrapy.Request(url=mvurl, callback=lambda response,mvsclass =mvclass,img = imgurl,name = mvname: self.parse_mor(response, mvclass,img,name))

    def parse_mor(self, response, mvsclass,img,name):
        for select in response.xpath('//div[@class="contentinfo"]'):
            mvdownloadUrl = select.xpath("div/table/tbody/.//tr/td/a/@href").extract()  # 下载地址,可能是多个

            mvdtilte = select.xpath("div/table/tbody/.//tr/td/a/text()").extract()#下载标签的文本
            mvdesc = select.xpath("div[@id='text']/.//p/text()")#/p[2]/text()
            desc = ""
            for p in mvdesc:
                desc = desc + p.extract().strip()

            desc= str(desc).replace('\\u3000','  ')
            Item = MoviesItem()
            Item['movClass'] = mvsclass
            Item['downLoadName'] = name
            if str(mvdtilte).strip()=='':
                mvdtilte = "点击下载"
            Item['downdtitle'] = str(mvdtilte)
            Item['downimgurl'] = img
            Item['downLoadUrl'] = mvdownloadUrl
            Item['mvdesc'] = desc


            yield Item
