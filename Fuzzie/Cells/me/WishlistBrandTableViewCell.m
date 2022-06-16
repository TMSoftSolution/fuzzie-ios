//
//  WishlistBrandTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/17/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "WishlistBrandTableViewCell.h"
#import "Masonry.h"
#import <QuartzCore/QuartzCore.h>
#import "AvatarUserView.h"
#import "FLAnimatedImage.h"

@interface WishlistBrandTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconMore;
@property (weak, nonatomic) IBOutlet UIImageView *iconWhishlist;
@property (weak, nonatomic) IBOutlet UILabel *whistListButton;
@property (weak, nonatomic) IBOutlet UILabel *nbLikesLabel;
@property (weak, nonatomic) IBOutlet UIView *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *infoNoWhistlistLabel;
@property (weak, nonatomic) IBOutlet UIView *shareButtonContainer;
@property (weak, nonatomic) IBOutlet UIView *whislistButtonContainer;

@property (weak, nonatomic) IBOutlet UIImageView *iconLike;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *fuzzieLoader;

@property (assign, nonatomic) BOOL isInWishlist;
@property (assign, nonatomic) BOOL fiendLikeInitialized;
@property (assign, nonatomic) BOOL isLiked;
@property (assign, nonatomic) BOOL cashbackContainerIsRounded;
@property (strong, nonatomic) NSArray *usersLike;
@property (strong, nonatomic) NSArray *bearAvatarList;
@property (strong, nonatomic) NSMutableArray *stackFriendView;

@property (strong, nonatomic) FZBrand *brand;

@end

@implementation WishlistBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.stackFriendView = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:BRAND_ADDED_IN_WHISHLIST object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:BRAND_REMOVED_IN_WHISHLIST object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:LIKE_ADDED_IN_BRAND object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:LIKE_REMOVED_IN_BRAND object:nil];
    
    CGFloat borderWidth = 1.0f;
    self.likeButton.frame = CGRectInset(self.whistListButton.frame, -borderWidth, -borderWidth);
    self.likeButton.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    self.likeButton.layer.borderWidth = borderWidth;
    self.likeButton.layer.cornerRadius = 4.0f;
    self.likeButton.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *panButtonShare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonShareTapped)];
    panButtonShare.delegate = self;
    self.shareButtonContainer.userInteractionEnabled = YES;
    [self.shareButtonContainer addGestureRecognizer:panButtonShare];
    
    UITapGestureRecognizer *panWhislistButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonWhislistTapped)];
    panWhislistButton.delegate = self;
    self.whislistButtonContainer.userInteractionEnabled = YES;
    [self.whislistButtonContainer addGestureRecognizer:panWhislistButton];
    
    
    UITapGestureRecognizer *panLikeButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeButtonTapped)];
    panLikeButton.delegate = self;
    self.likeButton.userInteractionEnabled = YES;
    [self.likeButton addGestureRecognizer:panLikeButton];
    
    UITapGestureRecognizer *tapCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    tapCell.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapCell];
    
    self.fuzzieLoader.layer.cornerRadius = self.fuzzieLoader.frame.size.width/2.0;
    self.fuzzieLoader.layer.masksToBounds = YES;
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
    self.fuzzieLoader.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
}


- (void)initCellWithBrand:(FZBrand *)brand {
    
    if (self.brand) {
        return;
    }
    
    self.brand = brand;
    
    if (self.brand && self.brand.likersCount) {
        [self updateNbLikes:self.brand.likersCount];
    } else {
        [self updateNbLikes:0];
    }
    
    if (self.brand && [self.brand.isWishListed isEqual:@(YES)]) {
        [self setWhistListState:YES];
    } else {
       [self setWhistListState:FALSE];
    }
    
    
    [self initializeFriendListWith:self.brand.brandId];
}


- (void)initializeFriendListWith:(NSString *)brandId {
    if ([self.usersLike count] > 0) {
        return;
    }
    
    [self startLoader];
    __weak __typeof__(self) weakSelf = self;
    [BrandController getLikes:brandId withSuccess:^(NSArray *array, NSError *error) {
        
        [self stopLoader];
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            return;
        }
        if (array) {
            if ([array count] > 0) {
                
                //http://stackoverflow.com/questions/11098959/can-you-use-nssortdescriptor-to-sort-by-a-value-not-being-null
                
                NSSortDescriptor* sortOrderByFriend = [NSSortDescriptor sortDescriptorWithKey: @"self.isFriend" ascending: NO];
                NSSortDescriptor* sortOrderPictureAvailable = [NSSortDescriptor sortDescriptorWithKey: @"self.profileImage" ascending: NO];
                NSSortDescriptor* sortOrderByBearAvatar = [NSSortDescriptor sortDescriptorWithKey: @"self.bearAvatar" ascending: NO];
                
                
                weakSelf.usersLike = [array sortedArrayUsingDescriptors:
                                      @[sortOrderByFriend, sortOrderPictureAvailable, sortOrderByBearAvatar]];

                weakSelf.brand.likers = [[NSMutableArray alloc] initWithArray:weakSelf.usersLike];
                
                
                if ([weakSelf.brand.isLiked isEqual:@1]) {
                    [weakSelf setFilledHeart];
                } else {
                    [weakSelf setEmptyHeart];
                }
                
                [weakSelf generateAvatarView];
                weakSelf.iconMore.layer.opacity = 1;
                
            }
        }
    }];
    
}

