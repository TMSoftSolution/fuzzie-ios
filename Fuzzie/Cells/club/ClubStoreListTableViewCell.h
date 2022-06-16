//
//  ClubStoreListTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubStoreListTableViewCellDelegate <NSObject>

- (void)clubStoreListCellTapped:(NSDictionary*)dict;

@end

@interface ClubStoreListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivStore;
@property (weak, nonatomic) IBOutlet UILabel *lbBrandName;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreName;
@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;

@property (weak, nonatomic) id<ClubStoreListTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSDictionary *dict;

- (void)setCell:(NSDictionary*)dict;

@end
