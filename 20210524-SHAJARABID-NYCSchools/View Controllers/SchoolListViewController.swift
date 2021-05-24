//
//  SchoolListViewController.swift
//  20210524-SHAJARABID-NYCSchools
//
//  Created by Shajar Abid 05/24/21.
//  Copyright © 2021 Shajar Abid. All rights reserved.
//

import UIKit

class SchoolListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    // Storyboard Outlets
    @IBOutlet weak var schoolListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Controller Values
    let apiService = APIService()
    var isSearching = false
    var errorOccurred = true
    var schoolList: [NYCSchool] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTable()
    }
    
    // Refreshes the table view
    func refreshTable() {
        // Wait for async api call to finish retrieving school data
        self.showSpinner(onView: self.view)
        apiService.getNYCSchoolData( completion: { results in
            switch results {
                
            // Successful API call
            case .success(let schools):
                self.schoolList = schools
                // Only display filtered schools if search bar is active
                if (self.isSearching) {
                    self.schoolList = self.schoolList.filter({
                        ($0.name.lowercased().contains(self.searchBar.text!.lowercased())) ||
                            ($0.location.lowercased().contains(self.searchBar.text!.lowercased()))
                    })
                }
                self.schoolListTableView.reloadData()
                
            // An error occurred during API call
            case .failure(let error):
                self.showUnableToFetchDataAlert(error: error)
            }
            self.removeSpinner()
        })
    }
    
    // Creates UI alert if there was an issue fetching the data
    func showUnableToFetchDataAlert(error: Error) {
        let alert = UIAlertController(title: "An Error Occurred", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.refreshTable()
        }))
        self.present(alert, animated: true)
    }
    
    // Returns integer value of entry count in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolList.count
    }
    
    // Returns cell for a single school in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath)
        
        let schoolName = schoolList[indexPath.item].name
        let schoolLocation = schoolList[indexPath.item].location
        
        cell.textLabel?.text = schoolName
        cell.detailTextLabel?.text = schoolLocation
        
        return cell
    }
    
    // The searchBar search button is pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = (searchBar.text == nil || searchBar.text == "") ?false : true
        refreshTable()
        searchBar.endEditing(true)
    }
    
    // Preparing specific NYCSchool to transition to SchoolSATViewController with
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSchoolSAT") {
            if let indexPath = schoolListTableView.indexPathForSelectedRow {
                let schoolID = schoolList[indexPath.item].id
                let schoolName = schoolList[indexPath.item].name
                let controller = segue.destination as! SchoolSATViewController
                controller.schoolID = schoolID
                controller.schoolName = schoolName
            }
        }
    }
}