-(void)generateAvatarView {

    int nbCell = (int)([UIScreen mainScreen].bounds.size.width - 150) / 30;

    int nbUserLike = (int)[self.brand.likers count];
    if (nbUserLike < nbCell) {
        nbCell = nbUserLike;
    }
    
    if (nbCell == 0) {
        self.infoNoWhistlistLabel.layer.opacity = 1;
    }
    
    for (int i = 0; i < nbCell; i++) {
        UIView *avatarView = [self generateAvatarViewWith:self.brand.likers[nbCell-1-i]];
        avatarView.opaque = 0;
        avatarView.tag = nbCell-1-i;
        [self.stackFriendView addObject:avatarView];
        [self addSubview:avatarView];
        
        
        __weak __typeof__(self) weakSelf = self;
        if (i == 0) {
            [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.iconMore.mas_centerY);
                make.right.equalTo(weakSelf.iconMore.mas_left).offset(-5);
                make.height.equalTo(@30);
                make.width.equalTo(@30);
            }];
        } else {
            [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.iconMore.mas_centerY);
                make.right.equalTo(((UIView *)weakSelf.stackFriendView[i - 1]).mas_left).offset(-5);
                make.height.equalTo(@30);
                make.width.equalTo(@30);
            }];
        }

    }
    int i = 0;
    for (UIView *view in self.stackFriendView) {
        [UIView animateWithDuration:0.25
                              delay:i*2
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             view.opaque = 1;
                             
                         }
                         completion:nil];
        i++;
    }
    
}

- (UIView *)generateAvatarViewWith:(FZUser *)userInfo {
    
    AvatarUserView *avatarView = [[AvatarUserView alloc] init];
    
    if (userInfo) {
        avatarView.userInfo = userInfo;
    }
    
    
    UITapGestureRecognizer *tapAvatarView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarUserTapped:)];
    tapAvatarView.delegate = self;
    avatarView.userInteractionEnabled = YES;
    [avatarView addGestureRecognizer:tapAvatarView];
    
    if (userInfo.profileImage) {
        [avatarView.avatarImage sd_setImageWithURL:[NSURL URLWithString:userInfo.profileImage] placeholderImage:[UIImage imageNamed:userInfo.bearAvatar]];
    } else {
        avatarView.avatarImage.image = [UIImage imageNamed:userInfo.bearAvatar];
    }
    if ([userInfo.isFriend isEqual: @1]) {
        avatarView.iconImageView.hidden = NO;
        avatarView.iconImageView.image = [UIImage imageNamed:@"icon-avatar-fb"];
    } else{
        avatarView.iconImageView.hidden = YES;
    }
    
    
    return avatarView;
}

- (void)likeButtonTapped {
    if ([self.delegate respondsToSelector:@selector(buttonLikeTappedWithState:)]) {
        if (self.isLiked) {
            [self setEmptyHeart];
            [self updateNbLikes:[NSNumber numberWithInt:([self.brand.likersCount intValue] - 1) ]];
            self.isLiked = NO;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:LIKE_REMOVED_IN_BRAND
             object:nil
             userInfo:@{@"brand":self.brand, @"nbLike":self.brand.likersCount}];
        } else {
            [self setFilledHeart];
            [self updateNbLikes:[NSNumber numberWithInt:([self.brand.likersCount intValue] + 1) ]];
            self.isLiked = YES;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:LIKE_ADDED_IN_BRAND
             object:nil
             userInfo:@{@"brand":self.brand, @"nbLike":self.brand.likersCount}];
        }
        [self.delegate buttonLikeTappedWithState:self.isLiked];
    }
}

- (void)cellTapped {
    if ([self.delegate respondsToSelector:@selector(avatarUserCellTapped:)]) {
        if (self.usersLike) {
            [self.delegate avatarUserCellTapped:self.usersLike];
        }
    }
}


- (void)updateNbLikes:(NSNumber *)nbLikes {
    
    if (nbLikes < 0) {
        self.nbLikesLabel.text = @"0";
        self.brand.likersCount = @0;
    } else {
        self.brand.likersCount = nbLikes;
        self.nbLikesLabel.text = [NSString stringWithFormat:@"%@",self.brand.likersCount];
    }
}


- (void)avatarUserTapped:(UITapGestureRecognizer*)sender {
    if ([self.delegate respondsToSelector:@selector(avatarUserLikeTappedWith:)]) {
        [self.delegate avatarUserLikeTappedWith:((AvatarUserView *)sender.view).userInfo];
    }
}


- (void)buttonShareTapped {
    if ([self.delegate respondsToSelector:@selector(buttonShareTapped)]) {
        [self.delegate buttonShareTapped];
    }
}

