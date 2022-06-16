//
//  FZMapAnnotation.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 29/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "FZMapAnnotation.h"


@implementation FZMapAnnotation

- (id)initWithStore:(FZStore *)store andBrand:(FZBrand *)brand {
    self = [super init];
    if (self) {
        _store = store;
        _brand = brand;
        CGFloat latitude = [store.latitude floatValue];
        CGFloat longitude = [store.longitude floatValue];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    
    return self;
}

@end
