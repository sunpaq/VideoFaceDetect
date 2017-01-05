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
    self.personIdLabel.text = [person.Id stringValue];
    self.personNameLabel.text = person.Name;
    self.personNumberLabel.text = [person.EmployeeId stringValue];
}

@end
