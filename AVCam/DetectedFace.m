#import "DetectedFace.h"
#import "UIImage+GrayScale.h"
#import "Utility.h"

@implementation DetectedFace

- (DetectedFace*) initWithColorImage:(UIImage*)image ScaleFrame:(CGRect)frame
{
    if (self) {
        self.colorFace = image;
        self.grayFace  = [image convertToGrayscale];
        self.scaleFrame = frame;
        
        return self;
    }
    return nil;
}

- (DetectedFace*) initWithOriginCIImage:(CIImage*)cimage FaceFrame:(CGRect)frame
{
    if (cimage) {
        CGRect rect4to3 = [Utility resizeRect:frame ByHWRatio:(CGFloat)4/3];
        CGImageRef facecrop = [[CIContext context] createCGImage:cimage fromRect:rect4to3];
        UIImage* face = [UIImage imageWithCGImage:facecrop];

        CGSize originSize = [UIImage imageWithCIImage:cimage].size;
        CGRect scaleRect = [Utility scaleRectOfBigSize:originSize BySmallRect:rect4to3];
        
        return [self initWithColorImage:face ScaleFrame:[Utility mirrorRect:scaleRect]];
    }
    return nil;
}

@end
