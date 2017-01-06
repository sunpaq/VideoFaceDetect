#import <Foundation/Foundation.h>
#import "Person.h"

@protocol PhotoTakenDelegate <NSObject>

- (void) onPhotoTaken:(UIImage*)photo;
- (void) onResultViewClosedWithInfo:(NSString*)info;

@end
