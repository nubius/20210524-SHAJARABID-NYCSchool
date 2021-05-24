//
//  SpinnerService.swift
//  20210524-SHAJARABID-NYCSchools
//
//  Created by Shajar Abid 05/24/21.
//  Copyright © 2021 Shajar Abid. All rights reserved.
//

import UIKit

var spinner: UIView?

// Extension of UIViewController to display and hide a reusable loading spinner
extension UIViewController {
    
    // Initialize activity indicator spinner
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
        
        // Add activity indicator to view controller
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
        }
        spinner = spinnerView
    }
    
    // Remove the activity indicator from the view controller
    func removeSpinner() {
        DispatchQueue.main.async {
            spinner?.removeFromSuperview()
            spinner = nil
        }
    }
}
