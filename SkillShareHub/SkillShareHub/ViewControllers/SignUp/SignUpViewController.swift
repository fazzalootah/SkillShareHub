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
import CometChatUIKitSwift

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var db : Firestore!
    
    @IBOutlet var usernameAvailabilityLabel: UILabel!
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
        usernameAvailabilityLabel.isHidden = true
        
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
            await createUser(email:userEmailText, password:userPasswordText, username: userNameText)
        }
        
    }
    
    func saveUserData(user: AuthDataResult) async {
        let userID = user.user.uid  // Use FirebaseAuth's `User` instance
        let userData = ["Name": userName.text ?? "", "Email": userEmail.text ?? ""]
        let username = userName.text ?? ""

        do {
            try await db.collection("users").document(userID).setData(userData)
            try await db.collection("usernames").document(username).setData(["userID": userID])
            DispatchQueue.main.async {
                self.presentSignUpStep1()
            }
        } catch {
            DispatchQueue.main.async {
                self.presentAlert(message: "Failed to save user data: \(error.localizedDescription)")
            }
        }
    }

    private func createUser(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlert(title: "Error", message: error.localizedDescription)
                return
            }
            guard let user = authResult else {
                self.presentAlert(title: "Error", message: "Failed to create user.")
                return
            }
            // Now call saveUserData with the correct AuthDataResult type
            Task {
                await self.saveUserData(user: user)
                // After saving user data, you might want to create CometChat user or perform other actions
            }
        }
    }
    
    private func createCometChatUser(uid: String, name: String) {
        // Assuming you have a CometChat setup method elsewhere that initializes the SDK
        let user = CometChatPro.User(uid: uid, name: name)
        
        // Set additional properties if needed
        // user.avatar = "URL_TO_AVATAR"
        
        CometChat.createUser(user: user, apiKey: "a52a75d8a46c24e053829b5726730c593e75984d", onSuccess: { (user) in
            // Handle success
        }, onError: { (error) in
            // Handle error
            self.presentAlert(title: "Error", message: "Failed to create CometChat user: \(error?.errorDescription ?? "Unknown error")")
        })
    }
    
    
    func checkUsernameTaken(username: String) async -> Bool {
        let querySnapshot = try? await db.collection("usernames").document(username).getDocument()
        return querySnapshot?.exists ?? false
    }
    
    func presentAlert(title: String = "Error", message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    func presentSignUpStep1(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpStep1")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userName {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Check username availability
            checkUsernameTaken(username: updatedText)
        } else if textField == userPassword {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Update password requirements UI
            updatePasswordRequirementsLabel(forPassword: updatedText)
        }
        return true
    }
    
    // Merge duplicate textFieldDidBeginEditing implementations
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userName {
            // Hide the label when the user starts editing the username field again
            self.usernameAvailabilityLabel.isHidden = true
        } else if textField == userPassword {
            // Show password requirements when user starts editing the password field
            requirementsLabel.isHidden = false
            updatePasswordRequirementsLabel(forPassword: textField.text ?? "")
        }
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
    
    func checkUsernameTaken(username: String) {
        // Assuming db is already initialized Firestore instance
        db.collection("users").whereField("Username", isEqualTo: username).getDocuments { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            
            if let err = err {
                print("Error checking username: \(err)")
                // Handle error appropriately, perhaps allowing the user to proceed but with caution
            } else if let snapshot = querySnapshot, !snapshot.isEmpty {
                self.updateUsernameUI(isTaken: true)
            } else {
                self.updateUsernameUI(isTaken: false)
            }
        }
    }
    
    func updateUsernameUI(isTaken: Bool) {
        DispatchQueue.main.async {
            if isTaken {
                // Customize the appearance for the error state
                self.userName.layer.borderColor = UIColor.red.cgColor
                self.userName.layer.borderWidth = 1
                self.userName.backgroundColor = UIColor(red: 1, green: 0.9, blue: 0.9, alpha: 1) // Optional: light red background for emphasis

                // Set the error message and show the label
                self.usernameAvailabilityLabel.text = "Username unavailable"
                self.usernameAvailabilityLabel.textColor = UIColor.red
                self.usernameAvailabilityLabel.isHidden = false
            } else {
                // Reset to default appearance if username is not taken
                self.userName.layer.borderColor = UIColor.clear.cgColor
                self.userName.layer.borderWidth = 0
                self.userName.backgroundColor = UIColor.white // Reset background color

                // Optionally hide the label or indicate availability
                self.usernameAvailabilityLabel.isHidden = true // Hide the label or update as necessary
            }
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
    
}
