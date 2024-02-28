//
//  createActivity.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 27/02/2024.
//

import UIKit
import FirebaseFirestore

class CreateActivityViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextField! // This should be UITextView if you're entering a description.
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var requirementsTextView: UITextField! // This should be UITextView for consistency and functionality.
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var durationDatePicker: UIDatePicker!
    @IBOutlet weak var dateTimeDatePicker: UIDatePicker!

    let categories = ["Woodworking", "Dance", "Acting", "Music", "Graphic Design", "Sign Language", "Gaming", "Photography", "STEM", "English Literature", "Service as Action", "Subject Tutoring", "CAS", "E-commerce", "Finance", "Visual Arts"]
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}
