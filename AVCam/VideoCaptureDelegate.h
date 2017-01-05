#ifndef AVCamVideoCaptureDelegate_h
#define AVCamVideoCaptureDelegate_h

#import <AVFoundation/AVFoundation.h>
#import "CameraViewController.h"

@interface VideoCaptureDelegate : NSObject<AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) CameraViewController* camviewController;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithCameraViewController:(CameraViewController*)cvc;

@end

#endif /* AVCamVideoCaptureDelegate_h */
