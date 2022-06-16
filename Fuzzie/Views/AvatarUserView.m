//
//  AvatarUserView.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/22/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "AvatarUserView.h"
#import "Masonry.h"

@implementation AvatarUserView



- (id)init {
    
    if(self = [super init]) {
        self.clipsToBounds = NO;
        self.avatarImage = [[UIImageView alloc] init];
        [self.avatarImage setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.avatarImage];
        
        
        self.iconImageView = [[UIImageView alloc] init];
        [self addSubview:self.iconImageView];
        self.iconImageView.hidden = YES;
        
        __typeof__(self) __weak weakSelf = self;
        
        [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top);
            make.right.equalTo(weakSelf.mas_right);
            make.bottom.equalTo(weakSelf.mas_bottom);
            make.left.equalTo(weakSelf.mas_left);
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.mas_bottom).offset(5);
            make.right.equalTo(weakSelf.mas_right).offset(2);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width/2.0;
    self.avatarImage.layer.masksToBounds = YES;
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        self.avatarImage = [[UIImageView alloc] init];
        self.avatarImage.layer.cornerRadius = 35/2.0;
        self.avatarImage.layer.masksToBounds = YES;
        [self addSubview:self.avatarImage];
        
        
        self.iconImageView = [[UIImageView alloc] init];
        [self addSubview:self.iconImageView];
        self.iconImageView.hidden = YES;
        
        __typeof__(self) __weak weakSelf = self;
        
        [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top);
            make.right.equalTo(weakSelf.mas_right);
            make.bottom.equalTo(weakSelf.mas_bottom);
            make.left.equalTo(weakSelf.mas_left);
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.mas_bottom).offset(5);
            make.right.equalTo(weakSelf.mas_right).offset(2);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        self.clipsToBounds = NO;
        self.avatarImage = [[UIImageView alloc] init];
        self.avatarImage.layer.cornerRadius = 35/2.0;
        self.avatarImage.layer.masksToBounds = YES;
        [self addSubview:self.avatarImage];
        
        
        self.iconImageView = [[UIImageView alloc] init];
        [self addSubview:self.iconImageView];
        self.iconImageView.hidden = YES;
        
        __typeof__(self) __weak weakSelf = self;
        
        [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top);
            make.right.equalTo(weakSelf.mas_right);
            make.bottom.equalTo(weakSelf.mas_bottom);
            make.left.equalTo(weakSelf.mas_left);
        }];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.mas_bottom).offset(5);
            make.right.equalTo(weakSelf.mas_right).offset(2);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];
    }
    
    return self;
}




@end
