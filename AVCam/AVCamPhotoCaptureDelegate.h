#import <AVFoundation/AVFoundation.h>

@interface AVCamPhotoCaptureDelegate : NSObject<AVCapturePhotoCaptureDelegate>

- (instancetype)initWithRequestedPhotoSettings:(AVCapturePhotoSettings *)requestedPhotoSettings willCapturePhotoAnimation:(void (^)())willCapturePhotoAnimation capturingLivePhoto:(void (^)( BOOL capturing ))capturingLivePhoto completed:(void (^)( AVCamPhotoCaptureDelegate *photoCaptureDelegate ))completed;

@property (nonatomic, readonly) AVCapturePhotoSettings *requestedPhotoSettings;

@end
