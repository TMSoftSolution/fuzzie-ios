//
//  ClubFlashTableViewCell.h
//  Fuzzie
//
//  Created by joma on 7/11/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubFlashTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivFlash;
@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;

@property (strong, nonatomic) NSDictionary *dict;

- (void)setCell:(NSDictionary*)dict;

@end
