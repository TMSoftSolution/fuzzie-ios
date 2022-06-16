//
//  PricesCardTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/14/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PricesCardTableViewCellDelegate <NSObject>
- (void)giftCardSelected:(NSDictionary *)giftCard WithIndexCard:(NSInteger)indexCard;
@end



@interface PricesCardTableViewCell : UITableViewCell
- (void)setPriceCard:(NSArray *)priceCardArray;
@property (weak, nonatomic) id<PricesCardTableViewCellDelegate> delegate;
@property (assign, nonatomic) NSInteger activeIndex;
@property (assign, nonatomic) BOOL alreadySelected;
@end
