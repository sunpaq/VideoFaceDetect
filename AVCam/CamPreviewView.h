#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface CamPreviewView : UIView
@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) AVCaptureSession *session;
@end
