#ifndef MainViewContorller_h
#define MainViewContorller_h

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addFaceButton;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UITextField *personNameField;
@property (weak, nonatomic) IBOutlet UITextField *personTagField;
@property (weak, nonatomic) IBOutlet UITextView *uploadResultText;
@property (weak, nonatomic) IBOutlet UITextField *deletePersonId;
@property (weak, nonatomic) IBOutlet UITextView *existingPersons;

- (IBAction)onAddFaceButtonClicked:(id)sender;
- (IBAction)onUploadFaceButtonClicked:(id)sender;
- (IBAction)onDeleteFaceButtonClicked:(id)sender;

@end

#endif /* MainViewContorller_h */
