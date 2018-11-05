//
//  CitiesService.swift
//  Swissy
//
//  Created by Tamas Bara on 05.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import Foundation
import Firebase

enum CitiesService {
    
    static var db: Firestore {
        FirebaseApp.configure()
        return Firestore.firestore()
    }
    
    static func cities(completion: @escaping ([City]?, Error?) -> Void) {
        db.collection("cities").getDocuments() { querySnapshot, error in
            if let error = error {
                completion(nil, error)
            } else {
                var cities: [City] = []
                querySnapshot?.documents.forEach { snapshot in
                    cities.append(City(id: snapshot.documentID, data: snapshot.data()))
                }
                completion(cities, nil)
            }
        }
    }
}
