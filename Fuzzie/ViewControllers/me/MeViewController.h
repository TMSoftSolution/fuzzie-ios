//
//  MeViewController.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 19/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuzzieViewController.h"

@interface MeViewController : FuzzieViewController
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *segmentButtons;
- (IBAction)segmentButtonPressed:(id)sender;

@property (assign, nonatomic) BOOL fromShop;
@property (assign, nonatomic) BOOL selectWishlist;
@property (assign, nonatomic) BOOL initinalized;

@end
