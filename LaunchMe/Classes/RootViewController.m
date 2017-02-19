/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application's main view controller.
 */

#import "RootViewController.h"
#import "LaunchMeAppDelegate.h"

@interface RootViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UISlider *redSlider;
@property (nonatomic, weak) IBOutlet UISlider *greenSlider;
@property (nonatomic, weak) IBOutlet UISlider *blueSlider;
@property (nonatomic, weak) IBOutlet UITextField *urlField;
@property (nonatomic, weak) IBOutlet UIView *colorView;
@property (nonatomic, weak) IBOutlet UITextField *inputTextField;

@end

#pragma mark -

@implementation RootViewController

#pragma mark - View Lifecycle

// -------------------------------------------------------------------------------
//	viewDidLoad
// -------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inputTextField.text = NSLocalizedString(@"random text", @"");
    [self updateURLField];
}


#pragma mark - UI Updating

// -------------------------------------------------------------------------------
//	updateURLField:
//
//  Build the URL field in this format:
//      launchme://?color=000000&text=some%20text
// -------------------------------------------------------------------------------
- (void)updateURLField
{
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat alpha = 0.0f;
    [self.colorView.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];

    NSString *colorText = [NSString stringWithFormat:@"%.2x%.2x%.2x",
                           (unsigned char)(red * 255),
                           (unsigned char)(green * 255),
                           (unsigned char)(blue * 255)];
    
    // Replace any characters not compatible for a URL
    NSString *dataString = self.inputTextField.text;
    dataString = [dataString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    self.urlField.text = [NSString stringWithFormat:@"launchme://?%@=%@&%@=%@", ColorKey, colorText, TextKey, dataString];
}


// -------------------------------------------------------------------------------
//	updateWithColor:color:
//
//  Update the interface to display aColor.  This includes modifying colorView
//  to show aColor, moving the red, green, and blue sliders to match the R, G, and
//  B components of aColor, and updating urlLabel to display the corresponding
//  URL for aColor.
// -------------------------------------------------------------------------------
- (void)updateWithColor:(UIColor *)aColor
{
    // There is a possibility that -getRed:green:blue:alpha: could fail if aColor
    // is not in a compatible color space.  In such a case, the arguments are not
    // modified.  Having default values will allow for a more graceful failure
    // than picking up whatever is currently on the stack.
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat alpha = 0.0f;
    
    if ([aColor getRed:&red green:&green blue:&blue alpha:&alpha] == NO)
    {
        // While setting default values for red, green, blue and alpha guards against
        // undefined results if -getRed:green:blue:alpha: fails, aColor will be assigned
        // as the backgroundColor of colorView a few lines down.
        // Initialize aColor to the black color so it matches the color code that will
        // be displayed in the urlLabel.
        //
        aColor = [UIColor blackColor];
    }
    
    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
    
    self.colorView.backgroundColor = aColor;
    
    [self updateURLField];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self updateURLField];
    
    [self.inputTextField resignFirstResponder];

    return YES;
}


#pragma mark - Actions

// -------------------------------------------------------------------------------
//	sliderValueDidChange:
//
//  IBAction for all three sliders.
// -------------------------------------------------------------------------------
- (IBAction)sliderValueDidChange:(id)sender
{
    [self updateURLField];
    
    [self updateWithColor:[UIColor colorWithRed:self.redSlider.value
                                          green:self.greenSlider.value
                                           blue:self.blueSlider.value
                                          alpha:1.0f]];
}

// -------------------------------------------------------------------------------
//	startMobileSafari:
//
//  IBAction for the Launch Mobile Safari button.
// -------------------------------------------------------------------------------
- (IBAction)startMobileSafari:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.urlField.text;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apple.com"]
                                       options:@{}
                             completionHandler:^(BOOL success) {
        // Mobile Safari was opened.
    }];
}

@end
