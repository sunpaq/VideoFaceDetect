#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface AVCamPreviewView : UIView
@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) AVCaptureSession *session;
@end
