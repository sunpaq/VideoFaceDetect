//
//  ResultViewController.h
//  AVCam Objective-C
//
//  Created by YuliSun on 04/01/2017.
//
//

#ifndef ResultViewController_h
#define ResultViewController_h

#import <UIKit/UIKit.h>
#import "PhotoTakenDelegate.h"

@interface ResultViewController : UIViewController

@property (weak, nonatomic) id<PhotoTakenDelegate> photoTakenDelegate;

@property (strong, nonatomic) UIImage*  resultImage;
@property (strong, nonatomic) NSString* resultText1;
@property (strong, nonatomic) NSString* resultText2;
@property (strong, nonatomic) NSString* resultText3;

@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel1;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel2;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel3;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)onCloseButtonClicked:(id)sender;
- (IBAction)onSwipeDown:(id)sender;
- (IBAction)onSwipeUp:(id)sender;
- (IBAction)onSwipeLeft:(id)sender;

@end

#endif /* ResultViewController_h */
