//
//  CreateActivity2.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 28/02/2024.
//

import Foundation
import UIKit


class CreateActivityViewController2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBOutlet var imageView: UIImageView!
    var message = "Activity Created"
  
    @IBAction func uploadImageButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // Change this to .camera to use the camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createActivityPressed(_ sender: Any) {
        // Assuming 'message' is defined somewhere. If not, define it.
        let message = "Your activity has been successfully created"
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Activity Created", message: message, preferredStyle: .alert)
        
        // Add an OK action to the alert
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // This block gets executed when the OK button is tapped.
            self.presentDashboard()
        }
        alertController.addAction(OKAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentAlert(message:String) {
        let alertController = UIAlertController(title: "Activity created", message: message, preferredStyle: .alert)
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
