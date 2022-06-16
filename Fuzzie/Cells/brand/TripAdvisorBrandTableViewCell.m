//
//  TripAdvisorBrandTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/17/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "TripAdvisorBrandTableViewCell.h"
#import "BrandController.h"

@interface TripAdvisorBrandTableViewCell()

@property (strong, nonatomic) FZBrand *brand;

@end
@implementation TripAdvisorBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTripAdvisorTapped:)];
    pan.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:pan];
    
    [self hideRatingCircle:YES];
    
}

- (void)getTripAdvisorInfoWithBrandId:(FZBrand *)brand {
    if (self.brand) {
        return;
    }
    
    self.brand = brand;
    
    if (brand.tripadvisorReviewCount) {
        self.nbReviewLabel.text = [NSString stringWithFormat:@"(%@ Reviews)",brand.tripadvisorReviewCount];
    }
    
    if (brand.tripadvisorRating) {
        [self setRating:[brand.tripadvisorRating floatValue]];
    }
    
    self.iconPush.alpha = 1.0;
    self.nbReviewLabel.alpha = 1.0;
    self.iconPush.alpha = 1.0;
    self.iconTripAndVisor.alpha = 1.0;
    
    [self hideRatingCircle:NO];

}


- (void)cellTripAdvisorTapped:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(goToTripAdvisorPageWith:)]) {
        if (self.brand.tripadvisorLink){
           [self.delegate goToTripAdvisorPageWith:self.brand.tripadvisorLink];
        }
    }
}

- (void)setRating:(float)rate {
    for (int i = 1; i <= rate; i++) {
        UIView *circle = [self viewWithTag:i];
        if (circle) {
            ((UIImageView *)circle).image = [UIImage imageNamed:@"icon-trip-fill"];
        }
    }
    
    float half = rate - ((int)rate);
    if (half >= 0.5) {
        UIView *circle = [self viewWithTag:(((int)rate) + 1)];
        if (circle) {
            ((UIImageView *)circle).image = [UIImage imageNamed:@"icon-trip-fill-half"];
        }
    }
}

- (void)hideRatingCircle:(BOOL)status {
    
    for (int i = 1; i <= 5; i++) {
        UIView *circle = [self viewWithTag:i];
        if (circle) {
            if (status) {
                circle.alpha = 0.0;
            } else {
                circle.alpha = 1.0;
            }
        }
    }
}


@end
