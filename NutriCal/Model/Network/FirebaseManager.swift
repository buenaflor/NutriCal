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
    let storage = Storage.storage()

    
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
    
    func fetchMenu(restaurantIdentifier: RestaurantIdentifier, completion: @escaping (_ internalMenus: [InternalMenu]?, _ hasMenus: Bool) -> Void) {
        
        let ref = self.db
            .collection("restaurantOwner").document((Auth.auth().currentUser?.uid)!)
            .collection("restaurants").document(restaurantIdentifier.documentIdentifier)
            .collection("menu")
        
        ref.getDocuments { (querySnapshot, err) in
            
            var internalMenu = [InternalMenu]()
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot?.count != 0 {
                    
                    querySnapshot?.documents.forEach({ (document) in
                        
//                        print("id", document.documentID)
                        
                        let menuRef = ref.document(document.documentID)
                        
                        menuRef.getDocument(completion: { (snapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                
                                if let menu = snapshot.flatMap({
                                    $0.data().flatMap({ (data) in
                                        return Menu(dictionary: data)
                                    })
                                }) {
                                    let foodRef = menuRef.collection("food")
                                    
                                    foodRef.getDocuments(completion: { (querySnapshot, err) in
                                        if let err = err {
                                            print("Error getting documents: \(err)")
                                        } else {
                                            if let food = querySnapshot?.documents.flatMap({
                                                $0.data().flatMap({ (data) in
                                                    return Food(dictionary: data)
                                                })
                                            }) {
                                                internalMenu.append(InternalMenu(menu: menu, foods: food))
                                            }
                                        }
                                    })
                                }
                            }
                        })
                    })
                    completion(internalMenu, true)
                }
                else {
                    completion(nil, false)
                }
            }
        }
    }
    
    func addRestaurantToCurrentUser(with name: String, street: String, postalCode: String, city: String, filePath: String, completion: @escaping () -> Void) {
        
        let batch = db.batch()
        
        let restaurants = db.collection("restaurantOwner").document((Auth.auth().currentUser?.uid)!)
            .collection("restaurants").document()
        
        self.upload(file: filePath) { (downloadUrl) in
            
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
    
    func addMenuToRestaurant(internalMenu: InternalMenu, restaurantIdentifier: RestaurantIdentifier, completion: @escaping () -> Void) {
        
        let batch = db.batch()
        
        let menu = db.collection("restaurantOwner").document((Auth.auth().currentUser?.uid)!)
            .collection("restaurants").document(restaurantIdentifier.documentIdentifier).collection("menu").document(internalMenu.menu.title)
        
        batch.setData(internalMenu.menu.dictionary, forDocument: menu)
        
        internalMenu.foods.forEach { (food) in
            let foodDoc = menu.collection("food").document(food.name)
            self.upload(file: food.imageLink, completion: { (downloadURL) in
                let food = Food(name: food.name, isVegan: food.isVegan, ingredients: food.ingredients, kCal: food.kCal, price: food.price, imageLink: downloadURL)
                batch.setData(food.dictionary, forDocument: foodDoc)
            })
        }

    
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write 'menu' to 'restaurant' succeeded.")
                completion()
            }
        }
    }
    
//    func uploadImageFile(image: UIImage, filePath: URL, completion: @escaping (_ imageUrl: String) -> Void) {
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//
//        let childRef = storageRef.child(filePath.lastPathComponent)
//        // Create a reference to the file you want to upload
//
//        if let uploadData = UIImagePNGRepresentation(image) {
//            childRef.putData(uploadData, metadata: nil) { (metadata, error) in
//                if error != nil {
//                    print("error")
//
//                } else {
//                    guard let imageUrl = metadata?.downloadURL() else { return }
//                    completion(imageUrl.absoluteString)
//                }
//            }
//        }
//    }
    
    func upload(file path: String, completion: @escaping (_ imageURL: String) -> Void) {
        let path = URL(fileURLWithPath: path)
        
        let storageRef = storage.reference()
        
        let imagesRef = storageRef.child("images/\(path.lastPathComponent)")
        
        let uploadTask = imagesRef.putFile(from: path, metadata: nil) { (metaData, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            else {
                guard let imageUrl = metaData?.downloadURL() else { return }
                completion(imageUrl.absoluteString)
                print("success bro: \(metaData?.downloadURL())")
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