- (void)buttonWhislistTapped {
    if ([self.delegate respondsToSelector:@selector(buttonWhishListTappedWithState:)]) {
        if ([self.brand.isWishListed isEqual:@(YES)]) {
            [self setWhistListState:NO];
            [self.delegate buttonWhishListTappedWithState:NO];
        } else {
            [self setWhistListState:YES];
            [self.delegate buttonWhishListTappedWithState:YES];
        }
    }
}

- (void)avatarUserCellTapped:(NSArray *)friendList {
    if ([self.delegate respondsToSelector:@selector(avatarUserCellTapped:)]) {
        if (self.isInWishlist) {
            self.isInWishlist = NO;
            [UIView transitionWithView:self
                              duration:0.2f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.whistListButton.text = @"Add to whislist";
                                self.whistListButton.textColor = [UIColor colorWithHexString:@"#8E8E8E"];
                                self.iconWhishlist.image = [UIImage imageNamed:@"icon-whislist"];
                            } completion:nil];
        } else {
            self.isInWishlist = YES;
            [UIView transitionWithView:self
                              duration:0.2f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.whistListButton.text = @"Wishlisted";
                                self.whistListButton.textColor = [UIColor colorWithHexString:@"#FA3E3F"];
                                self.iconWhishlist.image = [UIImage imageNamed:@"icon-whishlisted"];
                            } completion:nil];

        }
        [self.delegate buttonWhishListTappedWithState:self.isInWishlist];
    }
}

- (void)setEmptyHeart {

    __weak __typeof__(self) weakSelf = self;
    self.isLiked = NO;
    self.brand.isLiked = @(NO);
    [UIView transitionWithView:weakSelf.likeButton
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        weakSelf.iconLike.image = [UIImage imageNamed:@"heart-icon-red"];
                    } completion:nil];
}

- (void)setFilledHeart {
    __weak __typeof__(self) weakSelf = self;
    self.isLiked = YES;
    self.brand.isLiked = @(YES);
    [UIView transitionWithView:weakSelf.likeButton
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        weakSelf.iconLike.image = [UIImage imageNamed:@"heart-icon-red-filled"];
                    } completion:nil];
}


- (void)setWhistListState:(BOOL)state {
    
    __weak __typeof__(self) weakSelf = self;
    
    [UIView transitionWithView:self.whistListButton
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        if (state) {
                            weakSelf.brand.isWishListed = @(YES);
                            weakSelf.whistListButton.text = @"Wishlisted";
                            weakSelf.whistListButton.textColor = [UIColor colorWithHexString:@"#FA3E3F"];
                            weakSelf.iconWhishlist.image = [UIImage imageNamed:@"icon-whishlisted"];
                        } else {
                            weakSelf.brand.isWishListed = @(NO);
                            weakSelf.whistListButton.text = @"Add to wishlist";
                            weakSelf.whistListButton.textColor = [UIColor colorWithHexString:@"#8E8E8E"];
                            weakSelf.iconWhishlist.image = [UIImage imageNamed:@"icon-whislist"];
                        }
                    } completion:nil];
    

}


- (void)getNotification:(NSNotification *)notification
{
    
    if ([[notification name] isEqualToString:BRAND_ADDED_IN_WHISHLIST]) {
        FZBrand *brand = [notification.userInfo objectForKey:@"brand"];
        if (brand == nil || ![brand.brandId isEqualToString:self.brand.brandId]) {
            return;
        }
        [self setWhistListState:YES];
        
    } else if ([[notification name] isEqualToString:BRAND_REMOVED_IN_WHISHLIST]){
        FZBrand *brand = [notification.userInfo objectForKey:@"brand"];
        if (brand == nil || ![brand.brandId isEqualToString:self.brand.brandId]) {
            return;
        }
        [self setWhistListState:NO];
    }
    
    
    
    if ([[notification name] isEqualToString:LIKE_ADDED_IN_BRAND]) {
        FZBrand *brand = [notification.userInfo objectForKey:@"brand"];
        if (brand == nil || ![brand.brandId isEqualToString:self.brand.brandId]) {
            return;
        }
        
        NSNumber *nbLike = [notification.userInfo objectForKey:@"nbLike"];
        
        [self setFilledHeart];
        [self updateNbLikes:(nbLike)];
        self.isLiked = YES;
        
    } else if ([[notification name] isEqualToString:LIKE_REMOVED_IN_BRAND]){
        FZBrand *brand = [notification.userInfo objectForKey:@"brand"];
        if (brand == nil || ![brand.brandId isEqualToString:self.brand.brandId]) {
            return;
        }
        
        NSNumber *nbLike = [notification.userInfo objectForKey:@"nbLike"];
        
        [self setEmptyHeart];
        [self updateNbLikes:(nbLike)];
        self.isLiked = NO;
    }
    
}

- (void)startLoader {
    self.fuzzieLoader.hidden = NO;
    [self.fuzzieLoader startAnimating];
}

- (void)stopLoader {
    self.fuzzieLoader.hidden = YES;
    [self.fuzzieLoader stopAnimating];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BRAND_REMOVED_IN_WHISHLIST object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BRAND_ADDED_IN_WHISHLIST object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIKE_ADDED_IN_BRAND object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIKE_REMOVED_IN_BRAND object:nil];

}

@end
