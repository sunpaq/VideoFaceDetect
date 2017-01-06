#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@interface DetectedFace : NSObject

@property (atomic, strong) UIImage* colorFace;
@property (atomic, strong) UIImage* grayFace;
@property (atomic) CGRect scaleFrame;

- (DetectedFace*) initWithColorImage:(UIImage*)image ScaleFrame:(CGRect)frame;
- (DetectedFace*) initWithOriginCIImage:(CIImage*)cimage FaceFrame:(CGRect)frame;

@end

