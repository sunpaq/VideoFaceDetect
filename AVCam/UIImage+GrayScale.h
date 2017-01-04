#ifndef UIImage_GrayScale_h
#define UIImage_GrayScale_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (GrayScale)

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

- (UIImage*) convertToGrayscale;
- (UIImage*) rotate:(UIImage*)src andOrientation:(UIImageOrientation)orientation;

@end

#endif /* UIImage_GrayScale_h */
