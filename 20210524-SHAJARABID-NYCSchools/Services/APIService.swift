//
//  APIService.swift
//  20210524-SHAJARABID-NYCSchools
//
//  Created by Shajar Abid 05/24/21.
//  Copyright © 2021 Shajar Abid. All rights reserved.
//

import Foundation

class APIService: NSObject {
    
    //
    // GET: Retrieves all NYC School data
    //
    func getNYCSchoolData(completion: @escaping (Result<[NYCSchool], Error>) -> Void) {
        let schoolDataEndpoint: String = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
        // An error occurred when creating the API url endpoint
        guard let url = URL(string: schoolDataEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let searchURL = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Start URL session to get data from endpoint
        session.dataTask(with: searchURL) { (data, _, error) in
            // An error occurred when making the API call
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            // An error occurred with the data that was retrieved
            guard let data = data else {
                print("Error: cannot get data")
                return
            }
            // Getting JSON data to parse into NYCSchool model
            var schools: [NYCSchool] = []
            if let jsonDataArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for eachData in jsonDataArray {
                    if let school = try? NYCSchool(json: eachData) {
                        schools.append(school)
                    }
                }
                schools = schools.sorted { $0.name < $1.name }
                DispatchQueue.main.async {
                    completion(.success(schools))
                }
            }
        }.resume()
    }
    
    
    
    //
    // GET: Retrieves SAT data for a single NYC school
    //
    func getNYCSchoolSATData(schoolID: String, completion: @escaping (Result<NYCSchoolSAT, Error>) -> Void) {
        let schoolSATDataEndpoint: String = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?dbn=" + schoolID
        // An error occurred when creating the API url endpoint
        guard let url = URL(string: schoolSATDataEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let searchURL = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Start URL session to get data from endpoint
        session.dataTask(with: searchURL) { (data, _, error) in
            // An error occurred when making the API call
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            // An error occurred with the data that was retrieved
            guard let data = data else {
                print("Error: cannot get data")
                return
            }
            // Getting JSON data to parse into NYCSchoolSAT model
            var schoolSAT: NYCSchoolSAT!
            
            if let jsonDataArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for eachData in jsonDataArray {
                    if let school = try? NYCSchoolSAT(json: eachData) {
                        schoolSAT = school
                    }
                }
                // Make sure the NYCSchoolSAT contains valid data.
                if (schoolSAT == nil || !schoolSAT.isValidAverageScores()) {
                    schoolSAT = NYCSchoolSAT(averageSATScoreReading: "N/A", averageSATScoreMath: "N/A", averageSATScoreWriting: "N/A")
                }
                DispatchQueue.main.async {
                    completion(.success(schoolSAT))
                }
            }
        }.resume()
    }
}

