//
//  AboutBrandTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutBrandTableViewCell.h"
#import "FZBrand.h"


@protocol AboutBrandTableViewCellDelegate <NSObject>
- (void)aboutBrandCell:(UITableViewCell *)aboutBrandCell tappedWithHeightCell:(int)heightCell;
- (void)buttonSocialTapped:(NSInteger)buttonSocialType;
@end

@interface AboutBrandTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *instagramImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAboutTextContraint;
@property (strong, nonatomic) NSString *aboutBrand;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *aboutBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;
@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;
@property (weak, nonatomic) IBOutlet UIImageView *websiteImage;
@property (weak, nonatomic) IBOutlet UIView *topSeparator;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;

@property (assign, nonatomic) BOOL isAlreadyInitialize;
@property (assign, nonatomic) BOOL hasSocialLink;
@property (assign, nonatomic) BOOL hasFacebook;
@property (assign, nonatomic) BOOL hasTwitter;
@property (assign, nonatomic) BOOL hasInstagram;
@property (assign, nonatomic) BOOL hasWebsite;
@property (strong, nonatomic) NSMutableArray *listSocial;

@property (weak, nonatomic) id<AboutBrandTableViewCellDelegate> delegate;
@property (assign, nonatomic) int heightText;
- (void)setAboutBrandTextWithBrand:(FZBrand *)brand;
- (void)expandCellContent;
@end

typedef enum : NSUInteger {
    AboutBrandButtonTypeFacebook,
    AboutBrandButtonTypeTwitter,
    AboutBrandButtonTypeInstagram,
    AboutBrandButtonTypeWebsite
} AboutBrandButtonType;
