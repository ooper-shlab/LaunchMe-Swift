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

import UIKit

@UIApplicationMain
@objc(LaunchMeAppDelegate)
class LaunchMeAppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // -------------------------------------------------------------------------------
    //	application:openURL:sourceApplication:annotation:
    // -------------------------------------------------------------------------------
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // You should be extremely careful when handling URL requests.
        // Take steps to validate the URL before handling it.
        
        // Check if the incoming URL is nil.
        
        // Invoke our helper method to parse the incoming URL and extact the color
        // to display.
        guard let launchColor = self.extractColorFromLaunchURL(url) else {
            // Stop if the url could not be parsed.
            return false
        }
        
        // Assign the created color object a the selected color for display in
        // RootViewController.
        (self.window!.rootViewController as! RootViewController).selectedColor = launchColor
        
        // Update the UI of RootViewController to notify the user that the app was launched
        // from an incoming URL request.
        (self.window!.rootViewController as! RootViewController).urlFieldHeader.text = "The app was launched with the following URL"
        
        return true
    }
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return application(app, openURL: url, sourceApplication: "", annotation: options)
    }
    
    // -------------------------------------------------------------------------------
    //	extractColorFromLaunchURL:
    //  Helper method that parses a URL and returns a UIColor object representing
    //  the first HTML color code it finds or nil if a valid color code is not found.
    //  This logic is specific to this sample.  Your URL handling code will differ.
    // -------------------------------------------------------------------------------
    private func extractColorFromLaunchURL(url: NSURL) -> UIColor? {
        // Hexadecimal color codes begin with a number sign (#) followed by six
        // hexadecimal digits.  Thus, a color in this format is represented by
        // three bytes (the number sign is ignored).  The value of each byte
        // corresponds to the intensity of either the red, blue or green color
        // components, in that order from left to right.
        // Additionally, there is a shorthand notation with the number sign (#)
        // followed by three hexadecimal digits.  This notation is expanded to
        // the six digit notation by doubling each digit: #123 becomes #112233.
        
        
        // Convert the incoming URL into a string.  The '#' character will be percent
        // escaped.  That must be undone.
        guard let urlString = url.absoluteString.stringByRemovingPercentEncoding else {
            // Stop if the conversion failed.
            return nil
        }
        
        // Create a regular expression to locate hexadecimal color codes in the
        // incoming URL.
        // Incoming URLs can be malicious.  It is best to use vetted technology,
        // such as NSRegularExpression, to handle the parsing instead of writing
        // your own parser.
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: "#[0-9a-f]{3}([0-9a-f]{3})?", options: .CaseInsensitive)
            
            // Check for any error returned.  This can be a result of incorrect regex
            // syntax.
        } catch {
            NSLog("%@", error as NSError)
            return nil
        }
        
        // Extract all the matches from the incoming URL string.  There must be at least
        // one for the URL to be valid (though matches beyond the first are ignored.)
        let regexMatches = regex.matchesInString(urlString, options: [], range: NSRange(0..<urlString.utf16.count))
        guard regexMatches.count >= 1 else {return nil}
        
        // Extract the first matched string
        let matchedString = (urlString as NSString).substringWithRange(regexMatches[0].range)
        
        // At this point matchedString will look similar to either #FFF or #FFFFFF.
        // The regular expression has guaranteed that matchedString will be no longer
        // than seven characters.
        
        // Extract an ASCII c string from matchedString.  The '#' character should not be
        // included.
        let matchedCString = matchedString.substringFromIndex(matchedString.startIndex.successor())
        
        // Convert matchedCString into an integer.
        let hexColorCode = UInt32(matchedCString, radix: 16)!
        
        var red, green, blue: CGFloat
        
        // If the color code is in six digit notation...
        if matchedString.utf16.count-1 > 3 {
            // Extract each color component from the integer representation of the
            // color code.  Each component has a value of [0-255] which must be
            // converted into a normalized float for consumption by UIColor.
            red = CGFloat((hexColorCode & 0x00FF0000) >> 16) / 255.0
            green = CGFloat((hexColorCode & 0x0000FF00) >> 8) / 255.0
            blue = CGFloat(hexColorCode & 0x000000FF) / 255.0
            // The color code is in shorthand notation...
        } else {
            // Extract each color component from the integer representation of the
            // color code.  Each component has a value of [0-255] which must be
            // converted into a normalized float for consumption by UIColor.
            red = CGFloat((hexColorCode & 0x00000F00) >> 8) / 15.0
            green = CGFloat((hexColorCode & 0x000000F0) >> 4) / 15.0
            blue = CGFloat(hexColorCode & 0x0000000F) / 15.0
        }
        
        // Create and return a UIColor object with the extracted components.
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
}