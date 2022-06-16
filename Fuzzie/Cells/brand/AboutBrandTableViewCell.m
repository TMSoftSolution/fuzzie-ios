//
//  AboutBrandTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "AboutBrandTableViewCell.h"
#import "TTTAttributedLabel.h"
#import "UILabel+Truncation.h"
#import "Masonry.h"
#import "FZBrand.h"
#import "SDVersion.h"


@interface AboutBrandTableViewCell () <TTTAttributedLabelDelegate>

@end

@implementation AboutBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.aboutBrandLabel.linkAttributes = @{ (id)kCTForegroundColorAttributeName: [UIColor colorWithRed:0.98 green:0.24 blue:0.25 alpha:1.0],
                                             (id)kCTUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleNone] };
    
    self.listSocial = [[NSMutableArray alloc] init];
    
    self.instagramImage.tag = AboutBrandButtonTypeInstagram;
    self.twitterImage.tag = AboutBrandButtonTypeTwitter;
    self.facebookImage.tag = AboutBrandButtonTypeFacebook;
    self.websiteImage.tag = AboutBrandButtonTypeWebsite;
    
    
    UITapGestureRecognizer *tapFacebook = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSocialTapped:)];
    tapFacebook.delegate = self;
    [self.facebookImage addGestureRecognizer:tapFacebook];
    
    UITapGestureRecognizer *tapTwitter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSocialTapped:)];
    tapTwitter.delegate = self;
    [self.twitterImage addGestureRecognizer:tapTwitter];
    
    UITapGestureRecognizer *tapInstagram = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSocialTapped:)];
    tapInstagram.delegate = self;
    [self.instagramImage addGestureRecognizer:tapInstagram];
    
    UITapGestureRecognizer *tapWebsite = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSocialTapped:)];
    tapWebsite.delegate = self;
    [self.websiteImage addGestureRecognizer:tapWebsite];
    
}

- (void)buttonSocialTapped:(UITapGestureRecognizer *)sender
{
    if ([sender.view isKindOfClass:[UIImageView class]]) {
        if ([self.delegate respondsToSelector:@selector(buttonSocialTapped:)]) {
            [self.delegate buttonSocialTapped:sender.view.tag];
        }
    }
}


- (void)setAboutBrandTextWithBrand:(FZBrand *)brand {
    
    
    if (self.isAlreadyInitialize) {
        return;
    }
    
    self.aboutBrand = brand.about;
    self.aboutBrandLabel.text = self.aboutBrand;
    
    
    if (brand.facebook && ![brand.facebook isEqualToString:@""]) {
        self.hasSocialLink = YES;
        self.hasFacebook = YES;
        self.facebookImage.userInteractionEnabled = YES;
        [self.listSocial addObject:self.facebookImage];
    }
    
    if (brand.twitter && ![brand.twitter isEqualToString:@""]) {
        self.hasSocialLink = YES;
        self.hasTwitter = YES;
        self.twitterImage.userInteractionEnabled = YES;
        [self.listSocial addObject:self.twitterImage];
    }
    
    if (brand.instagram && ![brand.instagram isEqualToString:@""]) {
        self.hasSocialLink = YES;
        self.hasInstagram = YES;
        self.instagramImage.userInteractionEnabled = YES;
        [self.listSocial addObject:self.instagramImage];
    }
    
    if (brand.website && ![brand.website isEqualToString:@""]) {
        self.hasSocialLink = YES;
        self.hasWebsite = YES;
        self.websiteImage.userInteractionEnabled = YES;
        [self.listSocial addObject:self.websiteImage];
    }
    
    
    BOOL isTruncated = [self.aboutBrandLabel isTruncated];
    
    if (isTruncated || self.hasSocialLink) {
        
        if (isTruncated) {
            
            int limit = 170;
            
            if ([SDVersion deviceSize] == Screen4Dot7inch) {
                limit = 200;
            }
            
            if ([SDVersion deviceSize] == Screen5Dot5inch) {
                limit = 230;
            }
            
            if (self.aboutBrand.length >= limit) {
                 NSString *subStringBrandAbout = [self.aboutBrand substringToIndex:limit];
                
                
                NSString *newString = [subStringBrandAbout stringByReplacingOccurrencesOfString:@"[\r\n]"
                                                                                     withString:@""
                                                                                        options:NSRegularExpressionSearch
                                                                                          range:NSMakeRange(0, subStringBrandAbout.length)];
                
                NSRange range = [newString rangeOfString:@" " options:NSBackwardsSearch];
                NSString *pendingString = [newString substringToIndex:range.location];
                self.aboutBrandLabel.text = [NSString stringWithFormat:@"%@...  More",pendingString];
                
                
                [self.aboutBrandLabel addLinkToTransitInformation:@{@"expand":@"true"} withRange:[self.aboutBrandLabel.text rangeOfString:@"More"]];
            } else {
                NSString *newString = [self.aboutBrand stringByReplacingOccurrencesOfString:@"[\r\n]"
                                                                                     withString:@""
                                                                                        options:NSRegularExpressionSearch
                                                                                          range:NSMakeRange(0, self.aboutBrand.length)];
                NSRange range = [newString rangeOfString:@" " options:NSBackwardsSearch];
                
                if (range.location != NSNotFound) {
                    NSString *pendingString = [newString substringToIndex:range.location];
                    self.aboutBrandLabel.text = [NSString stringWithFormat:@"%@... More",pendingString];
                    
                } else {
                    self.aboutBrandLabel.text = [NSString stringWithFormat:@"%@... More",self.aboutBrandLabel.text];
                }
            }
            

        } else if (self.hasSocialLink) {
            NSString *newString = [self.aboutBrand stringByReplacingOccurrencesOfString:@"[\r\n]"
                                                                             withString:@""
                                                                                options:NSRegularExpressionSearch
                                                                                  range:NSMakeRange(0, self.aboutBrand.length)];
            NSRange range = [newString rangeOfString:@" " options:NSBackwardsSearch];
            NSString *pendingString = [newString substringToIndex:range.location];
            self.aboutBrandLabel.text = [NSString stringWithFormat:@"%@... More",pendingString];
        }
        
        [self.aboutBrandLabel addLinkToTransitInformation:@{@"expand":@"true"} withRange:[self.aboutBrandLabel.text rangeOfString:@"More"]];
        
    } else {
        self.aboutBrandLabel.text = brand.about;
    }
    
    
    self.aboutBrandLabel.delegate = self;
    self.aboutBrandLabel.linkAttributes = @{ (id)kCTForegroundColorAttributeName: [UIColor colorWithRed:0.98 green:0.24 blue:0.25 alpha:1.0],
                                             (id)kCTUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleNone] };

    
    self.isAlreadyInitialize = YES;
    
    
    NSDictionary *fontAttributes = @{NSFontAttributeName:self.aboutBrandLabel.font};
    CGRect rect = [self.aboutBrandLabel.text boundingRectWithSize:CGSizeMake(self.aboutBrandLabel.frame.size.width, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       attributes:fontAttributes
                                                          context:nil];
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    self.heightAboutTextContraint.constant = ((282 * rect.size.height) / 248) + 3;
}



- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTransitInformation:(NSDictionary *)components {
    self.aboutBrandLabel.numberOfLines = 999;
    self.aboutBrandLabel.text = self.aboutBrand;

    if ([self.delegate respondsToSelector:@selector(aboutBrandCell:tappedWithHeightCell: )]) {
        
        NSDictionary *fontAttributes = @{NSFontAttributeName:self.aboutBrandLabel.font};
        CGRect rect = [self.aboutBrandLabel.text boundingRectWithSize:CGSizeMake(self.aboutBrandLabel.frame.size.width, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                  attributes:fontAttributes
                                                     context:nil];
        
        self.heightText = ((282 * rect.size.height) / 248) + 10; // try to fix by 4/3 + delta
        
        //115 total of padding and other eleents
        [self.delegate aboutBrandCell:self tappedWithHeightCell:self.heightText+120];
    }
}

- (void)expandCellContent {
    __typeof__(self) __weak weakSelf = self;
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [weakSelf layoutIfNeeded];
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.20);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.10 animations:^{
            for (UIView *view in weakSelf.listSocial) {
                view.layer.opacity = 1;
            }
        }];
    });
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (int)getLastSocialTypeDisplayedFrom:(NSInteger)socialType {
    int lastHidden = -1;
    for (int i = 0; i<socialType; i++) {
        UIView *view = [self viewWithTag:i];
        if (view.hidden == YES) {
            lastHidden = i;
        }
    }
    return lastHidden;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    __typeof__(self) __weak weakSelf = self;
    
    if (self.heightText) {
        self.heightAboutTextContraint.constant = self.heightText;
        
        int i = 0;
        for (UIView *view in self.listSocial) {
            
            int widthSize = 30;
            if (view.tag == AboutBrandButtonTypeWebsite) {
                widthSize = 100;
            }
            
            if ( i== 0) {
                [((UIView *)weakSelf.listSocial[0]) mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.greaterThanOrEqualTo(weakSelf.aboutBrandLabel.mas_bottom).with.offset(15);
                    make.left.equalTo(weakSelf.mas_left).with.offset(15);
                    make.bottom.greaterThanOrEqualTo(weakSelf.mas_bottom).with.offset(-15).priorityMedium();
                    make.height.equalTo(@30);
                    make.width.equalTo([NSNumber numberWithInteger:widthSize]);
                }];
            } else {
                [((UIView *)weakSelf.listSocial[i]) mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(((UIView *)weakSelf.listSocial[i-1]).mas_right).with.offset(8);
                    make.centerY.equalTo(((UIView *)weakSelf.listSocial[0]).mas_centerY);
                    make.height.equalTo(@30);
                    make.width.equalTo([NSNumber numberWithInteger:widthSize]);
                }];

            }
            i++;
        }
        
    }
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

@end
