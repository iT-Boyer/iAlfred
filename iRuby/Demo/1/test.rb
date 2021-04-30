$LOAD_PATH << '.' #必须在当前目录中搜索被引用的文件

require 'trig.rb'
require 'moral'

y = Trig.sin(Trig::PI/4)
wrongdoing = Moral.sin(Moral::VERY_BAD)
