/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The view controller used to show the results of openURL.
 */

#import "ResultsViewController.h"

@interface ResultsViewController ()

@property (nonatomic, weak) IBOutlet UITextField *resultsTextField;

@end


#pragma mark -

@implementation ResultsViewController

// -------------------------------------------------------------------------------
//	viewDidLoad
// -------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the background color and text field to the values that were determined when first loaded as a result of openURL.
    self.view.backgroundColor = self.selectedColor;
    self.resultsTextField.text = self.selectedString;
}

@end
