#import <Foundation/Foundation.h>
#import "PersonListViewController.h"
#import "AVCamAppDelegate.h"

#define END_POINT @"http://eccwcl32138.global.schindler.com/FaceManagerService/api/Persons"
#define GET_METHOD @"GET"

#define NETWORK_ERR @"网络错误"
#define GOT_IT @"知道了"

@implementation PersonListViewController

- (void)viewDidLoad
{
    //[self.indicator startAnimating];
    AVCamAppDelegate* app = [AVCamAppDelegate getInstance];
    
    NSURL* url = [NSURL URLWithString:END_POINT];
    
    NSMutableURLRequest* req = [[NSURLRequest requestWithURL:url] mutableCopy];
    req.HTTPMethod = GET_METHOD;
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {
                               
                               NSString *title, *msg;
                               if (connectionError) {
                                   title = NETWORK_ERR;
                                   msg = [connectionError description];
                                   
                               }
                               else {
                                   //msg = [Utility stringFromData:data];
                                   
                                   NSError* jsonerr;
                                   NSArray* persons = [NSJSONSerialization JSONObjectWithData:data
                                                                                      options:NSJSONReadingMutableContainers
                                                                                        error:&jsonerr];
                                   for (NSDictionary* person in persons) {
                                       NSNumber* EmployeeId = [person objectForKey:@"EmployeeId"];
                                       NSString* FirstName  = [person objectForKey:@"FirstName"];
                                       NSString* Group      = [person objectForKey:@"Group"];
                                       NSNumber* GroupId    = [person objectForKey:@"GroupId"];
                                       NSNumber* Id         = [person objectForKey:@"Id"];
                                       NSString* LastName   = [person objectForKey:@"LastName"];
                                       NSString* Name       = [person objectForKey:@"Name"];
                                       
                                       msg = [NSString stringWithFormat:@"%d %@ %@ %d %d %@ %@",
                                              [EmployeeId intValue],
                                              FirstName,
                                              Group,
                                              [GroupId intValue],
                                              [Id intValue],
                                              LastName,
                                              Name];
                                       
                                       
                                       [app addPersonName:Name WithId:[Id stringValue] WithTag:LastName];
                                   }
                                   
                                   UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                                   message:msg
                                                                                  delegate:self
                                                                         cancelButtonTitle:GOT_IT
                                                                         otherButtonTitles:nil];
                                   [alert show];
                                   
                               }
                           }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    
    AVCamAppDelegate* app = [AVCamAppDelegate getInstance];
    //cell.textLabel = [app getPersonNameFromId:<#(NSString *)#>]
    
    return cell;
}


@end
