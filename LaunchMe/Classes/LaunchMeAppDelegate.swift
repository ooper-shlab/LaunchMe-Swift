//
//  LaunchMeAppDelegate.swift
//  LaunchMe
//
//  Translated by OOPer in cooperation with shlab.jp, on 2015/10/26.
//
//
/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The application's delegate class.  Handles incoming URL requests.
*/

// Keys to each parameter value in the URL
// (shared between App Delegate and RootViewController)
//
let ColorKey = "color"
let TextKey = "text"

import UIKit

@UIApplicationMain
@objc(LaunchMeAppDelegate)
class LaunchMeAppDelegate: NSObject, UIApplicationDelegate {
    
    // The app delegate must implement the window @property
    // from UIApplicationDelegate @protocol to use a main storyboard file.
    //
    var window: UIWindow?
    
    // -------------------------------------------------------------------------------
    //	application:openURL:sourceApplication:annotation:
    // -------------------------------------------------------------------------------
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var succeeded = false
        
        // You should be extremely careful when handling URL requests.
        // Take steps to validate the URL before handling it.
        
        // Check if the incoming URL is nil.
        //### not needed
        
        if case let inputParameters = self.extractURLParametersFromLaunchURL(url), !inputParameters.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let resultsViewController = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
            resultsViewController.selectedColor = inputParameters[ColorKey] as? UIColor
            resultsViewController.selectedString = inputParameters[TextKey] as? String
            
            // Show the ResultsViewController with our url parameters.
            let navController = self.window!.rootViewController as! UINavigationController
            navController.pushViewController(resultsViewController, animated: false)
            
            succeeded = false
        }
        
        return succeeded
    }
    
    // -------------------------------------------------------------------------------
    //	parseQueryString:query:
    //
    //  Takes the query portion of a URL and returns a simple dictionary of key/value pairs
    //  representing those query parameters.
    // -------------------------------------------------------------------------------
    private func parseQuery(from query: String) -> [String: String] {
        var dict: [String: String] = [:]
        let pairs = query.components(separatedBy: "&")
        
        for pair in pairs {
            let elements = pair.components(separatedBy: "=")
            let key = elements[0].removingPercentEncoding ?? ""
            let val = elements[1].removingPercentEncoding ?? ""
            dict[key] = val
        }
        return dict
    }
    
    // -------------------------------------------------------------------------------
    //	extractURLParametersFromLaunchURL:url:
    // -------------------------------------------------------------------------
    private func extractURLParametersFromLaunchURL(_ url: URL) -> [String: Any] {
        var queryParameters: [String: Any] = [:]
        
        let queryStr = url.query ?? ""
        let inputs = self.parseQuery(from: queryStr)
        if !inputs.isEmpty {
            
            if let textParamStr = inputs[TextKey] {
                queryParameters[TextKey] = textParamStr
            }
            
            let testParamColorStr = inputs[ColorKey] ?? "0"
            
            // Extract an ASCII c string from matchedString.
            
            // Convert matchedCString into an integer.
            let hexColorCode = UInt32(testParamColorStr, radix: 16) ?? 0
            
            var testRed, testGreen, testBlue: CGFloat
            
            if testParamColorStr.characters.count-1 > 3 {  // If the color code is in six digit notation...
                // Extract each color component from the integer representation of the
                // color code.  Each component has a value of [0-255] which must be
                // converted into a normalized float for consumption by UIColor.
                testRed = CGFloat((hexColorCode & 0x00FF0000) >> 16) / 255.0
                testGreen = CGFloat((hexColorCode & 0x0000FF00) >> 8) / 255.0
                testBlue = CGFloat(hexColorCode & 0x000000FF) / 255.0
            } else {
                // The color code is in shorthand notation...
                //
                // Extract each color component from the integer representation of the
                // color code.  Each component has a value of [0-255] which must be
                // converted into a normalized float for consumption by UIColor.
                testRed = CGFloat(((hexColorCode & 0x00000F00) >> 8) | ((hexColorCode & 0x00000F00) >> 4)) / 255.0
                testGreen = CGFloat(((hexColorCode & 0x000000F0) >> 4) | (hexColorCode & 0x000000F0)) / 255.0
                testBlue = CGFloat((hexColorCode & 0x0000000F) | ((hexColorCode & 0x0000000F) << 4)) / 255.0
            }
            
            // Create and return a UIColor object with the extracted components.
            let paramColor = UIColor(red: testRed, green: testGreen, blue: testBlue, alpha: 1.0)
            queryParameters[ColorKey] = paramColor
        }
        
        return queryParameters
    }
    
}
