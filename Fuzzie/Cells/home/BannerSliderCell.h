//
//  BannerSliderCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerSliderCellDelegate <NSObject>
- (void)bannerClicked:(NSDictionary *)bannerDict;
@end

@interface BannerSliderCell : UITableViewCell

- (void)initSliderIfNeeded;
- (void)setBanner:(NSArray *)bannerArray;

@property (strong, nonatomic)  NSArray *bannerArray;
@property (nonatomic) BOOL isAnimated;
@property (weak, nonatomic) id<BannerSliderCellDelegate> delegate;
@end
