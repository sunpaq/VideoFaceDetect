#import <Foundation/Foundation.h>
#import "Utility.h"

@implementation Utility

+ (CGRect) scaleRectOfBigSize:(CGSize)bigSize BySmallRect:(CGRect)smallRect
{
    CGFloat x = smallRect.origin.x    / bigSize.width;
    CGFloat y = smallRect.origin.y    / bigSize.height;
    CGFloat w = smallRect.size.width  / bigSize.width;
    CGFloat h = smallRect.size.height / bigSize.height;
    
    return CGRectMake(x, y, w, h);
}

+ (CGRect) mirrorRect:(CGRect)rect
{
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    
    return CGRectMake(1.0-x-w, 1.0-y-h, w, h);
}

+ (CGRect) multiplyRect:(CGRect)rect ByScaleRect:(CGRect)scaleRect
{
    CGRect frame = CGRectMake(rect.origin.x + rect.size.width * scaleRect.origin.x,
                            rect.origin.y + rect.size.height * scaleRect.origin.y,
                            rect.size.width * scaleRect.size.width,
                            rect.size.height * (scaleRect.size.height + 0.05));
    return frame;
}

+ (NSString*) stringFromData:(NSData*)data
{
    return [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
}

+ (CGRect) resizeRect:(CGRect)rect ByHWRatio:(CGFloat)ratio
{
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.width * ratio);
}

@end
