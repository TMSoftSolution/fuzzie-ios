//
//  ClubSortTableViewCell.h
//  Fuzzie
//
//  Created by joma on 8/31/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubSortTableViewCellDelegate <NSObject>

- (void)sortSelected:(BOOL)sortDistance;

@end

@interface ClubSortTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubSortTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *vDistance;
@property (weak, nonatomic) IBOutlet UIView *vRecent;
@property (weak, nonatomic) IBOutlet UIImageView *ivDistance;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;
@property (weak, nonatomic) IBOutlet UIImageView *ivRecent;
@property (weak, nonatomic) IBOutlet UILabel *lbRecent;

- (IBAction)distancePressed:(id)sender;
- (IBAction)recentPressed:(id)sender;

@property (assign, nonatomic) BOOL sortDistance;

- (void)setCell:(BOOL)sortDistance;

@end
