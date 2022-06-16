//
//  BrandListSortTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrandListSortTableViewCellDelegate <NSObject>

- (void)cellTapped:(int)position;

@end

@interface BrandListSortTableViewCell : UITableViewCell

@property (weak, nonatomic) id<BrandListSortTableViewCellDelegate> delegate;
@property (assign, nonatomic) int position;
@property (assign, nonatomic) BOOL isSelected;

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *ivCheck;

- (void)setCellWith:(int)position withSelect:(BOOL)selected;

@end
