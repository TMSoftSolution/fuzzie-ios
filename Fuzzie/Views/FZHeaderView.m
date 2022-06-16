//
//  FZHeaderView.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 24/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "FZHeaderView.h"

@implementation FZHeaderView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
    }
    
    return self;
}

@end
