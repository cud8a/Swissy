//
//  City.swift
//  Swissy
//
//  Created by Tamas Bara on 04.11.18.
//  Copyright © 2018 Tamas Bara. All rights reserved.
//

import ObjectMapper
import Firebase

struct City {
    var id: String?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    
    init(id: String, data: [String: Any]) {
        self.id = id
        name = data["name"] as? String
        if let coordinates = data["coordinates"] as? GeoPoint {
            latitude = coordinates.latitude
            longitude = coordinates.longitude
        }
    }
}

extension City: Mappable {
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        latitude <- map["lat"]
        longitude <- map["long"]
    }
}
