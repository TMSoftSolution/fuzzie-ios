//
//  PackageTableViewCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 7/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "PackageTableViewCell.h"


@interface PackageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *viewMoreButton;

- (IBAction)viewMoreButtonPressed:(id)sender;

@end

@implementation PackageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.viewMoreButton.layer.cornerRadius = 5.0f;
    self.viewMoreButton.backgroundColor = [UIColor colorWithHexString:HEX_COLOR_RED];
    self.viewMoreButton.layer.borderColor = [UIColor colorWithHexString:@"#C32D2E"].CGColor;
    self.viewMoreButton.layer.borderWidth = 2.0f;
    self.viewMoreButton.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)viewMoreButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(packageCellDidPressViewMoreForPackage:)]) {
        [self.delegate packageCellDidPressViewMoreForPackage:self.packageDict];
    }
}

@end
