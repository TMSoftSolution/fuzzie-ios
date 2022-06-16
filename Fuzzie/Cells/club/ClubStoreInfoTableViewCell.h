//
//  ClubStoreInfoTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubStoreInfoTableViewCellDelegate <NSObject>

- (void)directionButtonPressed:(FZStore*)store;
- (void)callButtonPressed:(FZStore*)store;

@end

@interface ClubStoreInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubStoreInfoTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnDirection;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreName;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbBusinessTime;

@property (strong, nonatomic) FZStore *store;

- (void)setCell:(FZStore*)store;

@end
