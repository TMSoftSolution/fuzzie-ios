//
//  DropDownMenuTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/20/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownMenuTableViewCellDelegate <NSObject>

- (void) menuItemSelected:(int)position;

@end

@interface DropDownMenuTableViewCell : UITableViewCell

@property (assign, nonatomic) int position;
@property (weak, nonatomic) id<DropDownMenuTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbItem;

- (void)setCell:(NSString*)date andPosition:(int)position;

@end
