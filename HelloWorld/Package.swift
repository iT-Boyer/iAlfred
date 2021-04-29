// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
/**
 
 import ArgumentParser // https://gitee.com/iTBoyer/swift-argument-parser
 // import Regex // @sharplet ~> 2.1
 import Regex  // ~/hsg/Regex

 import SwiftyJSON // https://github.com/SwiftyJSON/SwiftyJSON.git
 import PythonKit // https://github.com/pvieito/PythonKit.git
 import XMLParsing // https://github.com/ShawnMoore/XMLParsing.git

 */
let package = Package(
    name: "HelloWorld",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name:"AlfredSwift", url: "https://github.com/iT-Boyer/AlfredSwift.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
        .package(name:"Regex", url: "https://github.com/sharplet/Regex.git", from: "2.1.1"),
        .package(name:"SwiftyJSON", url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.1"),
        .package(name:"PythonKit", url: "https://github.com/pvieito/PythonKit.git", from: "0.0.0"),
        .package(name:"XMLParsing", url: "https://github.com/ShawnMoore/XMLParsing.git", from: "0.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "HelloWorld",
            dependencies: ["AlfredSwift","Regex","SwiftyJSON","PythonKit","XMLParsing",
                           .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
            ),

        .testTarget(
            name: "HelloWorldTests",
            dependencies: ["HelloWorld"]),
        
            ]
)
