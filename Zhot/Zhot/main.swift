//
//  main.swift
//  Zhot
//
//  Created by jhmac on 2021/4/29.
//

import Foundation

import ArgumentParser // https://gitee.com/iTBoyer/swift-argument-parser
// import Regex // @sharplet ~> 2.1
import Regex  // ~/hsg/Regex

import SwiftyJSON // https://github.com/SwiftyJSON/SwiftyJSON.git
import PythonKit // https://github.com/pvieito/PythonKit.git
import XMLParsing // https://github.com/ShawnMoore/XMLParsing.git
import AlfredSwift // ~/hsg/iAlfred/AlfredSwift

struct hot_cli: ParsableCommand {
    // 自定义设置
    static var configuration =
      CommandConfiguration(commandName: "hotZH", // 自定义命令名，默认是类型名
                           abstract: "知乎热榜",
                           discussion: "查阅当天热门信息",
                           version: "1.0.0",
                           shouldDisplay: true,
                           subcommands: [Checkhot.self],
                           defaultSubcommand: Checkhot.self,
                           helpNames: NameSpecification.customLong("h"))
}

struct HotOptions: ParsableArguments {

    //MARK: 参数
    @Option(name: [.customShort("l"), .long], help:"列表")
    var list:String
    // @Argument(help: "查看列表")

      //MARK: flag
      // @Flag(name: [.customLong("type"), .customShort("-t")],
            // help: "设置类型：热榜/推荐等")
     // var
}

extension hot_cli {

    struct Note: Codable {
        var to: String
        var from: String
        var heading: String
        var body: String
    }

    //MARK: 定义自命令 struct结构体
    struct Checkhot:ParsableCommand {
        //MARK: 配置
        static var configuration = CommandConfiguration(abstract:"查看热榜",
                                                        shouldDisplay: true)
        //加载封装好的指令
        // @OptionGroup()
        // var customOpts:HotOptions

        func run() throws {
            //MARK: 调用workflow脚本
//            pythonInstall()
//            testPythonKit()
//            testAlfred()
            
            //使用URLSession同步获取数据（通过添加信号量）
            //https://www.hangge.com/blog/cache/detail_816.html
            let semaphore = DispatchSemaphore(value: 0)
            URLSession.shared.dataTask(with: URL(string: "https://api.zhihu.com/topstory/hot-list")!) { data, response, error in
                
                if error != nil{
                        print(error!)
                    }else{
//                        let str = String(data: data!, encoding: String.Encoding.utf8)
                        // print(str!)
                        
                        //解析
                        let json: JSON = try! JSON(data:data!)
                        let posts = json["data"]
                        
                        pythonInstall()
//                        sendAlfredBySwift(posts)
//                        sendAlfredByPythonKit(posts)
                        workflow(posts)
                        //退出命令
                        hot_cli.Checkhot.exit()
                }
                semaphore.signal()
            }.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//            print("数据加载完毕！")
        }
        
        func sendAlfredBySwift(_ posts:JSON) {
            let wf = Alfred()
            for i in 0..<posts.count
            {
                let obj = posts[i]
                let target = obj["target"]
                let title = "\(target["title"])"
                wf.AddResult("", arg: "", title: title, sub: title, icon: "", valid: "", auto: "", rtype: "")
            }
            print(wf.ToXML())
        }
        func sendAlfredByPythonKit(_ posts:JSON) {

            let hot = Python.import("hot_Swft") // import your Python file.
            for i in 0..<posts.count
            {
                let obj = posts[i]
                let target = obj["target"]
                let title = "\(target["title"])"
                let sub = "\(target["excerpt"])"
                let url = "\(target["url"])"
                _ = hot.addItem(title,sub,url,"icon") // call your Python function
            }
            //Send the results to Alfred as XML
            hot.sendFeedback()
        }
        
        func workflow(_ posts:JSON) {

            let wfmodel = Python.import("workflow") // import your Python file.
            let wf = wfmodel.Workflow()
            for i in 0..<posts.count
            {
                let obj = posts[i]
                let target = obj["target"]
                let title = "\(target["title"])"
                let sub = "\(target["excerpt"])"
                let url = "\(target["url"])"
                wf.add_item(title:title,subtitle:sub,arg:url,icon:"./icon.png") // call your Python function
            }
            //Send the results to Alfred as XML
            wf.send_feedback()
        }
        
        //https://medium.com/@rockyshikoku/calling-python-scripts-from-swift-by-pythonkit-faf41757e890
        //https://towardsdatascience.com/from-swift-import-python-f2fc2a997d4?gi=698b21ab045b
        func pythonInstall() {
            PythonLibrary.useVersion(2)
            let sys = Python.import("sys")
            print("Python \(sys.version_info.major).\(sys.version_info.minor)")
            print("Python Version: \(sys.version)")
//            sys.setdefaultencoding("utf8")
            print("Python Encoding: \(sys.getdefaultencoding().upper())")

            sys.path.append("/Users/boyer/hsg/iAlfred/Python") // path to your Python file's directory.
            print("路径：\(sys.path)")
            
            _ = Python.import("hot_Swft") // import your Python file.
            print("Python Encoding: \(sys.getdefaultencoding().upper())")
        }
        
        func testPythonKit() {
            let example = Python.import("hot_Swft") // import your Python file.
            let name = "校长"
            let sex = "男"
            let response = example.hello(name, sex) // call your Python function
            print(response)
        }
        
        func testAlfred() {
            let hot = Python.import("hot_Swft") // import your Python file.
            let response = hot.addItem("title","sub","rul","icon") // call your Python function
            print(response)
        }
    }
    
}

hot_cli.main()
