//
//  Photo.swift
//  Snacktacular
//
//  Created by Isabelle Smyth on 11/11/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var date: Date
    var documentUUID: String
    var dictionary: [String: Any] {
        return ["description": description, "postedBy": postedBy, "date": date ]
    }
    init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.documentUUID = documentUUID
    }
    
    convenience init(){
        let postedBy = Auth.auth().currentUser?.email ?? "unknown user"
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let postedBy = dictionary["postedBy"] as! String? ?? ""
        let time = dictionary["date"] as! Timestamp
        let date = time.dateValue()
        self.init(image: UIImage(), description: description, postedBy: postedBy, date: date, documentUUID: "")
    }
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
         let db = Firestore.firestore()
        let storage = Storage.storage()
        //convert photo.image to datatype so that it can be saved by firebase storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("*****ERROR: could not convert image to data format")
            return completed(false)
        }
        documentUUID = UUID().uuidString //generate unique id to use for photo image's name
        //create a ref to upload storage to spot.documentid's folder (bucket) with the name we created
        let storageRef = storage.reference().child(spot.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData)
        uploadTask.observe(.success) { (snapshot) in
                     //create dict
            let dataToSave = self.dictionary
            //if we save record we will ahve doc id
            //this will either create a new documentUUId or update the existing doc that name
                let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentUUID)
                ref.setData(dataToSave) { (error) in
                    if let error = error {
                        print("***ERROR: updating document \(self.documentUUID) in spot \(spot.documentID)")
                        completed(false)
                    } else {
                        print("Document updated with doc id")
                        completed(true)
                    }
                    
                }
        }
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("***ERROR: upload task for file \(self.documentUUID) failed in spot \(spot.documentID)")
            }
            return completed(false)
        }

          
     }
}
