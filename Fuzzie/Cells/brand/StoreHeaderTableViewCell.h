//
//  StoreHeaderTableViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 24/3/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasteboardLabel.h"

@interface StoreHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet PasteboardLabel *storeAddressLabel;

@end
