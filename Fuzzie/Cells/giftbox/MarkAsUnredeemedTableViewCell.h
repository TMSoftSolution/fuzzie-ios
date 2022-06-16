//
//  MarkAsUnredeemedTableViewCell.h
//  Fuzzie
//
//  Created by mac on 6/28/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MarkAsUnredeemedTableViewCellDelegate <NSObject>
- (void)unredeemedTapped;
@end

@interface MarkAsUnredeemedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topSeparator;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;

@property (weak, nonatomic) id<MarkAsUnredeemedTableViewCellDelegate> delegate;
@end
