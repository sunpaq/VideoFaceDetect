#import "AppDelegate.h"

#define END_POINT_LIST_PERSONS @"http://eccwcl32138.global.schindler.com/FaceManagerService/api/Persons"
#define END_POINT_UP_PHOTO @"http://eccwcl32138.global.schindler.com/FaceManagerService/api/UploadPhoto"
#define GET_METHOD @"GET"
#define POST_METHOD @"POST"

#define NETWORK_ERR @"网络错误"
#define DEL_SUCCESS @"删除成功"
#define DEL_FAILED @"删除失败"
#define UP_SUCCESS @"上传成功"
#define UP_FAILED @"上传失败"
#define GOT_IT @"知道了"

static AppDelegate* _instance = nil;

//Private
@interface AppDelegate()
//- (void) increasePersonId;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    _instance = self;
    _groupName = @"all-star";

    NSString *auth = [Auth appSign:1000000 userId:nil];
    self.sdk = [[TXQcloudFrSDK alloc] initWithName:[Conf instance].appId
                                     authorization:auth
                                          endPoint:[Conf instance].API_END_POINT];
    
    //resume datas
    self.lastAssignedPersonId = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastAssignedPersonId"];
    if (self.lastAssignedPersonId <= 0) {
        self.lastAssignedPersonId = [NSNumber numberWithInt:1];
    }
    
    self.persons = [[NSUserDefaults standardUserDefaults] objectForKey:@"persons"];
    if (self.persons == nil) {
        self.persons = [NSArray array];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:self.lastAssignedPersonId forKey:@"lastAssignedPersonId"];
    [defs setObject:self.persons forKey:@"persons"];
}

+ (AppDelegate*) getInstance
{
    return _instance;
}

- (void) increasePersonId
{
    self.lastAssignedPersonId = [NSNumber numberWithInt:[self.lastAssignedPersonId intValue] + 1];
}

- (void) addPersonName:(NSString*)name WithId:(NSString*)pid WithTag:(NSString*)tag
{
    if (self.persons) {
//        [self increasePersonId];
//        
//        NSMutableDictionary* dict = [self.persons mutableCopy];
//        [dict setObject:name forKey:[NSString stringWithFormat:@"person%@",
//                                     [self.lastAssignedPersonId stringValue]]];
//        
//        self.persons = dict;
    }
}

- (NSString*) getPersonNameFromId:(NSString*)personId
{
    NSString* name = @"火星网友";
    if (self.persons) {
        for (Person* p in self.persons) {
            if (p) {
                NSString* idstr = [p.PersonId stringValue];
                if (idstr) {
                    if ([personId isEqualToString:idstr]) {
                        name = p.Name;
                    }
                }
            }
        }
    }
    return name;
}

- (void) uploadPhotoToTencent:(UIImage*)photo PersonId:(NSString*)pid PersonName:(NSString*)name Tag:(NSString*)tag
{
    [self.sdk newPerson:photo
              personId:pid
              groupIds:[NSArray arrayWithObjects:self.groupName, nil]
            personName:name
             personTag:tag
          successBlock:^(id responseObject) {
              // upload to TX success
              //NSDictionary* dict = (NSDictionary*)responseObject;
              //NSNumber* errorcode = [dict objectForKey:@"errorcode"];
              [[[UIAlertView alloc] initWithTitle:UP_SUCCESS
                                          message:[NSString stringWithFormat:@"%@ %@", pid, UP_SUCCESS]
                                         delegate:self
                                cancelButtonTitle:GOT_IT
                                otherButtonTitles:nil] show];
              
          } failureBlock:^(NSError *error) {
              // upload to TX failed
              NSString* errmsg = [NSString stringWithFormat:@"%@(%ld)", NETWORK_ERR, (long)error.code];
              [[[UIAlertView alloc] initWithTitle:errmsg
                                          message:error.localizedDescription
                                         delegate:self
                                cancelButtonTitle:GOT_IT
                                otherButtonTitles:nil] show];
          }];
}

- (void) removePhotoFromTencent:(NSString*)pid
{
    [self.sdk delPerson:pid successBlock:^(id responseObject) {
        // delete person success
        NSString* errmsg = [NSString stringWithFormat:@"%@", DEL_SUCCESS];
        [[[UIAlertView alloc] initWithTitle:errmsg
                                    message:[NSString stringWithFormat:@"%@ %@", pid, DEL_SUCCESS]
                                   delegate:self
                          cancelButtonTitle:GOT_IT
                          otherButtonTitles:nil] show];
        
    } failureBlock:^(NSError *error) {
        // delete person failed
        NSString* errmsg = [NSString stringWithFormat:@"%@(%ld)", DEL_FAILED, (long)error.code];
        [[[UIAlertView alloc] initWithTitle:errmsg
                                    message:error.localizedDescription
                                   delegate:self
                          cancelButtonTitle:GOT_IT
                          otherButtonTitles:nil] show];
    }];
}

- (void) fetchPersonList:(id<NSURLConnectionDelegate>)delegate WithEndPoint:(NSString*)endpoint
{
    NSMutableURLRequest* req = [[NSURLRequest requestWithURL:[NSURL URLWithString:endpoint]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:10] mutableCopy];
    req.HTTPMethod = GET_METHOD;
    //req.HTTPBody = @"";
    
    NSURLConnection* connect = [NSURLConnection connectionWithRequest:req delegate:delegate];
    [connect start];
}

- (void) uploadPhoto:(NSData*)pngdata
{
    NSMutableURLRequest* req = [[NSURLRequest requestWithURL:[NSURL URLWithString:END_POINT_UP_PHOTO]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:30] mutableCopy];
    req.HTTPMethod = POST_METHOD;
    req.HTTPBody   = pngdata;
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
    }];
}


@end
