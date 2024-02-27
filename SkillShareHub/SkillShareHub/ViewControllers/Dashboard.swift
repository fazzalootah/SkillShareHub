//
//  Dashboard.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 21/02/2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Dashboard: UIViewController {
    // MARK: - Properties
    var db: Firestore!
    
    // MARK: - Lifecycle Methods
    @IBOutlet weak var welcomeUserName: UILabel!

    func fetchUserName (){
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let userDocRef = db.collection("users").document(userID)
        userDocRef.getDocument {(document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            guard let document = document, document.exists else {
                print("Document does not exist: \(userID)")
                return
            }
            let data = document.data()
            let name = data?["Name"] as? String ?? "No Name"
            DispatchQueue.main.async{
                self.welcomeUserName.text = "Welcome \(name),"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        fetchUserName()

        // Check the authentication state
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }
            
            if user != nil {
                // If the user is signed in, fetch chat groups
            } else {
                // If the user is not signed in, redirect to sign-in page
                self.redirectToSignIn()
            }
        }
    }
    
    // MARK: - Methods
    
    func redirectToSignIn() {
        // Logic to redirect user to the sign-in page
        // Assuming you have a storyboard-based login view controller
        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            present(loginViewController, animated: true, completion: nil)
        }
    }
}
