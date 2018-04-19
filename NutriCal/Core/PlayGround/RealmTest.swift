//
//  RealmTest.swift
//  NutriCal
//
//  Created by Giancarlo on 19.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation
import RealmSwift

class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}

class Person: Object {
    @objc dynamic var name = ""
    @objc dynamic var picture: Data? = nil
    let dogs = List<Dog>()
}

class RealmTest {
    
    let realm = try! Realm()
    
    func read() {
        let puppy = realm.objects(Dog.self)
        print(puppy)
    }
    
    func write() {
        let myPuppy = Dog()
        myPuppy.age = 1
        myPuppy.name = "Puppy"
        
        try! realm.write {
            realm.add(myPuppy)
        }
    }
}
