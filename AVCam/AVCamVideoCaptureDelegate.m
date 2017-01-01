//
//  AVCamVideoCaptureDelegate.m
//  AVCam Objective-C
//
//  Created by Sun YuLi on 2016/12/31.
//
//

@import Foundation;
@import CoreImage;
@import CoreGraphics;

#import "AVCamVideoCaptureDelegate.h"


@interface AVCamVideoCaptureDelegate ()
{
    CGRect _frame;
    CGRect _scaleFrame;
}
@property (nonatomic, strong) CIContext* cicontext;
@property (nonatomic, strong) CIDetector* faceDetector;
@end

@implementation AVCamVideoCaptureDelegate : NSObject

@synthesize camviewController;

//CIDetectorImageOrientation
- (instancetype) initWithCameraViewController:(AVCamCameraViewController*)cvc
{
    if ([super init]) {
        self.cicontext = [CIContext context];
        self.camviewController = cvc;
        self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                               context:_cicontext
                                               options:nil];
        _frame = CGRectNull;
        _scaleFrame = CGRectNull;
        return self;
    }
    return nil;
}

-(UIImage*) rotate:(UIImage*) src andOrientation:(UIImageOrientation)orientation
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context=(UIGraphicsGetCurrentContext());
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90/180*M_PI) ;
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90/180*M_PI);
    } else if (orientation == UIImageOrientationDown) {
        //CGContextRotateCTM (context, 90/180*M_PI);
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 90/180*M_PI);
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef cvbuff = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (sampleBuffer == nil || cvbuff == nil) {
        NSLog(@"error: sampleBuffer or cvbuff is nil");
    }
    
    CIImage* cimage = [CIImage imageWithCVImageBuffer:cvbuff];
    if (cimage == nil) {
        NSLog(@"error: cimage is nil");
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSArray* features = [self.faceDetector featuresInImage:cimage];
    
    float faceRotation;
    for (CIFaceFeature* f in features) {
        _frame = f.bounds;
        
//        if (f.hasFaceAngle) {
//            faceRotation = f.faceAngle;
//            NSLog(@"face rotation:%f", faceRotation);
//        }
//        if(f.hasSmile) {
//            [dict setValue:@"true" forKey:@"hasSmile"];
//        }
//        if (f.hasTrackingID) {
//            [dict setValue:[NSNumber numberWithInt:f.trackingID] forKey:@"trackingID"];
//        }
//        if (f.hasTrackingFrameCount) {
//            [dict setValue:[NSNumber numberWithInt:f.trackingFrameCount] forKey:@"trackingFrameCount"];
//        }
//        if (f.hasLeftEyePosition) {
//            [dict setValue:[NSValue valueWithCGPoint:f.leftEyePosition] forKey:@"leftEyePosition"];
//        }
//        if (f.hasRightEyePosition) {
//            [dict setValue:[NSValue valueWithCGPoint:f.rightEyePosition] forKey:@"rightEyePosition"];
//        }
//        if (f.hasMouthPosition) {
//            [dict setValue:[NSValue valueWithCGPoint:f.mouthPosition] forKey:@"mouthPosition"];
//        }
//        if (f.hasFaceAngle) {
//            [dict setValue:[NSNumber numberWithFloat:f.faceAngle] forKey:@"faceAngle"];
//        }
        
    }
    
    UIImage* uimage = [UIImage imageWithCIImage:cimage];
    if (uimage == nil) {
        NSLog(@"error: uimage is nil");
    }
    
    if (cimage) {
        CGImageRef facecrop = [self.cicontext createCGImage:cimage fromRect:_frame];
        UIImage* face = [UIImage imageWithCGImage:facecrop];
        self.camviewController.faceImage = face; //[self rotate:face andOrientation:face.imageOrientation];
    }
    
    CGFloat x = _frame.origin.x / uimage.size.width;
    CGFloat y = _frame.origin.y / uimage.size.height;
    CGFloat w = _frame.size.width / uimage.size.width;
    CGFloat h = _frame.size.height / uimage.size.height;
    
    _scaleFrame = CGRectMake(1.0-x-w, 1.0-y-h, w, h);
    
    [self.camviewController updateFaceLabelFrameInUIThread:_scaleFrame WithData:dict];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    // Enable the Record button to let the user stop the recording.
    dispatch_async( dispatch_get_main_queue(), ^{
        camviewController.recordButton.enabled = YES;
        [camviewController.recordButton setTitle:NSLocalizedString( @"Stop", @"Recording button stop title" ) forState:UIControlStateNormal];
    });
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    /*
     Note that currentBackgroundRecordingID is used to end the background task
     associated with this recording. This allows a new recording to be started,
     associated with a new UIBackgroundTaskIdentifier, once the movie file output's
     `recording` property is back to NO — which happens sometime after this method
     returns.
     
     Note: Since we use a unique file path for each recording, a new recording will
     not overwrite a recording currently being saved.
     */
    UIBackgroundTaskIdentifier currentBackgroundRecordingID = camviewController.backgroundRecordingID;
    camviewController.backgroundRecordingID = UIBackgroundTaskInvalid;
    
    dispatch_block_t cleanup = ^{
        if ( [[NSFileManager defaultManager] fileExistsAtPath:outputFileURL.path] ) {
            [[NSFileManager defaultManager] removeItemAtPath:outputFileURL.path error:NULL];
        }
        
        if ( currentBackgroundRecordingID != UIBackgroundTaskInvalid ) {
            [[UIApplication sharedApplication] endBackgroundTask:currentBackgroundRecordingID];
        }
    };
    
    BOOL success = YES;
    
    if ( error ) {
        NSLog( @"Movie file finishing error: %@", error );
        success = [error.userInfo[AVErrorRecordingSuccessfullyFinishedKey] boolValue];
    }
    if ( success ) {
        // Check authorization status.
        [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
            if ( status == PHAuthorizationStatusAuthorized ) {
                // Save the movie file to the photo library and cleanup.
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                    options.shouldMoveFile = YES;
                    PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
                    [creationRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:outputFileURL options:options];
                } completionHandler:^( BOOL success, NSError *error ) {
                    if ( ! success ) {
                        NSLog( @"Could not save movie to photo library: %@", error );
                    }
                    cleanup();
                }];
            }
            else {
                cleanup();
            }
        }];
    }
    else {
        cleanup();
    }
    
    // Enable the Camera and Record buttons to let the user switch camera and start another recording.
    dispatch_async( dispatch_get_main_queue(), ^{
        // Only enable the ability to change camera if the device has more than one camera.
        camviewController.cameraButton.enabled = ( camviewController.videoDeviceDiscoverySession.uniqueDevicePositionsCount > 1 );
        camviewController.recordButton.enabled = YES;
        camviewController.captureModeControl.enabled = YES;
        [camviewController.recordButton setTitle:NSLocalizedString( @"Record", @"Recording button record title" ) forState:UIControlStateNormal];
    });
}


@end
