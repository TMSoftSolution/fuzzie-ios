//
//  FZFacebookFriend.h
//  Fuzzie
//
//  Created by mac on 6/20/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "Mantle.h"

@interface FZFacebookFriend : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profileImage;

@end
