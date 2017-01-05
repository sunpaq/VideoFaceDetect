#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>
#import "VideoCaptureDelegate.h"
#import "UIImage+GrayScale.h"
#import "Utility.h"

@interface VideoCaptureDelegate ()
{
    CGRect _frame;
    CGRect _scaleFrame;
}
@property (nonatomic, strong) CIContext* cicontext;
@property (nonatomic, strong) CIDetector* faceDetector;
@end

@implementation VideoCaptureDelegate : NSObject

@synthesize camviewController;

//CIDetectorImageOrientation
- (instancetype) initWithCameraViewController:(CameraViewController*)cvc
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
        CGRect rect4to3 = [Utility resizeRect:_frame ByHWRatio:(CGFloat)4/3];
        CGImageRef facecrop = [self.cicontext createCGImage:cimage
                                                   fromRect:rect4to3];
        UIImage* face = [UIImage imageWithCGImage:facecrop];
        self.camviewController.faceImage = face;
    }
    
    CGRect scaleRect = [Utility scaleRectOfBigSize:uimage.size BySmallRect:_frame];
    _scaleFrame = [Utility mirrorRect:scaleRect];
    
    [self.camviewController updateFaceLabelFrameInUIThread:_scaleFrame WithData:dict];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    // Enable the Record button to let the user stop the recording.
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
}


@end
