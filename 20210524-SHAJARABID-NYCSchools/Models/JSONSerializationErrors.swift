//
//  JSONSerializationErrors.swift
//  20210524-SHAJARABID-NYCSchools
//
//  Created by Shajar Abid 05/24/21.
//  Copyright © 2021 Shajar Abid. All rights reserved.
//

// JSON intializer error handeling
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
