#import <Foundation/Foundation.h>
#import "PersonListViewController.h"
#import "AppDelegate.h"

#define END_POINT @"http://eccwcl32138.global.schindler.com/FaceManagerService/api/Persons"
#define GET_METHOD @"GET"

#define NETWORK_ERR @"网络错误"
#define GOT_IT @"知道了"

@interface PersonListViewController ()
@property (nonatomic) NSArray* persons;
@end

@implementation PersonListViewController

- (void)viewDidLoad
{
    //[self.indicator startAnimating];
    NSMutableURLRequest* req = [[NSURLRequest requestWithURL:[NSURL URLWithString:END_POINT]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:30] mutableCopy];
    req.HTTPMethod = GET_METHOD;
    //req.HTTPBody = @"";
    
    NSURLConnection* connect = [NSURLConnection connectionWithRequest:req delegate:self];
    [connect start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@(%ld)", NETWORK_ERR, (long)error.code]
                                                    message:error.localizedDescription
                                                   delegate:self
                                          cancelButtonTitle:GOT_IT
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    AppDelegate* app = [AppDelegate getInstance];
    
    NSError* jsonerr;
    self.persons = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingMutableContainers
                                                     error:&jsonerr];
    for (NSDictionary* person in self.persons) {
        NSNumber* EmployeeId = [person objectForKey:@"EmployeeId"];
        NSString* FirstName  = [person objectForKey:@"FirstName"];
        NSString* Group      = [person objectForKey:@"Group"];
        NSNumber* GroupId    = [person objectForKey:@"GroupId"];
        NSNumber* Id         = [person objectForKey:@"Id"];
        NSString* LastName   = [person objectForKey:@"LastName"];
        NSString* Name       = [person objectForKey:@"Name"];
        
        [app addPersonName:Name WithId:[Id stringValue] WithTag:LastName];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PersonCell"];
    }
    
    NSDictionary* person = [self.persons objectAtIndex:indexPath.row];
    if (person) {
        cell.textLabel.text = [person objectForKey:@"Name"];
        cell.detailTextLabel.text = [person objectForKey:@"EmployeeId"];
    }
    
    return cell;
}

- (IBAction)onDoneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
