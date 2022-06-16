//
//  JackpotSectionTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotSectionTableViewCellDelegate <NSObject>

- (void)sortButtonPressed;
- (void)refineButtonPressed;

@end

@interface JackpotSectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbSort;
@property (weak, nonatomic) IBOutlet UILabel *lbRefine;
@property (weak, nonatomic) IBOutlet UILabel *lbCount;

@property (weak, nonatomic) id<JackpotSectionTableViewCellDelegate> delegate;

- (void)updateSortBy;
- (void)updateRefine;

@end
