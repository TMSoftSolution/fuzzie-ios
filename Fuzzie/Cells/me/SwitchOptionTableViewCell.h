//
//  SwitchOptionTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 3/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchOptionTableViewCellDelegate <NSObject>
- (void)switchButton:(UISwitch*)switchButton valueChangedWith:(NSString *)idSwitch state:(BOOL)state;
@end

@interface SwitchOptionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) id<SwitchOptionTableViewCellDelegate> delegate;
- (void)setId:(NSString *)idSwitch;
@end
