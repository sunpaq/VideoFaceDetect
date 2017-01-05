#import <Foundation/Foundation.h>
#import "Person.h"

@protocol ItemSelectedDelegate <NSObject>

- (void) onItemSelected:(Person*)person AtRow:(NSInteger)row;

@end

