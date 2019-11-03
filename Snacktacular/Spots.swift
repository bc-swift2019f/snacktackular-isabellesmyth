//
//  Spots.swift
//  Snacktacular
//
//  Created by Isabelle Smyth on 11/3/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase
class Spots {
    var spotsArray = [Spot]()
    var db: Firestore!
    
    
    init() {
        db = Firestore.firestore()
    }
    
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("spots").addSnapshotListener{ (QuerySnapshot, error) in
            guard error == nil else {
                print("******ERROR: adding snapshot listener")
                return completed()
            }
            self.spotsArray = []
            for document in QuerySnapshot!.documents {
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotsArray.append(spot)
                
            }
            completed()
        }
    }
}


