/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application's delegate class. Handles incoming URL requests.
 */

#import "LaunchMeAppDelegate.h"
#import "RootViewController.h"
#import "ResultsViewController.h"

@implementation LaunchMeAppDelegate

// The app delegate must implement the window @property
// from UIApplicationDelegate @protocol to use a main storyboard file.
//
@synthesize window;

// -------------------------------------------------------------------------------
//	application:openURL:sourceApplication:annotation:
// -------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{    
    BOOL succeeded = NO;
    
    // You should be extremely careful when handling URL requests.
    // Take steps to validate the URL before handling it.
    
    // Check if the incoming URL is nil.
    if (url != nil)
    {
        NSDictionary *inputParameters = [self extractURLParametersFromLaunchURL:url];
        if (inputParameters)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ResultsViewController *resultsViewController = [storyboard instantiateViewControllerWithIdentifier:@"ResultsViewController"];
            resultsViewController.selectedColor = inputParameters[ColorKey];
            resultsViewController.selectedString = inputParameters[TextKey];
            
            // Show the ResultsViewController with our url parameters.
            UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
            [navController pushViewController:resultsViewController animated:NO];

            succeeded = YES;
        }
    }
    
    return succeeded;
}

// -------------------------------------------------------------------------------
//	parseQueryString:query:
//
//  Takes the query portion of a URL and returns a simple dictionary of key/value pairs
//  representing those query parameters.
// -------------------------------------------------------------------------------
- (NSDictionary *)parseQueryFromString:(NSString *)query
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];

    for (NSString *pair in pairs)
    {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [elements[0] stringByRemovingPercentEncoding];
        NSString *val = [elements[1] stringByRemovingPercentEncoding];
        dict[key] = val;
    }
    return dict;
}

// -------------------------------------------------------------------------------
//	extractURLParametersFromLaunchURL:url:
// -------------------------------------------------------------------------
- (NSDictionary *)extractURLParametersFromLaunchURL:(NSURL *)url
{
    NSMutableDictionary *queryParameters = nil;
    
    NSString *queryStr = url.query;
    NSDictionary *inputs = [self parseQueryFromString:queryStr];
    if (inputs != nil && inputs.count > 0)
    {
        queryParameters = [NSMutableDictionary dictionary];
        
        NSString *textParamStr = inputs[TextKey];
        if (textParamStr != nil)
        {
            queryParameters[TextKey] = textParamStr;
        }
        
        NSString *testParamColorStr = inputs[ColorKey];
        
        // Extract an ASCII c string from matchedString.
        const char *matchedCString = [[testParamColorStr substringFromIndex:0] cStringUsingEncoding:NSASCIIStringEncoding];
        
        // Convert matchedCString into an integer.
        unsigned long hexColorCode = strtoul(matchedCString, NULL, 16);
        
        CGFloat testRed, testGreen, testBlue;
        
        if (testParamColorStr.length-1 > 3)  // If the color code is in six digit notation...
        {
            // Extract each color component from the integer representation of the
            // color code.  Each component has a value of [0-255] which must be
            // converted into a normalized float for consumption by UIColor.
            testRed = ((hexColorCode & 0x00FF0000) >> 16) / 255.0f;
            testGreen = ((hexColorCode & 0x0000FF00) >> 8) / 255.0f;
            testBlue = (hexColorCode & 0x000000FF) / 255.0f;
        }
        else
        {
            // The color code is in shorthand notation...
            //
            // Extract each color component from the integer representation of the
            // color code.  Each component has a value of [0-255] which must be
            // converted into a normalized float for consumption by UIColor.
            testRed = (((hexColorCode & 0x00000F00) >> 8) | ((hexColorCode & 0x00000F00) >> 4)) / 255.0f;
            testGreen = (((hexColorCode & 0x000000F0) >> 4) | (hexColorCode & 0x000000F0)) / 255.0f;
            testBlue = ((hexColorCode & 0x0000000F) | ((hexColorCode & 0x0000000F) << 4)) / 255.0f;
        }
        
        // Create and return a UIColor object with the extracted components.
        UIColor *paramColor = [UIColor colorWithRed:testRed green:testGreen blue:testBlue alpha:1.0f];
        if (paramColor != nil)
        {
            queryParameters[ColorKey] = paramColor;
        }
    }
    
    return queryParameters;
}

@end
