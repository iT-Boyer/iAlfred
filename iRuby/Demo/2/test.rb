#!/usr/bin/ruby
$LOAD_PATH << '.'
require "support" #在嵌入Week模块之前使用 require 语句引用该文件时必需的

class Decade
include Week  
   no_of_yrs=10
   def no_of_months
      puts Week::FIRST_DAY
      number=10*12
      puts number
   end
end
d1=Decade.new
puts Week::FIRST_DAY
Week.weeks_in_month
Week.weeks_in_year
d1.no_of_months
