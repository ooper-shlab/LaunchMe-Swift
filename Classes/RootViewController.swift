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
class RootViewController: UIViewController {
    
    // The displayed UIColor.  If the app was launched with a valid
    // URL, this will be set by the AppDelegate to the decoded color.
    var selectedColor: UIColor? {
        didSet {
            didSetSelectedColor(oldValue)
        }
    }
    
    // Outlet for the label above the displayed URL.
    // The AppDelegate updates the text of this label to notify the user
    // that the app was launched from a URL request.
    @IBOutlet weak var urlFieldHeader: UILabel!
    
    
    // Things for IB
    @IBOutlet private weak var redSlider: UISlider!
    @IBOutlet private weak var greenSlider: UISlider!
    @IBOutlet private weak var blueSlider: UISlider!
    @IBOutlet private weak var urlField: UITextField!
    @IBOutlet private weak var colorView: UIView!
    
    
    // -------------------------------------------------------------------------------
    //	updateWithColor:
    //  Update the interface to display aColor.  This includes modifying colorView
    //  to show aColor, moving the red, green, and blue sliders to match the R, G, and
    //  B components of aColor, and updating urlLabel to display the corresponding
    //  URL for aColor.
    // -------------------------------------------------------------------------------
    private func updateWithColor(var aColor: UIColor?) {
        // There is a possibility that -getRed:green:blue:alpha: could fail if aColor
        // is not in a compatible color space.  In such a case, the arguments are not
        // modified.  Having default values will allow for a more graceful failure
        // than picking up whatever is currently on the stack.
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if !(aColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha) ?? false) {
            // While setting default values for red, green, blue and alpha
            // guards against undefined results if -getRed:green:blue:alpha:
            // fails, aColor will be assigned as the backgroundColor of
            // colorView a few lines down.  Initialize aColor to the black
            // color so it matches the color code that will be displayed in
            // the urlLabel.
            aColor = UIColor.blackColor()
            
        }
        
        self.redSlider.value = Float(red)
        self.greenSlider.value = Float(green)
        self.blueSlider.value = Float(blue)
        
        self.colorView.backgroundColor = aColor
        
        // Construct the URL for the specified color.  This URL allows another app
        // to start LauncMe with the specific color displayed initially.
        // When entering a custom url into Safari's address field, Safari may interpret
        // the url as a search query unless you include "//" after the url scheme.
        self.urlField.text = String(format: "launchme://#%.2x%.2x%.2x",
            Int32(red * 255),
            Int32(green * 255),
            Int32(blue * 255))
        
        self.urlFieldHeader.text = "Tap to select the URL"
    }
    
    // -------------------------------------------------------------------------------
    //	setSelectedColor:
    //  Custom implementation of the setter for the selectedColor property.
    // -------------------------------------------------------------------------------
    private func didSetSelectedColor(oldValue: UIColor?) {
        if selectedColor !== oldValue {
            self.updateWithColor(selectedColor)
        }
    }
    
    //MARK: - View Lifecycle
    
    // -------------------------------------------------------------------------------
    //	viewDidLoad
    // -------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The AppDelegate may have assigned a color to selectedColor that should
        // be the color displayed initially.  This would have occurred before the
        // view was actually loaded meaning that while -updateWithColor was executed,
        // it had no effect.  The solution is to call it again here now that there is
        // a UI to update.
        self.updateWithColor(selectedColor)
    }
    
    //MARK: - Actions
    
    // -------------------------------------------------------------------------------
    //	touchesEnded:withEvent:
    //  Deselects the text in the urlField if the user taps in the white space
    //  of this view controller's view.
    // -------------------------------------------------------------------------------
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let textStart = self.urlField.beginningOfDocument
        let textRange = self.urlField.textRangeFromPosition(textStart, toPosition: textStart)
        self.urlField.selectedTextRange = textRange //###
    }
    
    // -------------------------------------------------------------------------------
    //	urlFieldWasTapped:
    //  IBAction for the tap gesture recognizer defined in this view controller's
    //  scene in the storyboard.  Selects the text displayed in the urlField.
    // -------------------------------------------------------------------------------
    @IBAction func urlFieldWasTapped(_: AnyObject) {
        self.urlField.selectAll(self)
    }
    
    // -------------------------------------------------------------------------------
    //	sliderValueDidChange:
    //  IBAction for all three sliders.
    // -------------------------------------------------------------------------------
    @IBAction func sliderValueDidChange(_: AnyObject) {
        // Create a new UIColor object with the current value of all three sliders
        // (it does not matter which one was actualy modified).  Assign it
        // as the new selectedColor.  The override of the setter for selectedColor
        // will handle updating the UI.
        self.selectedColor = UIColor(red: CGFloat(self.redSlider.value),
            green: CGFloat(self.greenSlider.value),
            blue: CGFloat(self.blueSlider.value),
            alpha: 1.0)
    }
    
    // -------------------------------------------------------------------------------
    //	startMobileSafari:
    //  IBAction for the Launch Mobile Safari button.
    // -------------------------------------------------------------------------------
    @IBAction func startMobileSafari(_: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.apple.com")!)
    }
    
}