//
//  PersonListViewController.h
//  AVCam Objective-C
//
//  Created by YuliSun on 04/01/2017.
//
//

#ifndef PersonListViewController_h
#define PersonListViewController_h

#import <UIKit/UIKit.h>

@interface PersonListViewController : UITableViewController <UITableViewDataSource, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)onDoneButtonClicked:(id)sender;

@end

#endif /* PersonListViewController_h */
