//
//  StoreTableViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 19/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *addressContainerView;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *phoneContainerView;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *openingContainerView;
@property (weak, nonatomic) IBOutlet MDHTMLLabel *openingLabel;

@end
