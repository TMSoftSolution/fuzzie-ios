//
//  FZMapAnnotation.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 29/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FZMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) FZStore *store;
@property (strong, nonatomic) FZBrand *brand;

- (id)initWithStore:(FZStore *)store andBrand:(FZBrand *)brand;

@end
