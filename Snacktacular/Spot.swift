//
//  Spot.swift
//  Snacktacular
//
//  Created by Isabelle Smyth on 11/3/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation

import CoreLocation
import Firebase
class Spot {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "longitude": longitude, "latitude": latitude, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID]
    }
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    convenience init(){
        self.init(name: "", address: "", coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
        
    }
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int ?? 0
        let postingUserID = dictionary["postingUserID"] as! String ?? ""
        self.init(name: name, address: address, coordinate: coordinate, averageRating: averageRating, numberOfReviews: numberOfReviews, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("***ERROR: could not save data because we do not have a valid posting user id")
            return completed(false)
        }
        self.postingUserID = postingUserID
        //create dict
        let dataToSave = self.dictionary
        //if we save record we will ahve doc id
        if self.documentID != "" {
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("***ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("Document updated with doc id")
                    completed(true)
                }
                
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("***ERROR: creating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("Document created with doc id")
                    completed(true)
                }
                
            }
        }
    }
}


