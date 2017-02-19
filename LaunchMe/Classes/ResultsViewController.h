/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The view controller used to show the results of openURL.
 */

@import UIKit;

@interface ResultsViewController : UIViewController

// The displayed UIColor.  If the app was launched with a valid URL,
// this will be set by the AppDelegate to the decoded color.
@property (nonatomic, strong) UIColor *selectedColor;

// The displayed NSString.  If the app was launched with a valid URL,
// this will be set by the AppDelegate to the decoded string.
@property (nonatomic, strong) NSString *selectedString;

@end
