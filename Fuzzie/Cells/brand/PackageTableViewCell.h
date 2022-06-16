//
//  PackageTableViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 7/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PackageTableViewCellDelegate <NSObject>

- (void)packageCellDidPressViewMoreForPackage:(NSDictionary *)packageDict;

@end

@interface PackageTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PackageTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *packageDict;
@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *packagePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageOriginalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageDescriptionLabel;


@end
