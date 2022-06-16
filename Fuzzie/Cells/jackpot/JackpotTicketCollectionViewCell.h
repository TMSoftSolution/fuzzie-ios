//
//  JackpotTicketCollectionViewCell.h
//  Fuzzie
//
//  Created by mac on 9/13/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JackpotPinLabel.h"

@interface JackpotTicketCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet JackpotPinLabel *lbPin;
@property (weak, nonatomic) IBOutlet UILabel *lbX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbXHeightAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbXWidthAnchor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbPinLeftAnchor;

- (void)setCell:(NSArray*)array;
- (void)setCell:(NSString *)ticket count:(NSUInteger)count matched:(BOOL)matched;

@end
