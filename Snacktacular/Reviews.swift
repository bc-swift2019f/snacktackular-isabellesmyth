//
//  Reviews.swift
//  Snacktacular
//
//  Created by Isabelle Smyth on 11/10/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
        
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()) {
  
        guard spot.documentID != "" else {
          
            return
            
        }
        print("LOADING DATA from collection")
       // let documentID = spot.documentID
        db.collection("spots").document(spot.documentID).collection("reviews").addSnapshotListener{ (QuerySnapshot, error) in
            guard error == nil else {
                print("******ERROR: adding snapshot listener")
                return completed()
            }
            self.reviewArray = []
           // let snapshot = QuerySnapshot!
            print("QUERY \(QuerySnapshot!.documents)")
            for document in QuerySnapshot!.documents {
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
                
            }
            completed()
        }
    }
}
