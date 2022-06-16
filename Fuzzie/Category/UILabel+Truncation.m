//
//  UILabel+Truncation.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "UILabel+Truncation.h"

@implementation UILabel(Truncation)

- (BOOL)isTruncated {
    CGSize sizeOfText = [self.text boundingRectWithSize: CGSizeMake(self.intrinsicContentSize.width, CGFLOAT_MAX)
                                                 options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes: [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context: nil].size;
    
    if (self.intrinsicContentSize.height < ceilf(sizeOfText.height)) {
        return YES;
    }
    return NO;
}

- (float)getHeightText {
    CGSize sizeOfText = [self.text boundingRectWithSize: CGSizeMake(self.intrinsicContentSize.width, CGFLOAT_MAX)
                                                options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes: [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context: nil].size;
    
    return ceilf(sizeOfText.height);
}
@end
