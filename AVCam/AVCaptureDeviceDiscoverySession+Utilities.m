//
//  AVCaptureDeviceDiscoverySession+Utilities.m
//  AVCam Objective-C
//
//  Created by YuliSun on 06/01/2017.
//
//

#import <Foundation/Foundation.h>
#import "AVCaptureDeviceDiscoverySession+Utilities.h"

@implementation AVCaptureDeviceDiscoverySession (Utilities)

- (NSInteger)uniqueDevicePositionsCount
{
    NSMutableArray<NSNumber *> *uniqueDevicePositions = [NSMutableArray array];
    
    for ( AVCaptureDevice *device in self.devices ) {
        if ( ! [uniqueDevicePositions containsObject:@(device.position)] ) {
            [uniqueDevicePositions addObject:@(device.position)];
        }
    }
    
    return uniqueDevicePositions.count;
}

@end
