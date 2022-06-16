//
//  PackageViewController.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/6/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandViewController.h"

@interface PackageViewController : BrandViewController
@property (strong, nonatomic) NSDictionary *packageDict;
@property (strong, nonatomic) NSArray *couponsArray;
@end
