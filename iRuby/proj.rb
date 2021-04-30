#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require 'xcodeproj'

# 封装类，实例化对象，调用解析target方法，并打印
class XProj
   def initialize(proj_path)
      # 给实例变量赋值
      puts '初始化'
      @projPath = proj_path
      
   end
   # 打印所有targets
   def targetss
       #打开项目工程A.xcodeproj
       puts '项目路径'
       project = Xcodeproj::Project.open(@projPath)
           #查询有多少个target
           project.targets.each do |target|
               puts target.name
           end
       project.save
   end
end
