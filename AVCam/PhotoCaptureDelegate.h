#import <AVFoundation/AVFoundation.h>

@interface PhotoCaptureDelegate : NSObject<AVCapturePhotoCaptureDelegate>

- (instancetype)initWithRequestedPhotoSettings:(AVCapturePhotoSettings *)requestedPhotoSettings willCapturePhotoAnimation:(void (^)())willCapturePhotoAnimation capturingLivePhoto:(void (^)( BOOL capturing ))capturingLivePhoto completed:(void (^)( PhotoCaptureDelegate *photoCaptureDelegate ))completed;

@property (nonatomic, readonly) AVCapturePhotoSettings *requestedPhotoSettings;

@end
