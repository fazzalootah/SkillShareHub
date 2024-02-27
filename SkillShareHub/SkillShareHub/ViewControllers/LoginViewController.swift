//
//  LoginViewController.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 09/02/2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class LoginViewController: UIViewController, UITextFieldDelegate{
    var db : Firestore!

    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
    }
    
    @IBAction func loginTapped(_ sender:Any) {
        Task { @MainActor in
            var message = ""
            if userEmail.text?.isEmpty == true, userPassword.text?.isEmpty == true {
                message = "Fill in all the fields"
                self.presentAlert(message:message)
            }
            
            if userEmail.text?.isEmpty == true {
                message = "Fill in the email field"
                self.presentAlert(message:message)
            }
    
            if userPassword.text?.isEmpty == true {
                message = "Fill in the password field"
                self.presentAlert(message:message)
            } else {
                login()
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: userEmail.text!, password: userPassword.text!) {[weak self] authResult, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                var message = ""
                switch error.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    message = "Wrong Password"
                case AuthErrorCode.invalidEmail.rawValue:
                    message = "Invalid Email"
                default:
                    message = error.localizedDescription
                }
                DispatchQueue.main.async {
                    self.presentAlert(message: message)
                }
                return
            } else {
                self.presentDashboard()
            }
            
            guard let userID = authResult?.user.uid else {
                DispatchQueue.main.async {
                    self.presentAlert(message: "Failed to retrieve user information")
                }
                return
            }

        }
        
    }
    
    func checkUserAccountStatus(userID: String) {
        let userDocRef = db.collection("users").document(userID)
        
        userDocRef.getDocument { [weak self] (documentSnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.presentAlert(message: "Failed to fetch user data.")
                }
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                DispatchQueue.main.async {
                    self.presentAlert(message: "User data not found.")
                }
                return
            }
            
            if let isDisabled = document.get("isDisabled") as? Bool, isDisabled {
                DispatchQueue.main.async {
                    self.presentAlert(message: "This account has been disabled.")
                }
                do {
                    try Auth.auth().signOut()
                } catch let signOutError {
                    print("Error signing out: \(signOutError.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self.presentDashboard()
                }
            }
        }
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        self.userEmail.resignFirstResponder()
        self.userPassword.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func presentAlert(message:String) {
        let alertController = UIAlertController(title: "An error has occurred", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController,animated: true)
    }
    
    func presentDashboard(){
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Dashboard")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}
