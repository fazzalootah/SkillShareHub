//
//  SignUpStep2.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 23/02/2024.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class SignUpStep2: UIViewController, UITextFieldDelegate{
    var selectedSkills : [String:Bool] = [:]
    var db: Firestore!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        db = Firestore.firestore()
    }
    
    @IBAction func graphicDesignSkill(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    @IBAction func visualArtsSkill(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    
    @IBAction func gamingSkill(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    
    @IBAction func musicSkill(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    
    @IBAction func woodworkingSkill(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    
    @IBAction func danceSkill(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    
    @IBAction func actSkill(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    @IBAction func photographySkill(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    @IBAction func englishLitSkill(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    @IBAction func stemSkill(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    @IBAction func financeSkills(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    @IBAction func eCommerceSkills(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    @IBAction func subejctTutoring(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    @IBAction func signLanguage(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    @IBAction func serviceAsAction(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    @IBAction func creativityServiceAction(_ sender: UIButton) {
        guard let skillName = sender.titleLabel?.text else { return }
        let isSelected = !(selectedSkills[skillName] ?? false)
        selectedSkills[skillName] = isSelected
        
        updateButtonAppearance(sender, isSelected:isSelected)
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        saveSelectedSkills()
    }
    
    func updateButtonAppearance(_ button:UIButton, isSelected:Bool) {
        if isSelected {
            button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
            button.setTitleColor(.systemBlue, for: .normal)
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            button.backgroundColor = .clear
            button.setTitleColor(.systemBlue, for: .normal)
            button.layer.borderWidth = 0
        }
        button.layer.cornerRadius = 8
    }
    
    func saveSelectedSkills(){
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let selectedSkillNames = selectedSkills.filter {$0.value}.map {$0.key}
        
        db.collection("users").document(userID).updateData(["skills":selectedSkillNames]) { error in
            if let error = error {
                print ("Error saving skills: \(error.localizedDescription)")
            } else {
                print("Skills successfully saved")
                DispatchQueue.main.async{
                    self.showSuccessAndNavigate()
                }
            }
        }
    }
    
    func showSuccessAndNavigate() {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Dashboard")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}
