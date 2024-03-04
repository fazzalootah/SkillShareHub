//
//  activityCell.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 01/03/2024.
//

import Foundation
import UIKit

class activityCell: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func joinOtherPressed(_ sender: Any) {
        presentAlert(message: message2)
    }
    
    var message2 = "You have successfully joined this activity"
    
    func presentAlertOther(message: String) {
        let alertController = UIAlertController(title: "Successfully Joined", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Present the Dashboard after the alert is dismissed
            self.presentDashboard()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    @IBAction func joinOwnPressed(_ sender: Any) {
        presentAlert(message: message)
    }
    
    var message = "You cannot join your own activity"
    
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "An error has occurred", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Present the Dashboard after the alert is dismissed
            self.presentDashboard()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func presentDashboard() {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil) // Ensure storyboard name matches your project setup
        guard let vc = storyboard.instantiateViewController(withIdentifier: "Dashboard") as? Dashboard else {
            print("Could not instantiate view controller with identifier DashboardViewControllerIdentifier")
            return
        }
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}
