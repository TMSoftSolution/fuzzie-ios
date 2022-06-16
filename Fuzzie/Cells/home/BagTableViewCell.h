//
//  BagTableViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 1/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BagTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cashbackView;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;

@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandImageLeftAnchor;

@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) BOOL isSelected;

-(void)setCell:(NSDictionary*)giftDic;

@end
