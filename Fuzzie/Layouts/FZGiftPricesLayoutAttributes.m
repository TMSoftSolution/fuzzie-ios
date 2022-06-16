//
//  FZGiftPricesLayoutAttributes.m
//  Fuzzie
//
//  Created by Vincent Bach on 27/10/2014.
//  Copyright (c) 2014 fuzzie. All rights reserved.
//

#import "FZGiftPricesLayoutAttributes.h"

@implementation FZGiftPricesLayoutAttributes

- (id)copyWithZone:(NSZone *)zone
{
    FZGiftPricesLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.isActiveCell = _isActiveCell;
    attributes.zoom = _zoom;
    
    return attributes;
}

@end
