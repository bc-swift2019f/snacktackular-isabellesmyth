//
//  Photos.swift
//  Snacktacular
//
//  Created by Isabelle Smyth on 11/11/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photos{
    var photoArray: [Photo] = []
    var db: Firestore!
    
    
    init(){
        db = Firestore.firestore()
        
    }
    
    func loadData(spot: Spot, completed: @escaping () -> ()) {
        
        guard spot.documentID != "" else {
           
            return
            
        }
        
        let storage = Storage.storage()
  
        db.collection("spots").document(spot.documentID).collection("photos").addSnapshotListener{ (QuerySnapshot, error) in
            guard error == nil else {
                print("******ERROR: adding snapshot listener")
                return completed()
            }
            self.photoArray = []
            var loadAttempts = 0
            let storageRef = storage.reference().child(spot.documentID)
            let snapshot = QuerySnapshot!
            print("QUERY \(QuerySnapshot!.documents)")
            for document in QuerySnapshot!.documents {
                let photo = Photo(dictionary: document.data())
                photo.documentUUID = document.documentID
                self.photoArray.append(photo)
                
                
                //loading in firebase storage images
                let photoRef = storageRef.child(photo.documentUUID)
                photoRef.getData(maxSize: 25 * 1025 * 1025) { data, error in
                    if let error = error {
                        print("****ERROR: an error occurred while reading data from file ref: \(photoRef) \(error.localizedDescription) ")
                        loadAttempts += 1
                        if loadAttempts >= (QuerySnapshot!.count) {
                            return completed()
                        }
                    } else {
                        let image = UIImage(data: data!)
                        photo.image = image!
                        loadAttempts += 1
                        if loadAttempts >= (QuerySnapshot!.count) {
                            return completed()
                        }
                    }
                }
                
            }
        }
    }
}
