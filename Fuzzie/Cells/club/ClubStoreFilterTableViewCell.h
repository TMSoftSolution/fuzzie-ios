//
//  ClubStoreFilterTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/20/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubStoreFilterTableViewCellDelegate <NSObject>

- (void)cellTapped:(NSDictionary*)category checked:(BOOL)checked;

@end

@interface ClubStoreFilterTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubStoreFilterTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *vCategory;
@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;
@property (weak, nonatomic) IBOutlet UILabel *tvCategory;

@property (assign, nonatomic) BOOL checked;
@property (strong, nonatomic) NSDictionary *category;

- (void)setCell:(NSDictionary*)category checked:(BOOL)checked;

@end
