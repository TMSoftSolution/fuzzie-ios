//
//  MainActionBrandTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainActionBrandTableViewCellDelegate <NSObject>
- (void)buyItTapped;
@optional
- (void)giftItTapped;
@end

@interface MainActionBrandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *giftButton;
@property (weak, nonatomic) IBOutlet UIButton *buyItButton;
@property (weak, nonatomic) id<MainActionBrandTableViewCellDelegate> delegate;
- (void)enabledButtonsWithAnimation:(BOOL)animation;
- (void)disabledButtonsWithAnimation:(BOOL)animation;

@end
