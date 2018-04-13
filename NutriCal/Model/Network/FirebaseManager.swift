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
                        print("completed")
                        return
                    }
                    else {
                        completion(false)
                    }
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func fetchOwnerRestaurant(completion: @escaping ([RestaurantIdentifier]) -> Void) {
        
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
    
    func fetchEndUserRestaurant(completion: @escaping ([RestaurantIdentifier]) -> Void) {
        let ownerRef = self.db
            .collection("restaurantOwner")
        
        ownerRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                querySnapshot?.documents.forEach({ (document) in
                    let restaurantRef = ownerRef.document(document.documentID).collection("restaurants")
                    
                    restaurantRef.getDocuments(completion: { (querySnapshot, err) in
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
                            }
                        }
                    })
                })
            }
        }
    }
    
    func fetchFood(restaurantIdentifier: RestaurantIdentifier, menu: Menu, completion: @escaping ((InternalMenu) -> Void)) {
        let ownerRef = self.db
            .collection("restaurantOwner")
        
        ownerRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                querySnapshot?.documents.forEach({ (document) in
                    let restaurantRef = ownerRef.document(document.documentID)
                        .collection("restaurants").document(restaurantIdentifier.documentIdentifier)
                        .collection("menu").document(menu.title)
                        .collection("food")
                    
                    restaurantRef.getDocuments(completion: { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            if let foods = querySnapshot?.documents.flatMap({
                                $0.data().flatMap({ (data) in
                                    return Food(dictionary: data)
                                })
                            }) {
                                let internalMenu = InternalMenu(menu: menu, foods: foods)
                                completion(internalMenu)
                            }
                        }
                    })
                })
            }
        }
        
//        let ref = self.db
//            .collection("restaurantOwner").document((Auth.auth().currentUser?.uid)!)
//            .collection("restaurants").document(restaurantIdentifier.documentIdentifier)
//            .collection("menu").document(menu.title)
//            .collection("food")
//
//        ref.getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                if let foods = querySnapshot?.documents.flatMap({
//                    $0.data().flatMap({ (data) in
//                        return Food(dictionary: data)
//                    })
//                }) {
//                    let internalMenu = InternalMenu(menu: menu, foods: foods)
//                    completion(internalMenu)
//                }
//            }
//        }
    }
    
    func fetchMenu(restaurantIdentifier: RestaurantIdentifier, completion: @escaping (([Menu]) -> Void) ) {
        
        let ownerRef = self.db
            .collection("restaurantOwner")
        
        ownerRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                querySnapshot?.documents.forEach({ (document) in
                    let restaurantRef = ownerRef.document(document.documentID)
                        .collection("restaurants").document(restaurantIdentifier.documentIdentifier)
                        .collection("menu")
                    
                    restaurantRef.getDocuments(completion: { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            if let menus = querySnapshot?.documents.flatMap({
                                $0.data().flatMap({ (data) in
                                    return Menu(dictionary: data)
                                })
                            }) {
                                completion(menus)
                            }
                            else {
                                print("Something went wrong")
                            }
                        }
                    })
                })
            }
        }
    
