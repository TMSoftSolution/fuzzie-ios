//
//  StorePhoneTableViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 24/3/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasteboardLabel.h"

@protocol StorePhoneTableViewCellDelegate <NSObject>

- (void)phoneButtonPressed:(NSUInteger)index;

@end

@interface StorePhoneTableViewCell : UITableViewCell

@property (weak, nonatomic) id<StorePhoneTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet PasteboardLabel *phoneLabel;
@property (assign, nonatomic) NSUInteger index;

@end
