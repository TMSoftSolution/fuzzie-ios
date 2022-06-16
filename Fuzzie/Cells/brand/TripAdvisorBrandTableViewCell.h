//
//  TripAdvisorBrandTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/17/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TripAdvisorBrandTableViewCellDelegate <NSObject>
- (void)goToTripAdvisorPageWith:(NSString *)URL;
@end

@interface TripAdvisorBrandTableViewCell : UITableViewCell
- (void)getTripAdvisorInfoWithBrandId:(FZBrand *)brand;

- (void)setRating:(float)rate;
- (void)hideRatingCircle:(BOOL)status;

@property (weak, nonatomic) id<TripAdvisorBrandTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *iconPush;
@property (weak, nonatomic) IBOutlet UILabel *nbReviewLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconTripAndVisor;
@property (weak, nonatomic) IBOutlet UIView *topSeperator;

@end
