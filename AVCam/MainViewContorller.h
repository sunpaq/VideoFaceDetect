//
//  MainViewContorller.h
//  AVCam Objective-C
//
//  Created by YuliSun on 03/01/2017.
//
//

#ifndef MainViewContorller_h
#define MainViewContorller_h

@import UIKit;

@interface MainViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addFaceButton;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UITextField *personNameField;
@property (weak, nonatomic) IBOutlet UITextField *personTagField;
@property (weak, nonatomic) IBOutlet UITextView *uploadResultText;
@property (weak, nonatomic) IBOutlet UITextField *deletePersonId;

- (IBAction)onAddFaceButtonClicked:(id)sender;
- (IBAction)onUploadFaceButtonClicked:(id)sender;
- (IBAction)onDeleteFaceButtonClicked:(id)sender;

@end

#endif /* MainViewContorller_h */
