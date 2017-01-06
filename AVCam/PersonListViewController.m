#import <Foundation/Foundation.h>
#import "PersonListViewController.h"
#import "AppDelegate.h"
#import "Person.h"

#define END_POINT @"http://eccwcl32138.global.schindler.com/FaceManagerService/api/Persons"
#define GET_METHOD @"GET"

#define NETWORK_ERR @"网络错误"
#define GOT_IT @"知道了"

@interface PersonListViewController ()
@end

@implementation PersonListViewController

- (void)viewDidLoad
{
    //[self.indicator startAnimating];
    AppDelegate* app = [AppDelegate getInstance];
    
    //[app fetchPersonList:self WithEndPoint:END_POINT];
    app.persons = [Person dummyPersons];

    
    /*
    [app.sdk getPersonIds:app.groupName successBlock:^(id responseObject) {
        
    } failureBlock:^(NSError *error) {
        //
    }];
     */
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString* str = [NSString stringWithFormat:@"%@(%ld)", NETWORK_ERR, (long)error.code];
    [[[UIAlertView alloc] initWithTitle:str
                                message:error.localizedDescription
                               delegate:self
                      cancelButtonTitle:GOT_IT
                      otherButtonTitles:nil] show];
    
    AppDelegate* app = [AppDelegate getInstance];
    app.persons = [Person dummyPersons];
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    AppDelegate* app = [AppDelegate getInstance];
    app.persons = [Person getPersonsFromJSONData:data];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate* app = [AppDelegate getInstance];
    if (app.persons) {
        return app.persons.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PersonCell"];
    }
    AppDelegate* app = [AppDelegate getInstance];
    NSDictionary* person = [app.persons objectAtIndex:indexPath.row];
    if (person) {
        cell.textLabel.text = [person objectForKey:@"Name"];
        cell.detailTextLabel.text = [person objectForKey:@"EmployeeId"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemSelectDelegate) {
        AppDelegate* app = [AppDelegate getInstance];
        if (indexPath.row < app.persons.count) {
            NSDictionary* dict = [app.persons objectAtIndex:indexPath.row];
            Person* p = [Person personWithJSONObject:dict];
            if (p) {
                [self.itemSelectDelegate onItemSelected:p AtRow:indexPath.row];
            }
        }
    }
}

- (IBAction)onDoneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
