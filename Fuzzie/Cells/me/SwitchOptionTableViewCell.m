//
//  SwitchOptionTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 3/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "SwitchOptionTableViewCell.h"


@interface SwitchOptionTableViewCell()
@property (strong, nonatomic) NSString *idSwitch;
@end


@implementation SwitchOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setId:(NSString *)idSwitch {
    self.idSwitch = idSwitch;
}
- (IBAction)switchChanged:(id)sender {

    if ([self.delegate respondsToSelector:@selector(switchButton:valueChangedWith:state:)]) {
        [self.delegate switchButton:self.switchButton valueChangedWith:self.idSwitch state:((UISwitch *)sender).isOn];
    }
}

@end
