//
//  PowerUpGiftTitleTableViewCell.h
//  Fuzzie
//
//  Created by Joma on 2/19/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerUpGiftTitleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbName;

- (void)setCell:(NSDictionary*)giftDict;

@end
