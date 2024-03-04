//
//  Algolia.swift
//  SkillShareHub
//
//  Created by Fazza Lootah on 26/02/2024.
//

import FirebaseFirestore
import UIKit
import AlgoliaSearchClient


func importDataFromFirestoreToAlgolia() {
    let db = Firestore.firestore()
    db.collection("yourCollectionName").getDocuments { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                // Create a record for Algolia using the document data
                // Note: You might need to adjust this based on your data structure
                let record = ["objectID": document.documentID, "name": data["name"] ?? "", "description": data["description"] ?? ""]
                index.saveObject(record, autoGeneratingObjectID: false) { result in
                    switch result {
                    case .success(let response):
                        print("Document added to Algolia: \(response)")
                    case .failure(let error):
                        print("Error adding document to Algolia: \(error)")
                    }
                }
            }
        }
    }
}

class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchAlgolia(query: searchText)
    }

    func searchAlgolia(query: String) {
        index.search(query: Query(query)) { result in
            switch result {
            case .success(let response):
                print("Algolia search results: \(response)")
                // Process and display your search results here
            case .failure(let error):
                print("Error during Algolia search: \(error)")
            }
        }
    }
}
