#import <AVFoundation/AVFoundation.h>
#import "AVCamPreviewView.h"

@interface AVCamPreviewView()
//@property (nonatomic, strong) CALayer* hudLayer;
@end

@implementation AVCamPreviewView

+ (Class)layerClass
{
	return [AVCaptureVideoPreviewLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
//        self.hudLayer = [CALayer layer];
//        
//        self.hudLayer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5].CGColor;
//        self.hudLayer.frame = CGRectMake(0, 0, 200, 200);
//        
//        [self.layer addSublayer:self.hudLayer];
        
        return self;
    }
    return nil;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer
{
	return (AVCaptureVideoPreviewLayer *)self.layer;
    //return self.previewLayer;
}

- (AVCaptureSession *)session
{
	return self.videoPreviewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
	self.videoPreviewLayer.session = session;
}

@end
