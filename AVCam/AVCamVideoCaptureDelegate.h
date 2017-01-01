//
//  AVCamVideoCaptureDelegate.h
//  AVCam Objective-C
//
//  Created by Sun YuLi on 2016/12/31.
//
//

#ifndef AVCamVideoCaptureDelegate_h
#define AVCamVideoCaptureDelegate_h

@import AVFoundation;
#import "AVCamCameraViewController.h"

@interface AVCamVideoCaptureDelegate : NSObject<AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) AVCamCameraViewController* camviewController;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithCameraViewController:(AVCamCameraViewController*)cvc;

@end

#endif /* AVCamVideoCaptureDelegate_h */
