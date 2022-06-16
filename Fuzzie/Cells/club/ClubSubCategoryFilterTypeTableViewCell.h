//
//  ClubSubCategoryFilterTypeTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/26/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubSubCategoryFilterTypeTableViewCellDelegate <NSObject>

- (void)componentSelected:(NSDictionary*)component;

@end;

@interface ClubSubCategoryFilterTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubSubCategoryFilterTypeTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *component;

- (void)setCell:(NSDictionary*)component checked:(BOOL)checked;

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *ivChecked;

@end
