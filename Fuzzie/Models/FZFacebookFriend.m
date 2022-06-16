//
//  FZFacebookFriend.m
//  Fuzzie
//
//  Created by mac on 6/20/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZFacebookFriend.h"

@implementation FZFacebookFriend

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    
    return @{ @"name": @"name",
              @"profileImage": @"avatar"};
    
}

@end
