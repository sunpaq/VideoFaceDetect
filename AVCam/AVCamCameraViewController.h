#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "AVCamPreviewView.h"
#import "AVCamPhotoCaptureDelegate.h"

@interface AVCaptureDeviceDiscoverySession (Utilities)

- (NSInteger)uniqueDevicePositionsCount;

@end

typedef NS_ENUM( NSInteger, AVCamSetupResult ) {
    AVCamSetupResultSuccess,
    AVCamSetupResultCameraNotAuthorized,
    AVCamSetupResultSessionConfigurationFailed
};

typedef NS_ENUM( NSInteger, AVCamCaptureMode ) {
    AVCamCaptureModePhoto = 0,
    AVCamCaptureModeMovie = 1
};

@interface AVCamCameraViewController : UIViewController

// Session management.
@property (nonatomic, weak) IBOutlet AVCamPreviewView *previewView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *captureModeControl;

@property (nonatomic) AVCamSetupResult setupResult;
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic, getter=isSessionRunning) BOOL sessionRunning;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;

// Device configuration.
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UILabel *cameraUnavailableLabel;
@property (nonatomic) AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession;

// Capturing photos.
@property (nonatomic, weak) IBOutlet UIButton *photoButton;
@property (nonatomic) AVCapturePhotoOutput *photoOutput;

// Recording movies.
@property (nonatomic, weak) IBOutlet UIButton *recordButton;
@property (nonatomic, weak) IBOutlet UIButton *resumeButton;

@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;

// Face detect
@property (weak, nonatomic) IBOutlet UIImageView *faceView;
//@property (nonatomic, strong) UILabel *faceLabel;
@property (nonatomic, strong) UIImage *faceImage;
@property (weak, nonatomic) IBOutlet UISwitch *beautySwitch;

// Face management


- (void) updateFaceLabelFrameInUIThread:(CGRect)frame WithData:(NSDictionary*)data;

@end
