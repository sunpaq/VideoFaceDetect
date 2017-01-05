#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//NSNumber* EmployeeId = [person objectForKey:@"EmployeeId"];
//NSString* FirstName  = [person objectForKey:@"FirstName"];
//NSString* Group      = [person objectForKey:@"Group"];
//NSNumber* GroupId    = [person objectForKey:@"GroupId"];
//NSNumber* Id         = [person objectForKey:@"Id"];
//NSString* LastName   = [person objectForKey:@"LastName"];
//NSString* Name       = [person objectForKey:@"Name"];

@interface Person : NSObject

@property (nonatomic, strong) UIImage* faceImage;

@property (nonatomic, strong) NSNumber* EmployeeId;
@property (nonatomic, strong) NSString* FirstName;
@property (nonatomic, strong) NSString* Group;
@property (nonatomic, strong) NSNumber* GroupId;
@property (nonatomic, strong) NSNumber* Id;
@property (nonatomic, strong) NSString* LastName;
@property (nonatomic, strong) NSString* Name;

+ (NSArray*) getPersonsFromJSONData:(NSData*)data;
+ (Person*) personWithJSONObject:(NSDictionary*)dict;

- (Person*) loadJSONObject:(NSDictionary*)dict;
- (NSDictionary*) jsonObject;

@end
