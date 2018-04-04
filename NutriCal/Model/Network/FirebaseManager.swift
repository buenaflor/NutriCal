//
//  FirebaseManager.swift
//  NutriCal
//
//  Created by Giancarlo on 02.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation

import Firebase
import FirebaseStorage

enum ConfirmationState: String {
    case pending = "PENDING"
    case confirmed = "APPROVED"
    case denied = "DENIED"
}

class FirebaseManager {
    let db = Firestore.firestore()
    
    func fetchRole(completion: @escaping (_ isRestaurantOwner: Bool) -> Void) {
        let ref = db.collection("roles")
        .whereField("role", isEqualTo: "restaurant")
        
        ref.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if Auth.auth().currentUser?.uid == document.documentID {
                        completion(true)
                        return
                    }
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func fetchRestaurant(completion: @escaping ([RestaurantIdentifier]) -> Void) {
        fetchRole { (isRestaurantOwner) in
            if !isRestaurantOwner {
                print("Error - Access Denied: cannot fetch restaurants")
            }
            else {
                let ref = self.db
                    .collection("restaurantOwner").document((Auth.auth().currentUser?.uid)!)
                    .collection("restaurants")
                
                ref.getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {

                        var restaurantIdentifiers = [RestaurantIdentifier]()
                        var count = 0
                        
                        if let restaurants = querySnapshot?.documents.flatMap({
                            $0.data().flatMap({ (data) in
                                return Restaurant(dictionary: data)
                            })
                        }) {
                            
                            querySnapshot?.documents.forEach({ (document) in
                                restaurantIdentifiers.append(RestaurantIdentifier(restaurant: restaurants[count], documentIdentifier: document.documentID))
                                count = count + 1
                            })
                            
                            completion(restaurantIdentifiers)
        
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
    }
    
    func addRestaurantToCurrentUser(with name: String, street: String, postalCode: String, city: String, image: UIImage, filePath: URL, completion: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        let batch = db.batch()
        
        let restaurants = db.collection("restaurantOwner").document((Auth.auth().currentUser?.uid)!)
            .collection("restaurants").document()
        
        self.uploadImageFile(image: image, filePath: filePath) { (downloadUrl) in
            
            let restaurant = Restaurant(name: name, street: street, postalCode: postalCode, city: city, confirmation: "PENDING", imageFilePath: downloadUrl)
            batch.setData(restaurant.dictionary, forDocument: restaurants)
            
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write to 'restaurant' succeeded.")
                    completion()
                }
            }
        }
    }
    
    func uploadImageFile(image: UIImage, filePath: URL, completion: @escaping (_ imageUrl: String) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()

        let childRef = storageRef.child(filePath.lastPathComponent)
        // Create a reference to the file you want to upload
        
        if let uploadData = UIImagePNGRepresentation(image) {
            childRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")

                } else {
                    guard let imageUrl = metadata?.downloadURL() else { return }
                    completion(imageUrl.absoluteString)
                }
            }
        }
    }
    
    func listenToRestaurantChanges(change: () -> Void) {
        _ = db.collection("restaurantOwner").document((Auth.auth().currentUser?.uid)!).collection("restaurants")
            .addSnapshotListener { documentSnapshot, error in
                //                guard let document = documentSnapshot else {
                //                    print("Error fetching documents: \(error!)")
                //                    return
                //                }
                
                //                documentSnapshot?.documents.forEach({
                //                    print($0.data())
                //                })
                
                documentSnapshot?.documentChanges.forEach({ (diff) in
                    if (diff.type == .added) {
                        let restaurant = Restaurant(dictionary: diff.document.data())
                        print("added:", restaurant)
                    }
                })
        }
    }
}
