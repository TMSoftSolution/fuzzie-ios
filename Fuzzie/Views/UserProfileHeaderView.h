//
//  UserProfileHeaderView.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserProfileHeaderViewDelegate <NSObject>

- (void)profilePhotoPressed;

@end

@interface UserProfileHeaderView : UIView
- (void)setInfoUser:(FZUser *)userInfo;

@property(strong, nonatomic) id<UserProfileHeaderViewDelegate> delegate;
@end
