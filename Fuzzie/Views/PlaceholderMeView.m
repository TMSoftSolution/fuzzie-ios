//
//  PlaceholderMeView.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PlaceholderMeView.h"
#import "UserProfileSwitchMode.h"
#import "FLAnimatedImage.h"
#import "MeViewController.h"

@implementation PlaceholderMeView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self changePlaceHolderMode:UserProfileModeLike];
    
    self.iconPlaceholder.layer.opacity = 0;
    self.titleLabel.layer.opacity = 0;
    self.subTitleLabel.layer.opacity = 0;
    
    self.loader.layer.cornerRadius = self.loader.frame.size.width/2.0;
    self.loader.layer.masksToBounds = YES;
    
    
    [FLAnimatedImage setLogBlock:^(NSString *logString, FLLogLevel logLevel) {
        // Using NSLog
        NSLog(@"%@", logString);
        
        // ...or CocoaLumberjackLogger only logging warnings and errors
        if (logLevel == FLLogLevelError) {
            DDLogError(@"%@", logString);
        } else if (logLevel == FLLogLevelWarn) {
            DDLogWarn(@"%@", logString);
        }
    } logLevel:FLLogLevelWarn];
    
    NSString* path = [[NSBundle mainBundle] pathForResource: @"loader" ofType: @"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile: path];
    self.loader.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
    
}

- (void)refreshSize {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *parentparentView =  self.superview.superview;
    parentparentView.frame = CGRectMake(0, 0,
                                        self.frame.size.width,
                                        screenHeight-106);
    
    self.frame = CGRectMake(0, 0,
                            self.frame.size.width,
                            screenHeight-106);
}

- (void)startLoader {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.iconPlaceholder.layer.opacity = 0;
                         weakSelf.titleLabel.layer.opacity = 0;
                         weakSelf.subTitleLabel.layer.opacity = 0;
                         weakSelf.loader.layer.opacity = 1;
                     } completion:^(BOOL finished) {
                         [self.loader startAnimating];
                     }];
}

- (void)stopLoader {
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.iconPlaceholder.layer.opacity = 1;
                         weakSelf.titleLabel.layer.opacity = 1;
                         weakSelf.subTitleLabel.layer.opacity = 1;
                         weakSelf.loader.layer.opacity = 0;
                     } completion:^(BOOL finished) {
                         [self.loader stopAnimating];
                     }];
}

- (void)changePlaceHolderMode:(NSInteger)mode {
    __weak typeof(self) weakSelf = self;
    
    [self.loader stopAnimating];
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         
                         weakSelf.loader.layer.opacity = 0;
                         weakSelf.iconPlaceholder.layer.opacity = 1;
                         weakSelf.titleLabel.layer.opacity = 1;
                         weakSelf.subTitleLabel.layer.opacity = 1;
                         
                         if (mode == kProfileMeMenuModeWishlist) {
                             weakSelf.titleLabel.text = @"WHAT DO YOU WISH FOR?";
                             weakSelf.subTitleLabel.text = @"Go to your favourite brands and add them to your wishlist. We'll share this with your friends.";
                             weakSelf.iconPlaceholder.image = [UIImage imageNamed:@"bear-baby"];
                         } else {
                             weakSelf.titleLabel.text = @"WHAT DO YOU LIKE?";
                             weakSelf.subTitleLabel.text = @"Tap on the heart icons of your favourite brands to start adding to this list.";
                             weakSelf.iconPlaceholder.image = [UIImage imageNamed:@"bear-hearts"];
                         }
                     }
                     completion:nil];
}

@end
