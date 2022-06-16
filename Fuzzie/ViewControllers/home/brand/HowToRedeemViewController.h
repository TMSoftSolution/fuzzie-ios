//
//  HowToRedeemViewController.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowToRedeemViewController : FZBaseViewController
@property (strong, nonatomic) FZBrand *brand;
@property (assign, nonatomic) BOOL isPowerUp;

@property (strong, nonatomic) NSArray *instructionsArray;

@end
