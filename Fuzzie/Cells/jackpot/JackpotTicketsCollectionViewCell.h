//
//  JackpotTicketsCollectionViewCell.h
//  Fuzzie
//
//  Created by mac on 9/25/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JackpotTicketsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbTicket;
@property (weak, nonatomic) IBOutlet UILabel *lbCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ticketHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ticketWidth;

- (void)setCell:(NSString*)ticket count:(NSUInteger)count matched:(BOOL)matched;
@end
