#import <UIKit/UIKit.h>
#import "ItemSelectedDelegate.h"

@interface PersonListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) id<ItemSelectedDelegate> itemSelectDelegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)onDoneButtonClicked:(id)sender;

@end
