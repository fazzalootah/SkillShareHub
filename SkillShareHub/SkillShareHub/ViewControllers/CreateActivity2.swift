//
//  CreateActivity2.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 28/02/2024.
//

import Foundation
import UIKit


class CreateActivityViewController2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var message = "Activity Created"
  
    
    @IBAction func createActivityPressed(_ sender: Any) {
        self.presentAlert(message:message)

    }
    
    func presentAlert(message:String) {
        let alertController = UIAlertController(title: "An error has occurred", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController,animated: true)
    }
    
}
