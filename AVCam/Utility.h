//
//  Utility.h
//  AVCam Objective-C
//
//  Created by YuliSun on 04/01/2017.
//
//

#ifndef Utility_h
#define Utility_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Utility : NSObject

+ (CGRect) scaleRectOfBigSize:(CGSize)bigSize BySmallRect:(CGRect)smallRect;
+ (CGRect) mirrorRect:(CGRect)rect;
+ (CGRect) multiplyRect:(CGRect)rect ByScaleRect:(CGRect)scaleRect;

@end

#endif /* Utility_h */
