//
//  BrandValidOptionCollectionViewCell.m
//  Fuzzie
//
//  Created by mac on 9/12/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "BrandValidOptionCollectionViewCell.h"

@implementation BrandValidOptionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.containerView withCornerRadius:15.0f withBorderColor:[UIColor colorWithHexString:@"#E5E5E5"] withBorderWidth:1.0f];
}

@end
