//
//  FuzzieCreditsTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 3/8/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FuzzieCreditsTableViewCellDelegate <NSObject>
- (void)topUpPressed;
@end

@interface FuzzieCreditsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconFuzzie;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) id<FuzzieCreditsTableViewCellDelegate> delegate;

@end
