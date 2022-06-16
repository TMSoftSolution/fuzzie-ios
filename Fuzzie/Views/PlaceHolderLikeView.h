//
//  PlaceHolderLikeView.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"

@interface PlaceHolderLikeView : UIView
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *loader;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYcontraint;
- (void)startLoader;
- (void)stopLoader;
- (void)refreshSize;
@end
