
#import "Person.h"
#import "AppDelegate.h"

@implementation Person

- (Person*) loadJSONObject:(NSDictionary*)dict
{
    NSString* EmployeeId = [dict objectForKey:@"EmployeeId"];
    NSString* FirstName  = [dict objectForKey:@"FirstName"];
    NSString* Group      = [dict objectForKey:@"Group"];
    NSNumber* GroupId    = [dict objectForKey:@"GroupId"];
    NSNumber* Id         = [dict objectForKey:@"Id"];
    NSString* LastName   = [dict objectForKey:@"LastName"];
    NSString* Name       = [dict objectForKey:@"Name"];
    
    self.EmployeeId = EmployeeId;
    self.FirstName  = FirstName;
    self.Group      = Group;
    self.GroupId    = GroupId;
    self.PersonId   = Id;
    self.LastName   = LastName;
    self.Name       = Name;
    
    return self;
}

+ (NSArray*) getPersonsFromJSONData:(NSData*)data
{
    NSError* jsonerr = nil;
    NSArray* persons = [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers
                                      error:&jsonerr];
    if (jsonerr) {
        NSLog(@"Person JSON Serialization failed");
        return nil;
    }
    
    return persons;
}

+ (NSArray*) getPersonsFromJSOString:(NSString*)string
{
    NSData* data = [NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding] length:string.length];
    if (data) {
        return [self getPersonsFromJSONData:data];
    }
    return nil;
}

+ (Person*) personWithJSONObject:(NSDictionary*)dict
{
    return [[[Person alloc] init] loadJSONObject:dict];
}

+ (NSString*) dummyPersonsString
{
    return [[self dummyPersons] description];
}

+ (NSArray*) dummyPersons
{
    Person* p1 = [Person new];
    Person* p2 = [Person new];
    Person* p3 = [Person new];

    p1.EmployeeId = @"000001";
    p1.FirstName  = @"Spider";
    p1.Group      = [AppDelegate getInstance].groupName;
    p1.GroupId    = [NSNumber numberWithInt:1];
    p1.PersonId   = [NSNumber numberWithInt:1];
    p1.LastName   = @"Man";
    p1.Name       = @"Spider Man";
    
    p2.EmployeeId = @"000002";
    p2.FirstName  = @"Iron";
    p2.Group      = [AppDelegate getInstance].groupName;
    p2.GroupId    = [NSNumber numberWithInt:1];
    p2.PersonId   = [NSNumber numberWithInt:2];
    p2.LastName   = @"Man";
    p2.Name       = @"Iron Man";
    
    p3.EmployeeId = @"000003";
    p3.FirstName  = @"Ant";
    p3.Group      = [AppDelegate getInstance].groupName;
    p3.GroupId    = [NSNumber numberWithInt:1];
    p3.PersonId   = [NSNumber numberWithInt:3];
    p3.LastName   = @"Man";
    p3.Name       = @"Ant Man";
    
    return [NSArray arrayWithObjects:[p1 jsonObject], [p2 jsonObject], [p3 jsonObject], nil];
}

- (NSDictionary*) jsonObject
{
    return @{@"EmployeeId":self.EmployeeId,
             @"FirstName":self.FirstName,
             @"Group":self.Group,
             @"GroupId":self.GroupId,
             @"Id":self.PersonId,
             @"LastName":self.LastName,
             @"Name":self.Name};
}

@end
