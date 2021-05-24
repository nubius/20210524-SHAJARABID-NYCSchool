//
//  NYCSchool.swift
//  20210524-SHAJARABID-NYCSchools
//
//  Created by Shajar Abid 05/24/21.
//  Copyright © 2021 Shajar Abid. All rights reserved.
//

import Foundation

// A model that defines a single NYC School
struct NYCSchool: Equatable {
    var id: String
    var name: String
    var location: String
    
    
    // Initializes new NYCSchool object
    init(id: String, name: String, location: String) {
        self.id = id
        self.name = name
        self.location = location
    }
    
    // Initializes local NYCSchool model from JSON string
    init?(json: [String: Any]) throws {
        // Extract and validate id
        guard let id = json["dbn"] as? String else {
            throw SerializationError.missing("dbn")
        }
        
        // Extract and validate name
        guard let name = json["school_name"] as? String else {
            throw SerializationError.missing("school_name")
        }
        
        // Extract and validate location
        guard let location = json["location"] as? String else {
            throw SerializationError.missing("location")
        }
        
        self.id = id
        self.name = name
        self.location = location
    }
    
    // Returns true if two NYCShool structs are the same school
    static func == (schoolA: NYCSchool, schoolB: NYCSchool) -> Bool {
        return (
            (schoolA.id == schoolB.id) &&
                (schoolA.name == schoolB.name) &&
                (schoolA.location == schoolB.location)
        )
    }
}
