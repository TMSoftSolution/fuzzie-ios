//
//  ClubSubscibeTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/16/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubSubscibeTableViewCellDelegate <NSObject>

- (void)subscribeButtonPressed;

@end

@interface ClubSubscibeTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubSubscibeTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbJoin;


@end
