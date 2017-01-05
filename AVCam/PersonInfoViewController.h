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

@interface PersonInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *addFaceButton;
@property (weak, nonatomic) IBOutlet UIImageView *faceView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end


#endif /* PersonInfoViewController_h */
