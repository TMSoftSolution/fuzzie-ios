//
//  UserProfileViewController.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/23/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuzzieViewController.h"

@interface UserProfileViewController : FuzzieViewController
@property (nonatomic, strong) FZUser *userInfo;
@property (nonatomic, strong) NSString *userId;
@property (assign, nonatomic) BOOL selectWishList;
@end
