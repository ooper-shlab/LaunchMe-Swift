# LaunchMe

## Description:
The LaunchMe sample application demonstrates how to implement a custom URL scheme to allow other applications to interact with your application.  It registers the "launchme" URL scheme, of which the URL contains an HTML color code (for example, #FF0000 or #F00) and text data.  The sample shows how to handle an incoming URL request by overriding `-application:openURL:sourceApplication:annotation:` to properly parse and extract information from the requested URL before updating the user interface.

Refer to the "Using URL Schemes to Communicate with Apps" section of the "App Programming Guide for iOS" for information about registering a custom URL scheme, including an overview of the necessary info.plist keys.
<https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html>


## Build Requirements
iOS 10.0 SDK or later


## Runtime Requirements
iOS 10.0 or later


## Debugging

To test the openURL delegate, you need to configure your project's Run scheme.

1) Set a break point somewhere in the openURL method.

2) To get the debug build on your device: run the app from Xcode to install it on your device and then stop it from Xcode.

3) Edit the target’s scheme in Xcode to find its "Run" configuration.

4) Under the Run section's Info tab, there is a radio button for "Wait for executable to be launched".
Make sure this is checked instead of the "Automatically" option.

5) Run the app from Xcode. It will not yet open on the device, and the debugger will wait for it to open and then it will attach to that process.

6) Open Mobile Safari, paste the custom URL and tap "Go" from the keyboard."

7) Xcode's debugger will then stop at openURL breakpoint.


Copyright (C) 2008-2017 Apple Inc. All rights reserved.
