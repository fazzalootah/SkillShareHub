//
//  accountPref.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 29/02/2024.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class accountPreferences: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        signOut()
    }

    
    func signOut() {
        do {
            try Auth.auth().signOut()
            // Optionally: Return to the login screen or perform other actions after signing out
            presentLandingPage()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            // Optionally: Show an alert to the user indicating that sign-out failed
        }
    }
    func presentLandingPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "landingPage")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }

}
