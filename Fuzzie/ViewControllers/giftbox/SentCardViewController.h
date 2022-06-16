//
//  SentCardViewController.h
//  Fuzzie
//
//  Created by mac on 7/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandViewController.h"

@interface SentCardViewController : BrandViewController

@property (strong, nonatomic) NSDictionary *giftDict;
@property (strong, nonatomic) NSDictionary *giftCardDict;

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
