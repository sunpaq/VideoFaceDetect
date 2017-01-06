#import <Foundation/Foundation.h>
#import "MainViewContorller.h"
#import "AppDelegate.h"

@interface MainViewController()
@property (nonatomic, strong) UIImagePickerController* imagePickerController;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate* app = [AppDelegate getInstance];
    self.addFaceButton.title = [NSString stringWithFormat:@"加脸入组（%@）", app.groupName];
    
    //self.existingPersons.text = [[app.personDatas allKeys] description];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    _imagePickerController = nil;
    
    _faceImageView.image = image;
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType fromButton:(UIBarButtonItem *)button
{
//    if (self.imageView.isAnimating)
//    {
//        [self.imageView stopAnimating];
//    }
//    
//    if (self.capturedImages.count > 0)
//    {
//        [self.capturedImages removeAllObjects];
//    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    imagePickerController.modalPresentationStyle = (sourceType == UIImagePickerControllerSourceTypeCamera) ?
        UIModalPresentationFullScreen : UIModalPresentationPopover;
    
    UIPopoverPresentationController *presentationController = imagePickerController.popoverPresentationController;
    presentationController.barButtonItem = button;  // display popover from the UIBarButtonItem as an anchor
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // The user wants to use the camera interface. Set up our custom overlay view for the camera.
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
//        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
//        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
//        imagePickerController.cameraOverlayView = self.overlayView;
//        self.overlayView = nil;
    }
    
    _imagePickerController = imagePickerController; // we need this for later
    
    [self presentViewController:self.imagePickerController animated:YES completion:^{
        //.. done presenting
    }];
}

- (IBAction)onAddFaceButtonClicked:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary fromButton:sender];
}

- (IBAction)onUploadFaceButtonClicked:(id)sender
{
    if (self.personNameField.text.length <=0) {
        self.uploadResultText.text = @"君の名は（你的名字）？";
        return;
    }

}

- (IBAction)onDeleteFaceButtonClicked:(id)sender
{
    if (self.deletePersonId.text.length <=0) {
        self.deletePersonId.text = @"请输入要删除的personId";
        return;
    }

}


@end
