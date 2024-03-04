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
    
    @IBOutlet var welcomeUserName: UILabel!
    
    private var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        fetchUserName()
        setupButton()
        setupButton3()
        setupButton4()
        setupButton2()
    }
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoButton2: UIButton!
    @IBOutlet weak var photoButton3: UIButton!
    @IBOutlet weak var photoButton4: UIButton!
    
    func setupButton4 () {
        let image = UIImage(named: "music")?.withRenderingMode(.alwaysOriginal)
        photoButton4.setImage(image, for: .normal)
    }
    func setupButton3() {
        let image = UIImage(named: "art123")?.withRenderingMode(.alwaysOriginal)
        photoButton3.setImage(image, for: .normal)
    }
    
    func setupButton2() {
        let image = UIImage(named: "art")?.withRenderingMode(.alwaysOriginal)
        photoButton2.setImage(image, for: .normal)
    }
    
    func setupButton() {
        let image = UIImage(named: "Solder")?.withRenderingMode(.alwaysOriginal)
        photoButton.setImage(image, for: .normal)
    }
    
    func fetchUserName() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let userDocRef = db.collection("users").document(userID)
        userDocRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
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
            DispatchQueue.main.async {
                self.welcomeUserName.text = "Welcome \(name),"
            }
        }
    }

    

    private func observeAuthentication() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if user == nil {
                self.redirectToSignIn()
            } else {
                // Optionally reload user-specific data
            }
        }
    }

    private func redirectToSignIn() {
        // Assuming "LoginViewController" is the storyboard ID for your login view controller
        guard let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
            return
        }
        present(loginViewController, animated: true, completion: nil)
    }
}

