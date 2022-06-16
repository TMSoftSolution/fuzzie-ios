//
//  PayTableViewCell.h
//  Fuzzie
//
//  Created by mac on 8/15/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell

@property (nonatomic, strong) FZBrand *brand;
@property (nonatomic, strong) NSDictionary *itemDict;

+(int) estimateHeigthWithBrand:(FZBrand*)brand andItem:(NSDictionary*)itemDict;
-(void) setCellWithBrand:(FZBrand*)brand andItem:(NSDictionary*)itemDict withLast:(BOOL)isLast;

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbCashback;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerLeftAnchor;

@end
