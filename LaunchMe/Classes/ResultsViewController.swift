//
//  ResultsViewController.swift
//  LaunchMe
//
//  Created by 開発 on 2017/2/14.
//
//
/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:
 The view controller used to show the results of openURL.
 */

import UIKit

@objc(ResultsViewController)
class ResultsViewController: UIViewController {
    
    // The displayed UIColor.  If the app was launched with a valid URL,
    // this will be set by the AppDelegate to the decoded color.
    var selectedColor: UIColor?
    
    // The displayed NSString.  If the app was launched with a valid URL,
    // this will be set by the AppDelegate to the decoded string.
    var selectedString: String?
    
    @IBOutlet weak var resultsTextField: UITextField!
    
    
    //MARK: -
    
    // -------------------------------------------------------------------------------
    //	viewDidLoad
    // -------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color and text field to the values that were determined when first loaded as a result of openURL.
        self.view.backgroundColor = self.selectedColor
        self.resultsTextField.text = self.selectedString
    }
    
}
