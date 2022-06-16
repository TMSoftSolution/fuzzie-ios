//
//  JackpotRefineTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/14/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotRefineTableViewCellDelegate <NSObject>

-(void)cellTapped:(UITableViewCell*)cell withDict:(NSDictionary*)dictionary;


@end

@interface JackpotRefineTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dictionary;
@property (weak, nonatomic) id<JackpotRefineTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *ivSubCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *ivCheck;

@property (assign, nonatomic) BOOL isSelected;
- (void)setCell:(NSDictionary*) dictionary;

@end
