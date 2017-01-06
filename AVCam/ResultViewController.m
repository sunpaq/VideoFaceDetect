//
//  ResultViewController.m
//  AVCam Objective-C
//
//  Created by YuliSun on 04/01/2017.
//
//

#import <Foundation/Foundation.h>
#import "ResultViewController.h"
#import "CameraViewController.h"

@implementation ResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.resultText1.length > 0) {
        self.resultLabel1.text = self.resultText1;
    }
    if (self.resultText2.length > 0) {
        self.resultLabel2.text = self.resultText2;
    }
    if (self.resultText3.length > 0) {
        self.resultLabel3.text = self.resultText3;
    }
    if (self.resultImage) {
        self.resultImageView.image = self.resultImage;
    }
}

- (IBAction)onCloseButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.photoTakenDelegate) {
            [self.photoTakenDelegate onResultViewClosedWithInfo:@"CloseButton"];
        }
    }];
}

- (IBAction)onSwipeDown:(id)sender
{
    if (self.photoTakenDelegate && self.resultImage) {
        [self.photoTakenDelegate onPhotoTaken:self.resultImage];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.photoTakenDelegate) {
            [self.photoTakenDelegate onResultViewClosedWithInfo:@"SwipeDown"];
        }
    }];
}

- (IBAction)onSwipeUp:(id)sender
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.photoTakenDelegate) {
            [self.photoTakenDelegate onResultViewClosedWithInfo:@"SwipeUp"];
        }
    }];
}

- (IBAction)onSwipeLeft:(id)sender
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.photoTakenDelegate) {
            [self.photoTakenDelegate onResultViewClosedWithInfo:@"SwipeLeft"];
        }
    }];
}

@end
