//
//  AboutViewController.h
//  AVCam Objective-C
//
//  Created by YuliSun on 05/01/2017.
//
//

#ifndef AboutViewController_h
#define AboutViewController_h

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photo;

-(IBAction) onSwipeDown:(id)sender;

@end

#endif /* AboutViewController_h */
