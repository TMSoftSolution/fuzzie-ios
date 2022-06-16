//
//  PricesCardTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/14/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PricesCardTableViewCell.h"
#import "GiftCollectionViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "SDVersion.h"

@interface PricesCardTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *priceCardArray;
@end


@implementation PricesCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}


- (void)setPriceCard:(NSArray *)priceCardArray {
    self.priceCardArray = priceCardArray;
    [self.collectionView reloadData];
    
    NSInteger scrollIndex = 0;
    if (self.priceCardArray.count == 2) {
        scrollIndex = 1;
    } else if (self.priceCardArray.count == 3) {
        scrollIndex = 1;
    } else if (self.priceCardArray.count > 3) {
        scrollIndex = 2;
    }
    
    if (self.alreadySelected) {
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.activeIndex inSection:0]];
    } else{
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:scrollIndex inSection:0]];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.priceCardArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *giftDict = self.priceCardArray[indexPath.row];
    

    GiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiftCell" forIndexPath:indexPath];
    cell.giftDict = giftDict;
    
    if ([[giftDict allKeys] containsObject:@"sold_out"] && [giftDict[@"sold_out"] isEqual: @(YES)]) {
        [cell.soldOutIcon setHidden:NO];
    } else {
        [cell.soldOutIcon setHidden:YES];
    }
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@%.0f", giftDict[@"price"][@"currency_symbol"], [giftDict[@"price"][@"value"] floatValue]];
    
    cell.containerView.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == self.activeIndex) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.containerView.backgroundColor = [UIColor whiteColor];
        cell.priceLabel.textColor = [UIColor colorWithHexString:@"#FA3E3F"];
        cell.priceLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:21.0f];
        cell.containerView.layer.borderColor = [UIColor colorWithHexString:@"#FA3E3F"].CGColor;
    } else {
        cell.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        cell.containerView.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        cell.priceLabel.textColor = [UIColor colorWithHexString:@"#B5B5B5"];
        cell.priceLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:15.0f];
        cell.containerView.layer.borderColor = [UIColor colorWithHexString:@"#B5B5B5"].CGColor;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.activeIndex) {
        if ([SDVersion deviceSize] == Screen4Dot7inch) {
            return CGSizeMake(76.0f, 40.85f);
        } else{
            return CGSizeMake(80.0f, 43.0f);
        }
        
    } else {
        if ([SDVersion deviceSize] == Screen4Dot7inch) {
            return CGSizeMake(56.0f, 29.87);
        } else{
            return CGSizeMake(60.0f, 32.0f);
 
        }
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    // Center Items
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat inset = (screenWidth - ( 80 + 60*(self.priceCardArray.count-1) ) ) / 2.0f;
    inset = (inset <= 0) ? 10 : inset;
    return UIEdgeInsetsMake(0, inset, 0, inset);
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    NSDictionary *giftDict = self.priceCardArray[indexPath.row];
//    if ([[giftDict allKeys] containsObject:@"sold_out"] && [giftDict[@"sold_out"] isEqual: @(YES)]) {
//        return NO;
//    } else {
//        return YES;
//    }
//}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.activeIndex = indexPath.row;
    [self updateCashBackInformation];
    
    [self.collectionView reloadData];
    
    if (self.activeIndex) { 
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        // Fixes issue where scrolling doesn't stop at exact cell
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    }
    
}

- (void)updateCashBackInformation {
    NSDictionary *giftDict = self.priceCardArray[self.activeIndex];
    if (giftDict){
        if ([self.delegate respondsToSelector:@selector(giftCardSelected:WithIndexCard:)]) {
            [self.delegate giftCardSelected:giftDict WithIndexCard:self.activeIndex];
        }
    }
}

@end
