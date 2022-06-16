//
//  PlaceholderMeView.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"

@interface PlaceholderMeView : UIView
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *loader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYContraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
- (void)changePlaceHolderMode:(NSInteger)mode;
- (void)startLoader;
- (void)stopLoader;
- (void)refreshSize;

typedef enum : NSUInteger {
    kProfileMeMenuModeGeneral,
    kProfileMeMenuModeLike,
   kProfileMeMenuModeWishlist
} kProfileMeMenuMode;


@end
