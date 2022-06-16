//
//  ClubEarnTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubEarnTableViewCellDelegate <NSObject>

- (void)settingButtonPressed;

@end

@interface ClubEarnTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubEarnTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbSaving;

- (IBAction)settingButtonPressed:(id)sender;

@end
