//
//  CLLocation+DistanceAway.m
//  Present
//
//  Created by Nur Iman Izam Othman on 13/2/14.
//  Copyright (c) 2014 Present Private Limited. All rights reserved.
//

#import "CLLocation+DistanceAway.h"

@implementation CLLocation (DistanceAway)

- (NSString *)distanceAwayWithLocation:(CLLocation *)location {
    
    CLLocationDistance distance = [self distanceFromLocation:location];
    
    if (distance < 1000.0f) {
        return [NSString stringWithFormat:@"%.0fm",distance];
    } else {
        return [NSString stringWithFormat:@"%.0fkm",distance/1000.0f];
    }
}

@end
