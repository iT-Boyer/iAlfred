import Foundation
import AlfredSwift
import XcodeProj
import PathKit


print("Testtttttt")

let path = Path("/Users/boyer/Desktop/XcodeTest/XcodeTest.xcodeproj") // Your project path
let xcodeproj = try! XcodeProj(path: path)
let pbxproj = xcodeproj.pbxproj // Returns a PBXProj

var fileee:PBXFileElement?

pbxproj.buildConfigurations.forEach { body in
    print(body.name)
}

pbxproj.nativeTargets.forEach{ target in
    print(target.name)
    //文件目录
    let files = try! target.sourceFiles()
    files.forEach { filee in
        fileee = filee
        print(filee.path)
    }
    //phase
    let files1 = try! target.sourcesBuildPhase()
    print(files1?.inputFileListPaths)
    
    let obj:PBXFrameworksBuildPhase? = try! target.frameworksBuildPhase()
    let frameworkfile = PBXFileElement(path:"/Users/boyer/hsg/SupervisionSel/JinherSDK/JinherSDK/Libs/YunCeng.framework",name:"YunCeng.framework")
    
    let buildfile:PBXBuildFile? = try! obj?.add(file: frameworkfile)
    
    obj!.files?.forEach({ filess in
        print("Framework \(filess.file?.name)")
    })
    
    let framework:[PBXCopyFilesBuildPhase] = target.embedFrameworksBuildPhases()
    framework.forEach { file in
        print("file \(file.name)")
    }
    //配置
    target.buildConfigurationList?.buildConfigurations.forEach({ config in
        print("buildconfig == \(config.name)")
        //config.buildSettings 字典类型
        //证书配置:
        config.buildSettings["PROVISIONING_PROFILE_SPECIFIER"] = "xxProfileName"
        config.buildSettings["DEVELOPMENT_TEAM"] = "xxTeamName"
        config.buildSettings["CODE_SIGN_IDENTITY"] = "xxIdentityName"
        config.buildSettings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = "iPhone Developer"

        //OTHER_LDFLAGS:
        if let kj = config.buildSettings["OTHER_LDFLAGS"]{
            print("other link ld flags \(kj)")
            config.buildSettings["OTHER_LDFLAGS"] = "-fobjc -objc"
        }else{
            print("OTHER_LDFLAGS 不存在..")
            config.buildSettings["OTHER_LDFLAGS"] = "-fobjc -objc"
        }
        
        
        //修改配置
        print("===== end =====")
    })
}
// 修改目录结构
let project = pbxproj.projects.first! // Returns a PBXProject
let mainGroup = project.mainGroup
let group = try mainGroup?.addGroup(named: "MyGroup")
let newgroup:PBXGroup? = group?.last
newgroup?.children.append(fileee!)
let filep = Path.init("/Users/boyer/Desktop/test/tet.txt")
try newgroup?.addFile(at: filep, sourceRoot: Path("/Users/boyer/Desktop/"))


//持久化
//try pbxproj.write(path: path, override: true)

try xcodeproj.write(path: path)
