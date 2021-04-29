#!/usr/bin/env python

# encoding: utf-8
import imp,sys
imp.reload(sys)

# print("当前编码格式{0}".format(sys.getdefaultencoding()))
sys.setdefaultencoding('utf8')

from os.path import abspath, join, dirname
dotfiles = os.environ['dotfiles']
# base_dir = abspath(dirname(__file__)) 
# print("执行文件的路径：{0}".format(base_dir))
sys.path.insert(0, join(dotfiles, 'Alfred/workflow'))


print(sys.path)

from workflow import Workflow, ICON_WEB, web
import time

def get_top_news():
    base_url = 'https://api.zhihu.com/topstory/hot-list'

    req = web.get(base_url)
    req.raise_for_status()

    result = req.json()
    return result


def main(wf):
    posts = wf.cached_data('posts', get_top_news, max_age=60*60)

    # Loop through the returned posts and add an item for each to
    # the list of results for Alfred
    for  post in posts["data"]:
        target = post["target"]
        title = target['title']
        # # comments:{excerpt}
        target_url = target['url']
        target_url = target_url.replace("api","www").replace("questions","question")
        date = target['created']
        # print(time)
        created=time.localtime(date) #通过time.localtime将时间戳转换成时间组
        created=time.strftime("%Y-%m-%d %H", created)#再将时间组转换成指定格式
        excerpt=target['excerpt']
        detail_text = post['detail_text']
        subtitle = "{hot}|{created}|{excerpt}".format(
            hot=detail_text,
            excerpt=excerpt,
            created=created
        )
        # print("我的打印:{0}".format(subtitle))
        wf.add_item(title=title,
                    subtitle=subtitle,
                    arg=target_url,
                    valid=True,
                    icon='./icon.png'
                    )
    # Send the results to Alfred as XML
    wf.send_feedback()


if __name__ == u"__main__":
    wf = Workflow()
    sys.exit(wf.run(main))
