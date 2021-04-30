#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-
$LOAD_PATH << '.' #必须在当前目录中搜索被引用的文件
require "proj" #在嵌入Week模块之前使用 require 语句引用该文件时必需的

project_path = '../../SupervisionSel/LogSwift/LogSwift.xcodeproj'
projs = XProj.new(project_path)
projs.targetss()
