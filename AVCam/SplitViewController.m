//
//  SplitViewController.m
//  AVCam Objective-C
//
//  Created by YuliSun on 05/01/2017.
//
//

#import <Foundation/Foundation.h>
#import "SplitViewController.h"
#import "PersonListViewController.h"
#import "PersonInfoViewController.h"

@implementation SplitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationController* masterNav = self.viewControllers.firstObject;
    UINavigationController* detailNav = self.viewControllers.lastObject;

    if (masterNav && detailNav) {
        PersonListViewController* master = masterNav.viewControllers.firstObject;
        PersonInfoViewController* detail = masterNav.viewControllers.firstObject;

        if (master && detail) {
            master.itemSelectDelegate = detail;
        }
    }
}

@end
