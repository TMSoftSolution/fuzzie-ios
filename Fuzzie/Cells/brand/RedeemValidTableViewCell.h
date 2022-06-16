//
//  RedeemValidTableViewCell.h
//  Fuzzie
//
//  Created by joma on 4/12/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemValidTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbValid;

- (void)setCell:(NSString*)validDate;

@end
