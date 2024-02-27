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
    @IBOutlet weak var descriptionTextView: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var requirementsTextView: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var durationDatePicker: UIDatePicker!
    @IBOutlet weak var dateTimeDatePicker: UIDatePicker!

    let categories = ["Woodworking", "Dance", "Acting", "Music", "Graphic Design", "Sign Language", "Gaming", "Photography", "STEM", "English Literature", "Service as Action", "Subject Tutoring", "CAS", "E-commerce", "Finance", "Visual Arts"]
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePickerViews()
        db = Firestore.firestore()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configurePickerViews() {
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        durationDatePicker.datePickerMode = .countDownTimer
        dateTimeDatePicker.datePickerMode = .dateAndTime
    }

    @IBAction func saveActivity(_ sender: UIButton) {
        guard let name = nameTextField.text,
              let description = descriptionTextView.text,
              let location = locationTextField.text,
              let requirements = requirementsTextView.text,
              let costText = costTextField.text,
              let cost = Double(costText) else {
            return
        }
        
        let categoryIndex = categoryPickerView.selectedRow(inComponent: 0)
        let category = categories[categoryIndex]
        let duration = durationDatePicker.countDownDuration
        let dateTime = dateTimeDatePicker.date

        let activityData: [String: Any] = [
            "name": name,
            "description": description,
            "location": location,
            "requirements": requirements,
            "cost": cost,
            "category": category,
            "duration": duration,
            "dateTime": dateTime
        ]

        uploadActivity(activityData: activityData)
    }

    func uploadActivity(activityData: [String: Any]) {
        db.collection("activities").addDocument(data: activityData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Activity added successfully to Firestore")
            }
        }
    }
}

extension CreateActivityViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}
