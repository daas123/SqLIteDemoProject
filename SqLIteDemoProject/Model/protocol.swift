//
//  protocol.swift
//  SqLIteDemoProject
//
//  Created by Neosoft on 10/10/23.
//

import Foundation

protocol UserActionOnCell{
    func onEdit(index:Int)
    func onDelete(index:Int)
}

protocol UserReload{
    func reloadData()
}
