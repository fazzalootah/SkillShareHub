//
//  Search.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 29/02/2024.
//
import Foundation
import UIKit

class Search: UIViewController {
       
    @IBOutlet var searchActivity: UITextField!
    override func viewDidLoad() {
           super.viewDidLoad()
           scrollView.isHidden = true // Hide scroll view initially
           activityIndicator.stopAnimating()
           activityIndicator.isHidden = true // Hide it initially
        setupButton()
        setupButton3()
        setupButton4()
        setupButton2()
       }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        self.searchActivity.resignFirstResponder()
        return true
    }
       
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func buttonTapped(_ sender: UIButton) {
        activityIndicator.isHidden = false // Show it
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2 seconds delay
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true // Hide it again
            self.scrollView.isHidden = false
            // Load content into the scrollView
        }
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
        let image = UIImage(named: "graphic")?.withRenderingMode(.alwaysOriginal)
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

}
