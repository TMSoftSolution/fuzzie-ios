//
//  BrandListCategoryFilterTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/2/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrandListCategoryFilterTableViewCellDelegate <NSObject>

-(void)cellTapped:(UITableViewCell*)cell withDict:(NSDictionary*)dictionary;


@end

@interface BrandListCategoryFilterTableViewCell : UITableViewCell

@property (weak, nonatomic) id<BrandListCategoryFilterTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSDictionary *dictionary;
@property (assign, nonatomic) BOOL isSelected;

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *ivCheck;

- (void)setCell:(NSDictionary*) dictionary;

@end
