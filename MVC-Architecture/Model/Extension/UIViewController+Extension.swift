//
//  UIViewController+Extension.swift
//  MVC-Architecture
//
//  Created by russel on 12/7/24.
//

import SVProgressHUD

extension UIViewController {
    func showProgressSpinner() {
        SVProgressHUD.show()
    }
    
    func hideProgressSpinner() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
