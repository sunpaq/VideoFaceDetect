#import "AVCamAppDelegate.h"

static AVCamAppDelegate* _instance = nil;

//Private
@interface AVCamAppDelegate()
- (void) increasePersonId;
@end

@implementation AVCamAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    _instance = self;
    _groupName = @"schindler-sodec";

    NSString *auth = [Auth appSign:1000000 userId:nil];
    self.sdk = [[TXQcloudFrSDK alloc] initWithName:[Conf instance].appId
                                     authorization:auth
                                          endPoint:[Conf instance].API_END_POINT];
    
    //resume datas
    self.lastAssignedPersonId = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastAssignedPersonId"];
    if (self.lastAssignedPersonId <= 0) {
        self.lastAssignedPersonId = [NSNumber numberWithInt:1];
    }
    
    self.personDatas = [[NSUserDefaults standardUserDefaults] objectForKey:@"personDatas"];
    if (self.personDatas == nil) {
        self.personDatas = [NSDictionary dictionary];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:self.lastAssignedPersonId forKey:@"lastAssignedPersonId"];
    [defs setObject:self.personDatas forKey:@"personDatas"];
}

+ (AVCamAppDelegate*) getInstance
{
    return _instance;
}

- (void) increasePersonId
{
    self.lastAssignedPersonId = [NSNumber numberWithInt:[self.lastAssignedPersonId intValue] + 1];
}

- (void) addPersonName:(NSString*)name WithId:(NSString*)pid WithTag:(NSString*)tag
{
    if (self.personDatas) {
        [self increasePersonId];
        
        NSMutableDictionary* dict = [self.personDatas mutableCopy];
        [dict setObject:name forKey:[NSString stringWithFormat:@"person%@",
                                     [self.lastAssignedPersonId stringValue]]];
        
        self.personDatas = dict;
    }
}

- (NSString*) getPersonNameFromId:(NSString*)personId
{
    if (self.personDatas) {
        return [self.personDatas objectForKey:personId];
    }
    return @"火星网友";
}

@end
