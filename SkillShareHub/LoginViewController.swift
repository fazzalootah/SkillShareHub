//
//  LoginViewController.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 09/02/2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions
import StreamChat

class LoginViewController: UIViewController, UITextFieldDelegate {
    var db: Firestore!

    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        userEmail.delegate = self
        userPassword.delegate = self
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = userEmail.text, !email.isEmpty,
              let password = userPassword.text, !password.isEmpty else {
            presentAlert(message: "Please fill in all fields.")
            return
        }

        loginUser(email: email, password: password)
    }
    
    private func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlert(message: "Login error: \(error.localizedDescription)")
                return
            }
            
            guard let userID = authResult?.user.uid else {
                self.presentAlert(message: "Failed to retrieve user information")
                return
            }
            
            self.checkUserAccountStatus(userID: userID)
            streamChatClient.createToken(userId: userID) { (result) in
        switch result {
        case .success(let token):
            streamChatClient.connectUser(token: token, user: .init(id: userID)) { (result) in
                switch result {
                case .success(let user):
                    print("User \(user.id) successfully authenticated with Stream Chat.")
                case .failure(let error):
                    print("Error authenticating with Stream Chat: \(error.localizedDescription)")
                }
            }
        case .failure(let error):
            print("Error creating token for Stream Chat: \(error.localizedDescription)")
        }
    }
        }
    }
    // test
//     func authenticateStreamChatUser(userID: String) {
    
// }
struct ContentView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        VStack {
            if isAuthenticated {
                NavigationLink(destination: ChatView()) {
                    Text("Go to Chat")
                }
            } else {
                // Login form goes here
            }
        }
        .onAppear {
            // Check if the user is authenticated
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if let _ = user {
                    self.isAuthenticated = true
                }
            }
        }
    }
}


    private func fetchStreamTokenAndInitializeChat(userID: String) {
        Functions.functions().httpsCallable("generateStreamToken").call { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlert(message: "Error fetching Stream Token: \(error.localizedDescription)")
                return
            }
            
            guard let token = (result?.data as? [String: Any])?["token"] as? String else {
                self.presentAlert(message: "Failed to parse chat token")
                return
            }
            
            self.initializeStreamChatClient(userID: userID, token: token)
        }
    }
    
    private func initializeStreamChatClient(userID: String, token: String) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            presentAlert(message: "Scene Delegate is not accessible.")
            return
        }
        
        guard let client = sceneDelegate.chatClient else {
            presentAlert(message: "Stream Chat client is not initialized.")
            return
        }
        
        do {
            let userToken = try Token(rawValue: token)
            client.connectUser(userInfo: .init(id: userID), token: userToken) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    DispatchQueue.main.async {
                        self.presentAlert(message: "Failed to connect to Stream Chat: \(error.localizedDescription)")
                    }
                    return
                }
                
                // Navigate to the main chat interface
                DispatchQueue.main.async {
                    self.presentDashboard()
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.presentAlert(message: "Failed to initialize Stream Chat token: \(error.localizedDescription)")
            }
        }
    }
    
    private func checkUserAccountStatus(userID: String) {
        let userDocRef = db.collection("users").document(userID)
        
        userDocRef.getDocument { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlert(message: "Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                self.presentAlert(message: "User data not found.")
                return
            }
            
            if let isDisabled = document.get("isDisabled") as? Bool, isDisabled {
                self.presentAlert(message: "This account has been disabled.")
                do {
                    try Auth.auth().signOut()
                } catch let signOutError {
                    print("Error signing out: \(signOutError.localizedDescription)")
                }
            } else {
                self.fetchStreamTokenAndInitializeChat(userID: userID)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func presentDashboard() {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil) // Ensure your storyboard name matches
        if let vc = storyboard.instantiateViewController(withIdentifier: "Dashboard") as? Dashboard {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}
