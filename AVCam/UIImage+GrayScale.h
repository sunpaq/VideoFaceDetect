//
//  UIImage+GrayScale.h
//  AVCam Objective-C
//
//  Created by YuliSun on 04/01/2017.
//
//

#ifndef UIImage_GrayScale_h
#define UIImage_GrayScale_h

@import Foundation;
@import UIKit;

@interface UIImage (GrayScale)

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

- (UIImage *)convertToGrayscale;

@end

#endif /* UIImage_GrayScale_h */
