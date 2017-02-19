//
//  RootViewController.swift
//  LaunchMe
//
//  Translated by OOPer in cooperation with shlab.jp, on 2015/10/26.
//
//
/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The application's root view controller.
*/

import UIKit

@objc(RootViewController)
class RootViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var redSlider: UISlider!
    @IBOutlet private weak var greenSlider: UISlider!
    @IBOutlet private weak var blueSlider: UISlider!
    @IBOutlet private weak var urlField: UITextField!
    @IBOutlet private weak var colorView: UIView!
    @IBOutlet private weak var inputTextField: UITextField!
    
    //MARK: -
    
    //MARK: - View Lifecycle
    
    // -------------------------------------------------------------------------------
    //	viewDidLoad
    // -------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inputTextField.text = NSLocalizedString("random text", comment: "")
        self.updateURLField()
    }
    
    
    //MARK: - UI Updating
    
    // -------------------------------------------------------------------------------
    //	updateURLField:
    //
    //  Build the URL field in this format:
    //      launchme://?color=000000&text=some%20text
    // -------------------------------------------------------------------------------
    func updateURLField() {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        self.colorView.backgroundColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let colorText = String(format: "%.2x%.2x%.2x",
                               Int(red * 255),
                               Int(green * 255),
                               Int(blue * 255))
        
        // Replace any characters not compatible for a URL
        var dataString = self.inputTextField.text ?? ""
        dataString = dataString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        
        self.urlField.text = "launchme://?\(ColorKey)=\(colorText)&\(TextKey)=\(dataString)"
    }
    
    
    // -------------------------------------------------------------------------------
    //	updateWithColor:color:
    //
    //  Update the interface to display aColor.  This includes modifying colorView
    //  to show aColor, moving the red, green, and blue sliders to match the R, G, and
    //  B components of aColor, and updating urlLabel to display the corresponding
    //  URL for aColor.
    // -------------------------------------------------------------------------------
    func updateWith(_ aColor: UIColor) {
        // There is a possibility that -getRed:green:blue:alpha: could fail if aColor
        // is not in a compatible color space.  In such a case, the arguments are not
        // modified.  Having default values will allow for a more graceful failure
        // than picking up whatever is currently on the stack.
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        var color = aColor
        if !aColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            // While setting default values for red, green, blue and alpha guards against
            // undefined results if -getRed:green:blue:alpha: fails, aColor will be assigned
            // as the backgroundColor of colorView a few lines down.
            // Initialize aColor to the black color so it matches the color code that will
            // be displayed in the urlLabel.
            //
            color = UIColor.black
        }
        
        self.redSlider.value = Float(red)
        self.greenSlider.value = Float(green)
        self.blueSlider.value = Float(blue)
        
        self.colorView.backgroundColor = color
        
        self.updateURLField()
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateURLField()
        
        self.inputTextField.resignFirstResponder()
        
        return true
    }
    
    
    //MARK: - Actions
    
    // -------------------------------------------------------------------------------
    //	sliderValueDidChange:
    //  IBAction for all three sliders.
    // -------------------------------------------------------------------------------
    @IBAction func sliderValueDidChange(_: Any) {
        self.updateURLField()
        
        self.updateWith(UIColor(red: CGFloat(self.redSlider.value),
                                green: CGFloat(self.greenSlider.value),
                                blue: CGFloat(self.blueSlider.value),
                                alpha: 1.0))
    }
    
    // -------------------------------------------------------------------------------
    //	startMobileSafari:
    //
    //  IBAction for the Launch Mobile Safari button.
    // -------------------------------------------------------------------------------
    @IBAction func startMobileSafari(_: AnyObject) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.urlField.text
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: "http://www.apple.com")!, options: [:], completionHandler: {success in
                // Mobile Safari was opened.
            })
        } else {
            UIApplication.shared.openURL(URL(string: "http://www.apple.com")!)
        }
    }
    
}
