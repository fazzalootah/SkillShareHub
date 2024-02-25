//
//  SignUpStep1.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 22/02/2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class SignUpStep1: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var db : Firestore!
    var selectedDistrictIndex: Int?
    
    @IBOutlet var dobPicker: UIDatePicker!
    @IBOutlet var pickerView: UIPickerView!
    
    @IBAction func continueSUS1(_ sender: UIButton) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        guard isUserAtLeast16YearsOld() else {
            presentAlert(message: "Accounts for under 16s aren't allowed for safeguarding purposes")
            disableAccountForUnderageUser()
            return
        }
        
        guard let index = selectedDistrictIndex else {
            presentAlert(message: "Please select a district")
            return
        }
        
        let selectedDistrict = pickerData[index]
        
        Task {
            do {
               try await saveSelectedDistrictToFirestore(userID:userID, district: selectedDistrict)
               try await saveDateOfBirth(userID: userID)
            } catch {
                DispatchQueue.main.async {
                    self.presentAlert(message: "An error occurred while saving your information")
                }
            }
        }
        presentSignUpStep2()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
  
    }
    
    @IBOutlet var welcomeUserName: UILabel!
    
    override func viewDidLoad() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        db = Firestore.firestore()
        fetchUserName()
        pickerData.sort()
        pickerView.dataSource = self
        pickerView.delegate = self
        selectedDistrictIndex = 0
    }
    
    func hasUserSelectedADistrict () -> Bool {
        return selectedDistrictIndex != nil
    }
    
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
    
    var pickerData: [String] = ["Al Rigga","Al Muraqqabat", "Al Murar", "Naif", "Al Baraha", "Abu Hail","Al Karama","Al Mankhool","Oud Maitha","Al Raffa", "Al Jafiliya", "Al Fahidi", "Al Souq Al Kabir", "Jumeirah", "Umm Suqeim", "Al Wasl", "Al Safa", "Al Manarah", "Jumierah Beach Residence", "The Walk", "Palm Jumierah", "Al Barsha 1","Al Barsha 2","Al Barsha 3", "Al Barsha South","Business Bay","Za'abeel", "Dubai Opera District","Dubai Creek Harbour", "Mirdif","Arabian Ranches", "Motor City","Sports City", "Mudon", "Remraam","Jebal Ali Village","Al Qouz","Ras Al Khor","International City","Silicon Oasis","Nad Al Shiba","Al Awir","Hatta","Festival City", "Al Jaddaf", "Al Khawaneej","Nadd Al Hamar", "Al Muhaisnah", "Twar"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func saveSelectedDistrictToFirestore(userID:String, district:String) async throws {
        do {
            try await db.collection("users").document(userID).setData(["District":district],merge:true)
            print("District saved successfully: \(district) ")
        } catch let error {
            print("Error saving district: \(error.localizedDescription)")
            DispatchQueue.main.async{
                self.presentAlert(message: "Failed to save district.")
            }
        }
    }
    
    func disableAccountForUnderageUser(){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).updateData(["isDisabled":true]) {
            err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("This account will be disabled for safeguarding reasons")
                    do {
                        try Auth.auth().signOut()
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                }
        }
        presentLandingPage()
    }
    
    func saveDateOfBirth(userID:String) async throws{
        let userDOB = Timestamp(date: dobPicker.date)
        do {
            try await db.collection("users").document(userID).setData(["dateOfBirth": userDOB], merge: true)
            print("Date of Birth successfully saved")
        } catch {
            print("An error has occured: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.presentAlert(message: "Failed to save date of birth")
            }
        }
    }
    
    func isUserAtLeast16YearsOld() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let birthDate = dobPicker.date
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        let age = ageComponents.year!
        return age >= 16
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       selectedDistrictIndex = row
    }
    
    func presentAlert(message:String) {
        let alertController = UIAlertController(title: "An error has occurred", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController,animated: true,completion: nil)
        }
    }
    
    func presentSignUpStep2(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpStep2")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func presentLandingPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "landingPage")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}
