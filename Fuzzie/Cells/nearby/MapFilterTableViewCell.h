//
//  MapFilterTableViewCell.h
//  Fuzzie
//
//  Created by mac on 7/9/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapFilterTableViewCellDelegate <NSObject>

-(void)cellTapped:(UITableViewCell*)cell with:(NSDictionary*)dictionary;

@end

@interface MapFilterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImage;

@property (strong, nonatomic) NSDictionary *dictionary;
@property (weak, nonatomic) id<MapFilterTableViewCellDelegate> delegate;

@property (assign, nonatomic) BOOL isSelected;
- (void)setCell:(NSDictionary*) dictionary;

@end
