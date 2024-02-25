//
//  SignUpViewController.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 09/02/2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import SwiftUI
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var db : Firestore!
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userPassword: UITextField!
    @IBOutlet var requirementsLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        userEmail.delegate = self
        userPassword.delegate = self
        requirementsLabel.isHidden = true
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let userNameText = userName.text, !userNameText.isEmpty,
              let userEmailText = userEmail.text, !userEmailText.isEmpty,
              let userPasswordText = userPassword.text, !userPasswordText.isEmpty else {
            presentAlert(message: "Fill in all the fields")
            return
        }
        
        guard userPasswordText.count >= 8 else {
            presentAlert(message: "Password is too weak, must be a least 8 characters")
            return
        }
        
        guard userEmailText.contains("@") else {
            presentAlert(message: "Please enter a valid email address")
            return
        }
        
        Task {
            await signUp(email:userEmailText, password:userPasswordText)
        }
        
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        self.userName.resignFirstResponder()
        self.userEmail.resignFirstResponder()
        self.userPassword.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func updatePasswordRequirementsLabel(forPassword password:String) {
        let specialCharacterRequirement = "Contains one of the following special characters \"!@#$%^&*()\"."
        let numberRequirement = "Contains one number 1-9."
        let capitalLetterRequirement = "Contains a capital letter."
        let notContainUserNameRequirement = "Does not contain your name."
        let minLengthRequirement = "Is at least 8 characters long."
        
        let requirements = ["Password should:",minLengthRequirement,specialCharacterRequirement,numberRequirement,capitalLetterRequirement,notContainUserNameRequirement]
        
        let userNameText = userName.text ?? ""
        
        let specialCharactersSet = CharacterSet(charactersIn: "!@#$%^&*()")
        let digitsCharacterSet = CharacterSet.decimalDigits
        let uppercaseCharacterSet = CharacterSet.uppercaseLetters
        
        let hasSpecialCharacter = password.rangeOfCharacter(from: specialCharactersSet) != nil
        let hasNumber = password.rangeOfCharacter(from: digitsCharacterSet) != nil
        let hasCapitalLetter = password.rangeOfCharacter(from: uppercaseCharacterSet) != nil
        let doesNotContainUserName = !password.localizedCaseInsensitiveContains(userNameText)
        let isMinLength = password.count >= 8
        
        let fulfilledAttributes : [NSAttributedString.Key:Any] = [.foregroundColor:UIColor.green]
        let unfulfilledAttributes : [NSAttributedString.Key:Any] = [.foregroundColor:UIColor.red]
        
        let attributedString = NSMutableAttributedString()
        
        for requirement in requirements {
            var isFulfilled = false
            switch requirement {
                case specialCharacterRequirement:
                    isFulfilled = hasSpecialCharacter
                case numberRequirement:
                    isFulfilled = hasNumber
                case capitalLetterRequirement:
                    isFulfilled = hasCapitalLetter
                case notContainUserNameRequirement:
                    isFulfilled = doesNotContainUserName
                case minLengthRequirement:
                    isFulfilled = isMinLength
                default:
                    continue
            }
            let attributes = isFulfilled ? fulfilledAttributes : unfulfilledAttributes
            attributedString.append(NSAttributedString(string: requirement + "\n", attributes: attributes))
        }
        requirementsLabel.attributedText = attributedString
    }
    
    func saveUserData(user:User) async{
        let userID = user.uid
        let userData = ["Name":userName.text ?? "", "Email":userEmail.text ?? ""]
        
        do {
            try await db.collection("users").document(userID).setData(userData)
            DispatchQueue.main.async{
                self.presentSignUpStep1()
            }
        } catch {
            DispatchQueue.main.async {
                self.presentAlert(message: "Failed to save user data: \(error.localizedDescription)")
            }
        }
        
    }
    
    func signUp(email:String, password:String) async {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            await saveUserData(user: authResult.user)
        } catch {
            DispatchQueue.main.async {
                self.presentAlert(message: error.localizedDescription)
            }
        }
        
    }
    
    func presentAlert(message:String) {
        DispatchQueue.main.async{
        let alertController = UIAlertController(title: "An error has occurred", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController,animated: true)
    }
    }
    
    func presentSignUpStep1(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpStep1")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userPassword {
            requirementsLabel.isHidden = false
            updatePasswordRequirementsLabel(forPassword: textField.text ?? "")
        }
    }
    
    func textField (_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userPassword {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            updatePasswordRequirementsLabel(forPassword:updatedText)
            }
        return true
        }
    }
    


