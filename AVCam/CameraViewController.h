#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "CamPreviewView.h"
#import "PhotoCaptureDelegate.h"
#import "Person.h"
#import "DetectedFace.h"

typedef NS_ENUM( NSInteger, AVCamSetupResult ) {
    AVCamSetupResultSuccess,
    AVCamSetupResultCameraNotAuthorized,
    AVCamSetupResultSessionConfigurationFailed
};

@interface CameraViewController : UIViewController

//YES: facedetect NO: addface
@property (atomic) BOOL faceDetectMode;
@property (atomic, weak) Person* personRef;

// Session management.
@property (nonatomic, weak) IBOutlet CamPreviewView *previewView;

@property (nonatomic) AVCamSetupResult setupResult;
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic, getter=isSessionRunning) BOOL sessionRunning;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;

// Device configuration.
@property (nonatomic) AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession;

// Capturing photos.
@property (nonatomic) AVCapturePhotoOutput *photoOutput;

@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;

// Face detect
@property (weak, nonatomic) IBOutlet UIImageView *facePreview;
//@property (nonatomic, strong) UILabel *faceLabel;
@property (nonatomic, strong) UIImage *faceImage;
@property (weak, nonatomic) IBOutlet UISwitch *beautySwitch;

// Face management


- (void) onFaceDetected:(DetectedFace*)face;

- (void) resultViewClosed;
@end
