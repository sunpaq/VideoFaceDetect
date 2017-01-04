//
//  ResultViewController.m
//  AVCam Objective-C
//
//  Created by YuliSun on 04/01/2017.
//
//

#import <Foundation/Foundation.h>
#import "ResultViewController.h"
#import "AVCamCameraViewController.h"

@implementation ResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.resultImage) {
        self.resultImageView.image = self.resultImage;
    }
    if (self.resultText1.length > 0) {
        self.resultLabel1.text = self.resultText1;
    }
    if (self.resultText2.length > 0) {
        self.resultLabel2.text = self.resultText2;
    }
    if (self.resultText3.length > 0) {
        self.resultLabel3.text = self.resultText3;
    }
}

- (IBAction)onCloseButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.onCloseDelegate) {
            [self.onCloseDelegate resultViewClosed];
        }
    }];
}

- (IBAction)onSwipeDown:(id)sender
{
    [self onCloseButtonClicked:sender];
}

- (IBAction)onSwipeUp:(id)sender
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self onCloseButtonClicked:sender];
}

@end
