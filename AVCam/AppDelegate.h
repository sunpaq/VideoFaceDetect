#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TXQcloudFrSDK.h"
#import "Auth.h"
#import "Conf.h"
#import "Person.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic, strong) TXQcloudFrSDK *sdk;
@property (strong, nonatomic) NSString* groupName;
@property (nonatomic) NSNumber* lastAssignedPersonId;

@property (nonatomic, strong) NSDictionary* personDatas;

+ (AppDelegate*) getInstance;
- (void) addPersonName:(NSString*)name WithId:(NSString*)pid WithTag:(NSString*)tag;
- (NSString*) getPersonNameFromId:(NSString*)personId;

- (void) uploadPhotoToTencent:(UIImage*)photo PersonId:(NSString*)pid PersonName:(NSString*)name Tag:(NSString*)tag;
- (void) removePhotoFromTencent:(NSString*)pid;

- (void) fetchPersonList:(id<NSURLConnectionDelegate>)delegate WithEndPoint:(NSString*)endpoint;
- (void) uploadPhoto:(NSData*)pngdata;

@end
