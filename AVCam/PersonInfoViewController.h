//
//  PersonInfoViewController.h
//  AVCam Objective-C
//
//  Created by YuliSun on 04/01/2017.
//
//

#ifndef PersonInfoViewController_h
#define PersonInfoViewController_h

#import <UIKit/UIKit.h>
#import "ItemSelectedDelegate.h"

@interface PersonInfoViewController : UIViewController <ItemSelectedDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addFaceButton;
@property (weak, nonatomic) IBOutlet UIImageView *faceView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


@property (weak, nonatomic) IBOutlet UILabel *personIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNumberLabel;


@end


#endif /* PersonInfoViewController_h */
