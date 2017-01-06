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

@property (atomic, strong) UIImage* faceImage;

@property (atomic, strong) NSString* EmployeeId;
@property (atomic, strong) NSString* FirstName;
@property (atomic, strong) NSString* Group;
@property (atomic, strong) NSNumber* GroupId;
@property (atomic, strong) NSNumber* PersonId;
@property (atomic, strong) NSString* LastName;
@property (atomic, strong) NSString* Name;

+ (NSArray*) getPersonsFromJSONData:(NSData*)data;
+ (NSArray*) getPersonsFromJSOString:(NSString*)string;
+ (Person*) personWithJSONObject:(NSDictionary*)dict;

- (Person*) loadJSONObject:(NSDictionary*)dict;
- (NSDictionary*) jsonObject;

//for test
+ (NSString*) dummyPersonsString;
+ (NSArray*) dummyPersons;

@end
