//
//  PersonInfoViewController.m
//  AVCam Objective-C
//
//  Created by YuliSun on 04/01/2017.
//
//

#import <Foundation/Foundation.h>
#import "PersonInfoViewController.h"
#import "Utility.h"
#import "Person.h"

@implementation PersonInfoViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void) onItemSelected:(Person*)person AtRow:(NSInteger)row
{
    self.personIdText.text = [person.Id stringValue];
    self.groupIdText.text  = [person.GroupId stringValue];
    self.groupNameText.text  = person.Group;
    self.employeeIdText.text = person.EmployeeId;
    self.nameText.text       = person.Name;
    self.lastNameText.text   = person.LastName;
    self.firstNameText.text  = person.FirstName;
    
}

@end
