//
//  DataBaseUtils.swift
//  SqLIteDemoProject
//
//  Created by Neosoft on 10/10/23.
//

import Foundation

class DbUtils : NSObject{
    class func getPath(_ filename : String) -> String{
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = documentDirectory.appendingPathComponent(filename)
        print("database Location : \(fileUrl.path)")
        return fileUrl.path
    }
    
    class func copyDatabase(_ fileName : String){
        let dbPath = getPath("DemoDataBase.db")
        let filemanager = FileManager.default
        
        if !filemanager.fileExists(atPath: dbPath){
            let bundel = Bundle.main.resourceURL
            let file = bundel?.appendingPathComponent(fileName)
            var error : NSError?
            do {
                try filemanager.copyItem(atPath: (file?.path)!, toPath: dbPath)
            }catch let erorr1 as NSError{
                error = erorr1
            }
            if error == nil{
                print("no error")
            }else
            {
                print("all ok")
            }
        }
        
    }
}
