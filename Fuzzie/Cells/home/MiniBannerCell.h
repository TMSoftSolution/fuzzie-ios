//
//  MiniBannerCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MiniBannerSliderCellDelegate <NSObject>
@optional
- (void)miniBannerClicked:(NSDictionary *)bannerDict;
@end

@interface MiniBannerCell : UITableViewCell
- (void)initSliderIfNeeded;
- (void)setBanner:(NSArray *)bannerArray;
@property (nonatomic) BOOL isAnimated;
@property (weak, nonatomic) id<MiniBannerSliderCellDelegate> delegate;
@end
