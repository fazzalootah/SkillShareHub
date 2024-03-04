//
//  createActivity.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 27/02/2024.
//

import UIKit
import FirebaseFirestore

class CreateActivityViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextField! // This should be UITextView if you're entering a description.
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var durationDatePicker: UIDatePicker!
    @IBOutlet weak var dateTimeDatePicker: UIDatePicker!

    let categories = ["Woodworking", "Dance", "Acting", "Music", "Graphic Design", "Sign Language", "Gaming", "Photography", "STEM", "English Literature", "Service as Action", "Subject Tutoring", "CAS", "E-commerce", "Finance", "Visual Arts"]
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }

     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return categories.count
     }
     
     // MARK: UIPickerViewDelegate Methods
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return categories[row]
     }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Handle the selection of a category
        // For example: print("Selected category: \(categories[row])")
    }
}
