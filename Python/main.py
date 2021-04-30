#!/usr/bin/env python
# coding=UTF-8
import os
import sys

# 获取当前文件路径
path = os.getcwd()
print ('获取当前文件路径:{}'.format(path))

# 返回指定目录下的所有文件和目录名
print (os.listdir(path))
print ('使用xcode运行Python')
