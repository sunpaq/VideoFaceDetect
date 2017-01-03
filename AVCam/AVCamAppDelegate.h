/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Application delegate.
*/

@import UIKit;

#import "TXQcloudFrSDK.h"
#import "Auth.h"
#import "Conf.h"

@interface AVCamAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic, strong) TXQcloudFrSDK *sdk;
@property (strong, nonatomic) NSString* groupName;
@property (nonatomic) NSNumber* lastAssignedPersonId;

+ (AVCamAppDelegate*) getInstance;
- (void) addPersonName:(NSString*)name WithTag:(NSString*)tag;
- (NSString*) getPersonNameFromId:(NSString*)personId;

@end
