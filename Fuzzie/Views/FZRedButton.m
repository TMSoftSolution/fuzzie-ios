//
//  FZRedButton.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 9/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "FZRedButton.h"

@implementation FZRedButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = 5.0f;
        self.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
        self.layer.borderColor = [UIColor colorWithHexString:@"#C32D2E"].CGColor;
        self.layer.borderWidth = 2.0f;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

@end
