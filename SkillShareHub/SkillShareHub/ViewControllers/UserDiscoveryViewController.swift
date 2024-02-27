//
//  UserDiscoveryViewController.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 27/02/2024.
//

import UIKit
import FirebaseFirestore

struct User {
    let username: String
    // Add other user properties as needed
}

class UserDiscoveryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        fetchUsers()
    }
    
    func fetchUsers() {
        db.collection("users").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            self.users = querySnapshot?.documents.compactMap { document in
                let data = document.data()
                let username = data["username"] as? String ?? ""
                return User(username: username)
            } ?? []
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension UserDiscoveryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.username
        return cell
    }
}
