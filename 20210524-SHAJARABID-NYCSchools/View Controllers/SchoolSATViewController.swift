//
//  SchoolSATViewController.swift
//  20210524-SHAJARABID-NYCSchools
//
//  Created by Shajar Abid 05/24/21.
//  Copyright © 2021 Shajar Abid. All rights reserved.
//

import UIKit

class SchoolSATViewController: UIViewController {
    // Storyboard Outlets
    @IBOutlet weak var ControllerTitleLabel: UILabel!
    @IBOutlet weak var AverageSATReadingScoreLabel: UILabel!
    @IBOutlet weak var AverageSATMathScoreLabel: UILabel!
    @IBOutlet weak var AverageSATWritingScoreLabel: UILabel!
    
    // Controller Values
    let apiService = APIService()
    var schoolID: String!
    var schoolName: String!
    var schoolSAT: NYCSchoolSAT!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNYCSchoolSATData()
    }
    
    // Fetches and displays selected NYCSchool's average SAT scores from API call
    func fetchNYCSchoolSATData() {
        self.ControllerTitleLabel.text = schoolName + "\nAverage SAT Scores"
        self.ControllerTitleLabel.adjustsFontSizeToFitWidth = true
        
        // Wait for async api call to finish retrieving school data
        self.showSpinner(onView: self.view)
        apiService.getNYCSchoolSATData(schoolID: schoolID, completion: { results in
            switch results {
                
            // Successful API call
            case .success(let school):
                self.schoolSAT = school
                
                self.AverageSATReadingScoreLabel.text = self.schoolSAT.averageSATScoreReading
                self.AverageSATMathScoreLabel.text = self.schoolSAT.averageSATScoreMath
                self.AverageSATWritingScoreLabel.text = self.schoolSAT.averageSATScoreWriting
                
            // An error occurred during API call
            case .failure(let error):
                let alert = UIAlertController(title: "An Error Occurred", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                    self.fetchNYCSchoolSATData()
                }))
                self.present(alert, animated: true)
            }
            self.removeSpinner()
        })
    }
}
