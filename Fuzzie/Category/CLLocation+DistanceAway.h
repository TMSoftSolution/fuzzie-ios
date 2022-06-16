//
//  CLLocation+DistanceAway.h
//  Present
//
//  Created by Nur Iman Izam Othman on 13/2/14.
//  Copyright (c) 2014 Present Private Limited. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (DistanceAway)

- (NSString *)distanceAwayWithLocation:(CLLocation *)location;

@end
