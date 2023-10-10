//
//  UserDataCell.swift
//  SqLIteDemoProject
//
//  Created by Neosoft on 10/10/23.
//

import UIKit

class UserDataCell: UITableViewCell {
    
    var DeligateMAinVc : UserActionOnCell?
    var index : Int?
    
    @IBOutlet weak var txtFname: UILabel!
    @IBOutlet weak var txtLname: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var txtContactNo: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onEdit(_ sender: UIButton) {
        DeligateMAinVc?.onEdit(index: index ?? 0)
    }
    @IBAction func onCancel(_ sender: UIButton) {
        DeligateMAinVc?.onDelete(index: index ?? 0)
    }

}
