
#import "Person.h"

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
    self.Id         = Id;
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

+ (Person*) personWithJSONObject:(NSDictionary*)dict
{
    return [[[Person alloc] init] loadJSONObject:dict];
}

- (NSDictionary*) jsonObject
{
    return @{@"EmployeeId":self.EmployeeId,
             @"FirstName":self.FirstName,
             @"Group":self.Group,
             @"GroupId":self.GroupId,
             @"Id":self.Id,
             @"LastName":self.LastName,
             @"Name":self.Name};
}

@end
