//
//  forgotPassword.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 20/02/2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import SwiftUI
import FirebaseFirestore
import Network

class forgotPassword: UIViewController, UITextFieldDelegate {
    @IBOutlet var userEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: userEmail.text!) {(error) in
            var message = ""
            if let error = error {
                message = error.localizedDescription
//                let alert = Service.createAlertController(title:"Error", message: error.localizedDescription)
//                self.present(alert, animated:true, completion:nil)
//                return
            } else {
                message = "Email Successfully Sent."
            }
            self.presentAlert(message: message)
        }
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        self.userEmail.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func presentAlert(message:String) {
        let alertController = UIAlertController(title: "Email Successfully sent", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController,animated: true)
    }
    
}
