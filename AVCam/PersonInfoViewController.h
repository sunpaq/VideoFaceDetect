//
//  PersonInfoViewController.h
//  AVCam Objective-C
//
//  Created by YuliSun on 04/01/2017.
//
//

#ifndef PersonInfoViewController_h
#define PersonInfoViewController_h

#import <UIKit/UIKit.h>
#import "ItemSelectedDelegate.h"
#import "Person.h"

@interface PersonInfoViewController : UIViewController <ItemSelectedDelegate>

//UI
@property (weak, nonatomic) IBOutlet UIButton *addFaceButton;
@property (weak, nonatomic) IBOutlet UIImageView *faceView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UITextField *personIdText;
@property (weak, nonatomic) IBOutlet UITextField *groupIdText;
@property (weak, nonatomic) IBOutlet UITextField *groupNameText;
@property (weak, nonatomic) IBOutlet UITextField *employeeIdText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
@property (weak, nonatomic) IBOutlet UITextField *firstNameText;

//Data Model
@property (retain, nonatomic) Person* person;

@end


#endif /* PersonInfoViewController_h */
