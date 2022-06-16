//
//  BrandListRefineTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/1/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrandListRefineTableViewCellDelegate <NSObject>

-(void)cellTapped:(UITableViewCell*)cell withDict:(NSDictionary*)dictionary;


@end

@interface BrandListRefineTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dictionary;
@property (weak, nonatomic) id<BrandListRefineTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *ivSubCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *ivCheck;

@property (assign, nonatomic) BOOL isSelected;
- (void)setCell:(NSDictionary*) dictionary;

@end
