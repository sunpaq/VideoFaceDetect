#ifndef Utility_h
#define Utility_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Utility : NSObject

+ (CGRect) scaleRectOfBigSize:(CGSize)bigSize BySmallRect:(CGRect)smallRect;
+ (CGRect) mirrorRect:(CGRect)rect;
+ (CGRect) multiplyRect:(CGRect)rect ByScaleRect:(CGRect)scaleRect;
+ (NSString*) stringFromData:(NSData*)data;

@end

#endif /* Utility_h */
