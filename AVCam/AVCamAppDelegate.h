#import <UIKit/UIKit.h>
#import "TXQcloudFrSDK.h"
#import "Auth.h"
#import "Conf.h"

@interface AVCamAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic, strong) TXQcloudFrSDK *sdk;
@property (strong, nonatomic) NSString* groupName;
@property (nonatomic) NSNumber* lastAssignedPersonId;

@property (nonatomic, strong) NSDictionary* personDatas;

+ (AVCamAppDelegate*) getInstance;
- (void) addPersonName:(NSString*)name WithId:(NSString*)pid WithTag:(NSString*)tag;
- (NSString*) getPersonNameFromId:(NSString*)personId;

@end
