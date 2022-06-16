//
//  ClubStoreOfferTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubStoreOfferTableViewCellDelegate <NSObject>

- (void)clubStoreOfferCellTapped:(NSDictionary*)offer;

@end

@interface ClubStoreOfferTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubStoreOfferTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSDictionary *offer;

@property (weak, nonatomic) IBOutlet UIImageView *ivStore;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbOfferType;
@property (weak, nonatomic) IBOutlet UILabel *lbSave;
@property (weak, nonatomic) IBOutlet UIView *vShadow;

- (void)setCell:(NSDictionary*)offer;

@end
