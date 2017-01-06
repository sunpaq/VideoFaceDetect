//
//  PersonInfoViewController.m
//  AVCam Objective-C
//
//  Created by YuliSun on 04/01/2017.
//
//

#import <Foundation/Foundation.h>
#import "PersonInfoViewController.h"
#import "CameraViewController.h"
#import "Utility.h"
#import "Person.h"
#import "AppDelegate.h"

@implementation PersonInfoViewController

- (void) refreshUI
{
    if (_person) {
        self.personIdText.text = [_person.PersonId stringValue];
        self.groupIdText.text  = [_person.GroupId stringValue];
        self.groupNameText.text  = _person.Group;
        self.employeeIdText.text = _person.EmployeeId;
        self.nameText.text       = _person.Name;
        self.lastNameText.text   = _person.LastName;
        self.firstNameText.text  = _person.FirstName;
        
        self.personIdText.hidden = NO;
        self.groupIdText.hidden  = NO;
        self.groupNameText.hidden  = NO;
        self.employeeIdText.hidden = NO;
        self.nameText.hidden       = NO;
        self.lastNameText.hidden   = NO;
        self.firstNameText.hidden  = NO;
        
    } else {
        
        self.personIdText.hidden = YES;
        self.groupIdText.hidden  = YES;
        self.groupNameText.hidden  = YES;
        self.employeeIdText.hidden = YES;
        self.nameText.hidden       = YES;
        self.lastNameText.hidden   = YES;
        self.firstNameText.hidden  = YES;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self refreshUI];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"recordFace"]) {
        if (self.personIdText.text.length <= 0) {
            return NO;
        }
    }
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"recordFace"]) {
        CameraViewController* camvc = segue.destinationViewController;
        camvc.faceDetectMode = NO;
        camvc.personRef = self.person;
    }
}

- (void) onItemSelected:(Person*)person AtRow:(NSInteger)row
{
    self.person = person;
    [self refreshUI];
}

-(IBAction)onDeletePerson:(id)sender
{
    AppDelegate* app = [AppDelegate getInstance];
    if (self.person.PersonId) {
        [app.sdk delPerson:[self.person.PersonId stringValue] successBlock:^(id responseObject) {
            //
            
        } failureBlock:^(NSError *error) {
            //
            
        }];
    }

}

@end
