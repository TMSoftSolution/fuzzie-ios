//
//  PackageBrandDetailTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PackageBrandDetailTableViewCell.h"
#import "TTTAttributedLabel.h"
#import "UILabel+Truncation.h"
#import "Masonry.h"
#import "FZBrand.h"



@interface PackageBrandDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextView *tvDescription;


@end

@implementation PackageBrandDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tvDescription.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:HEX_COLOR_RED]};
}

- (void)setPackageBrandDetailText:(NSString *)description {
  
    self.tvDescription.text = description;

}


@end