//        let ref = self.db
//            .collection("restaurantOwner").document((Auth.auth().currentUser?.uid)!)
//            .collection("restaurants").document(restaurantIdentifier.documentIdentifier)
//            .collection("menu")
//
//        ref.getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                if let menus = querySnapshot?.documents.flatMap({
//                    $0.data().flatMap({ (data) in
//                        return Menu(dictionary: data)
//                    })
//                }) {
//                    completion(menus)
//                }
//                else {
//                    print("Something went wrong")
//                }
//            }
//        }
    }
    
    
    func addRestaurantToCurrentUser(with name: String, street: String, postalCode: String, city: String, filePath: String, cuisine: String, completion: @escaping () -> Void) {
        
        let batch = db.batch()
        
        let restaurants = db.collection("restaurantOwner").document((Auth.auth().currentUser?.uid)!)
            .collection("restaurants").document()
        
        self.upload(file: filePath) { (downloadUrl) in
            let restaurant = Restaurant(name: name, street: street, postalCode: postalCode, city: city, confirmation: "PENDING", imageFilePath: downloadUrl, cuisine: cuisine)
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
    
    func uploadFoodImages(internalMenu: InternalMenu, completion: (_ internalMenu: InternalMenu) -> Void) {
        
        var menu = internalMenu
        
        for (index, food) in internalMenu.foods.enumerated() {
            self.upload(file: food.imageLink, completion: { (downloadURL) in
                menu.foods[index] = Food(name: food.name, description: food.description, isVegan: food.isVegan, ingredients: food.ingredients, kCal: food.kCal, price: food.price, imageLink: downloadURL)
            })
        }
        
        completion(menu)
    }
    
    func addMenuToRestaurant(internalMenu: InternalMenu, restaurantIdentifier: RestaurantIdentifier, completion: @escaping () -> Void) {
        
        let batch = db.batch()
        
        let menuDoc = db.collection("restaurantOwner").document((Auth.auth().currentUser?.uid)!)
            .collection("restaurants").document(restaurantIdentifier.documentIdentifier).collection("menu").document(internalMenu.menu.title)
        
        batch.setData(internalMenu.menu.dictionary, forDocument: menuDoc)
        
        internalMenu.foods.forEach({ (food) in
            let foodDoc = menuDoc.collection("food").document(food.name)
            batch.setData(food.dictionary, forDocument: foodDoc)
        })
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write 'menu' to 'restaurant' succeeded.")
                completion()
            }
        }
    }
    
    func upload(file path: String, completion: @escaping (_ imageURL: String) -> Void) {
        let path = URL(fileURLWithPath: path)
        
        let storageRef = storage.reference()
        
        let imagesRef = storageRef.child("images/\(path.lastPathComponent)")
        
        let uploadTaskTest  = imagesRef.putFile(from: path)
        
        uploadTaskTest.resume()
        
        uploadTaskTest.observe(.success) { (snapshot) in
            guard let imageUrl = snapshot.metadata?.downloadURL() else { return }
            completion(imageUrl.absoluteString)
        }
    }
    
    func uploadReviewDummyData(restaurantIdentifier: RestaurantIdentifier, completion: @escaping () -> Void) {
        let batch = db.batch()
        
        let ownerRef = self.db
            .collection("restaurantOwner")
        print(restaurantIdentifier.restaurant.name)
        ownerRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                querySnapshot?.documents.forEach({ (document) in
                    let restaurantRef = ownerRef.document(document.documentID)
                        .collection("restaurants").document(restaurantIdentifier.documentIdentifier)
                        .collection("reviews").document()
                    
                    for _ in 1..<30 {
                        let rand  = arc4random_uniform(5)

                        if rand != 0 {
                            let review = Review(username: "Dummy", rating: Int(rand), comment: "Dummy Comment", date: "Dummy Date")
                            batch.setData(review.dictionary, forDocument: restaurantRef)
                            
                            batch.commit() { err in
                                if let err = err {
                                    print("Error writing batch \(err)")
                                } else {
                                    print("Batch write 'dummyData' to 'restaurant' succeeded.")
                                    completion()
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
    func upload(review: Review, restaurantIdentifier: RestaurantIdentifier, completion: @escaping () -> Void) {
        
        let batch = db.batch()
        
        let ownerRef = self.db
            .collection("restaurantOwner")
        print(restaurantIdentifier.restaurant.name)
        ownerRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                querySnapshot?.documents.forEach({ (document) in
                    let restaurantRef = ownerRef.document(document.documentID)
                        .collection("restaurants").document(restaurantIdentifier.documentIdentifier)
                        .collection("reviews").document()
                    
                    batch.setData(review.dictionary, forDocument: restaurantRef)
                    
                    batch.commit() { err in
                        if let err = err {
                            print("Error writing batch \(err)")
                        } else {
                            print("Batch write 'dummyData' to 'restaurant' succeeded.")
                            completion()
                        }
                    }
                })
            }
        }
    
    }
    
    func fetchReviews(from restaurantIdentifier: RestaurantIdentifier, completion: @escaping (([Review]) -> Void)) {

        let ownerRef = self.db
            .collection("restaurantOwner")
    
        ownerRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                querySnapshot?.documents.forEach({ (document) in
                    let restaurantRef = ownerRef.document(document.documentID)
                        .collection("restaurants").document(restaurantIdentifier.documentIdentifier)
                        .collection("reviews")
                    
                    restaurantRef.getDocuments(completion: { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            if let reviews = querySnapshot?.documents.compactMap({
                                $0.data().flatMap({ (data) in
                                    return Review(dictionary: data)
                                })
                            }) {
                                completion(reviews)
                            }
                            else {
                                print("fetching went wrong")
                            }
                        }
                    })
                })
            }
        }
//
//        ref.getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error writing batch \(err)")
//            } else {
//                if let reviews = querySnapshot?.documents.flatMap({
//                    $0.data().flatMap({ (data) in
//                        return Review(dictionary: data)
//                    })
//                }) {
//                    completion(reviews)
//                }
//            }
//        }
    }
    
    func calculateAverageRating(from restaurantIdentifier: RestaurantIdentifier, completion: @escaping ((Double) -> Void)) {
        fetchReviews(from: restaurantIdentifier) { (reviews) in
            if reviews.count != 0 {
                var totalRating = 0
                for review in reviews {
                    totalRating = totalRating + review.rating
                }
                let avgRating = Double(totalRating) / Double(reviews.count)
                completion(avgRating)
            }
            else {
                completion(0)
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
