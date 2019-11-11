//
//  Review.swift
//  Snacktacular
//
//  Created by Isabelle Smyth on 11/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase
class Review {
    var title: String
    var text: String
    var rating: Int
    var reviewerUserID: String
    var date: Date
    var documentID: String
    var dictionary: [String: Any] {
        return ["title": title, "text": text, "rating": rating, "reviewerUserID": reviewerUserID, "date": date, "documentID": documentID ]
    }
    init(title: String, text: String, rating: Int, reviewerUserID: String, date: Date, documentID: String) {
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewerUserID = reviewerUserID
        self.date = date
        self.documentID = documentID
    }
    
    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "Uknown User"
        self.init(title: "", text: "", rating: 0, reviewerUserID: currentUserID, date: Date(), documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let rating = dictionary["rating"] as! Int? ?? 0
        let reviewerUserId = dictionary["reviewerUserId"] as! String? ?? ""
        let time = dictionary["date"] as! Timestamp
        let date = time.dateValue()
        let documentID = dictionary["documentID"] as! String ?? ""
        self.init(title: title, text: text, rating: rating, reviewerUserID: reviewerUserId, date: date, documentID: documentID)
    }
    
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        
        //create dict
        let dataToSave = self.dictionary
        //if we save record we will ahve doc id
        if self.documentID != "" {
            let ref = db.collection("spots").document(self.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("***ERROR: updating document \(self.documentID) in spot \(spot.documentID)")
                    completed(false)
                } else {
                    print("Document updated with doc id")
                    completed(true)
                }
                
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("***ERROR: creating document \(self.documentID) for new document ID \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("Document created with doc id")
                    completed(true)
                }
                
            }
        }
    }
}
