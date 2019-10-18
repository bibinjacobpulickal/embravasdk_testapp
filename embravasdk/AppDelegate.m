//
//  AppDelegate.m
//  embravasdk
//
//  Created by Senthilnathan T on 28/08/17.
//  Copyright © 2017 Embrava. All rights reserved.
//

#import "AppDelegate.h"
#import "CWLSynthesizeSingleton.h"
#import "blynclightcontrol.h"
#import "EmbravaTestAppUi.h"

@interface AppDelegate ()

@property IBOutlet NSWindow *window;

@end

@implementation AppDelegate

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS (AppDelegate);

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(beginActivityWithOptions:reason:)]) {
        self.activity = [[NSProcessInfo processInfo] beginActivityWithOptions:0x00FFFFFF reason:@"receiving OSC messages"];
    }
    
    [[EmbravaTestAppUi sharedEmbravaTestAppUi] Initialize];    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [[self window] makeKeyAndOrderFront:self];
    
    return YES;
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}


@end
