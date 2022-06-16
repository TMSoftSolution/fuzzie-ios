//
//  StaticMiniBannerCell.h
//  Fuzzie
//
//  Created by mac on 5/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StaticMiniBannerCellDelegate <NSObject>

- (void)miniBannerCellTapped:(NSDictionary*)dict;

@end

@interface StaticMiniBannerCell : UITableViewCell

@property (nonatomic, weak) id<StaticMiniBannerCellDelegate> delegate;
@property (nonatomic, strong) NSDictionary *dict;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

- (void)setCell:(NSDictionary*)dict;
@end
