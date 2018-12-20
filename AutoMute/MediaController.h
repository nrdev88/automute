//
//  MediaController.h
//  AutoMute
//
//  Created by Nick Rappoldt on 20/12/2018.
//  Copyright © 2018 Yoni Levy. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface MediaController : NSObject

-(instancetype)initWithUserDefaults:(MJUserDefaults *)userDefaults;
-(BOOL)checkSIPforAppIdentifier:(NSString*)identifier;
-(void)checkForPermissions;
-(void)pauseAllMedia;

@end
