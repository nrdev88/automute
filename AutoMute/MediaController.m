//
//  MediaController.m
//  AutoMute
//
//  Created by Nick Rappoldt on 20/12/2018.
//  Copyright © 2018 Yoni Levy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import "MJUserDefaults.h"
#import "MediaController.h"
#import "ScriptingBridges/iTunes.h"
#import "ScriptingBridges/Spotify.h"

@interface MediaController ()
@property(nonatomic, strong) MJUserDefaults *userDefaults;
@end

@implementation MediaController

-(instancetype)initWithUserDefaults:(MJUserDefaults *)userDefaults {
    NSLog(@"%s", "MediaController: initializing");
    
    self = [super init];
    if (!self) return nil;

    self.userDefaults = userDefaults;
    
    NSLog(@"%s", "MediaController: initialized");
    
    return self;
}

-(void)checkForPermissions
{
    NSLog(@"%s", "MediaController: Checking for permissions");
    
    if (@available(macOS 10.14, *)) {
        iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
        SpotifyApplication *spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
        
        if (iTunes != nil)
        {
            // [self checkSIPforAppIdentifier:@"com.apple.iTunes"];
        }
        
        if (spotify != nil)
        {
            // [self checkSIPforAppIdentifier:@"com.spotify.client"];
        }
    }

    NSLog(@"%s", "MediaController: Checked for permissions");
}

-(BOOL)checkSIPforAppIdentifier:(NSString*)identifier {
    NSLog(@"%s %@: %s", "MediaController:", identifier, "Checking");
    
    if (@available(macOS 10.14, *)) {
        NSAppleEventDescriptor *targetAppEventDescriptor = [NSAppleEventDescriptor descriptorWithBundleIdentifier:identifier];
        OSStatus status = AEDeterminePermissionToAutomateTarget(targetAppEventDescriptor.aeDesc, typeWildCard, typeWildCard, true);
        
        NSLog(@"%s %@: %i", "MediaController:", identifier, status);
        
        switch (status) {
            case -600: // Process not found
                NSLog(@"Not running app with id '%@'", identifier);
                break;
            case 0: // Application running
                NSLog(@"SIP check successfull for app with id '%@'", identifier);
                break;
            case -1744: // User required
                // This only appears if you send false for askUserIfNeeded
                NSLog(@"User consent required for app with id '%@'", identifier);
                break;
            case -1743: //errAEEventNotPermitted
                NSLog(@"User didn't allow usage for app with id '%@'", identifier);
                
                // Here you should present a dialog with a tutorial on how to activate it manually
                // This can be something like
                // Go to system preferences > security > privacy
                // Choose automation and active [APPNAME] for [APPNAME]
                
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Automation"]];
                
                return NO;
            default:
                break;
        }
    }

    return YES;
}

-(void)pauseAllMedia
{
    NSLog(@"%s", "MediaController: Pausing media");
    
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    SpotifyApplication *spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
    
    if ([iTunes isRunning]) [iTunes pause];
    if ([spotify isRunning]) [spotify pause];
    
    NSLog(@"%s", "MediaController: Paused media");
}

@end
