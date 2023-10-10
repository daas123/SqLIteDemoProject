//
//  DataBaseManager.swift
//  SqLIteDemoProject
//
//  Created by Neosoft on 10/10/23.
//

import Foundation
var shareInstance = DatabaseManager()
class DatabaseManager{

    var dataBase : FMDatabase? = nil
    
    class func getInstance() -> DatabaseManager{
        if shareInstance.dataBase == nil{
            shareInstance.dataBase = FMDatabase(path: DbUtils.getPath("DemoDataBase.db"))
        }
        return shareInstance
    }
    func save(_ modelInfo:UserModelEditing) -> Bool{
        shareInstance.dataBase?.open()
        let isSave = shareInstance.dataBase?.executeUpdate("INSERT INTO Employee(fName,lName,address,contactNo,imageName) VALUES (?,?,?,?,?)", withArgumentsIn: [modelInfo.fName , modelInfo.lName , modelInfo.address , modelInfo.contactNo,modelInfo.imagename] )
        shareInstance.dataBase?.close()
        return isSave!
    }
    
    func fetch() -> [UserModel]? {
        shareInstance.dataBase?.open()
        
        var users: [UserModel] = []
        
        if let resultSet = shareInstance.dataBase?.executeQuery("SELECT * FROM Employee", withArgumentsIn: []) {
            while resultSet.next() {
                let fName = resultSet.string(forColumn: "fName") ?? ""
                let lName = resultSet.string(forColumn: "lName") ?? ""
                let address = resultSet.string(forColumn: "address") ?? ""
                let contactNo = resultSet.string(forColumn: "contactNo") ?? ""
                let id =  resultSet.int(forColumn: "id")
                let imageName =  resultSet.string(forColumn: "imageName") ?? ""
                
                let userModel = UserModel(id: Int(id), fName: fName, lName: lName, address: address, contactNo: contactNo, imagename: imageName)
                
                users.append(userModel)
            }
        }
        
        shareInstance.dataBase?.close()
        return users
    }

    func edit( index : Int, updatedInfo: UserModelEditing) -> Bool {
        shareInstance.dataBase?.open()

        let isUpdated = shareInstance.dataBase?.executeUpdate("UPDATE Employee SET fName = ?, lName = ?, imageName = ?, address = ?, contactNo = ? WHERE id = ?", withArgumentsIn: [updatedInfo.fName, updatedInfo.lName,updatedInfo.imagename,updatedInfo.address, updatedInfo.contactNo, index])

        shareInstance.dataBase?.close()

        return isUpdated!
    }
    
    func delete(atIndex index: Int) -> Bool {
        shareInstance.dataBase?.open()
        let isDeleted = shareInstance.dataBase?.executeUpdate("DELETE FROM Employee WHERE id = ?", withArgumentsIn: [index])
        
        shareInstance.dataBase?.close()
        
        return isDeleted!
    }
    
}
