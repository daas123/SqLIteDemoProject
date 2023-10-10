//
//  uiViewController+Extention.swift
//  SqLIteDemoProject
//
//  Created by Neosoft on 10/10/23.
//

import UIKit

extension UIViewController{
    func showAlert(msg : String, isDismiss : Bool = false){
            let alert = UIAlertController(title: nil, message: msg , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel){_ in
                if isDismiss{
                    self.dismiss(animated: true)
                }
            })
            present(alert, animated: true)
        }
}
