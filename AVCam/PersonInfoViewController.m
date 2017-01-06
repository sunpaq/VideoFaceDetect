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

@implementation PersonInfoViewController

- (void) refreshUI
{
    if (_person) {
        self.personIdText.text = [_person.Id stringValue];
        self.groupIdText.text  = [_person.GroupId stringValue];
        self.groupNameText.text  = _person.Group;
        self.employeeIdText.text = _person.EmployeeId;
        self.nameText.text       = _person.Name;
        self.lastNameText.text   = _person.LastName;
        self.firstNameText.text  = _person.FirstName;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
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

@end
