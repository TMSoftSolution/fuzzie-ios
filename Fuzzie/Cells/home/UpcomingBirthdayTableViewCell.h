//
//  UpcomingBirthdayTableViewCell.h
//  Fuzzie
//
//  Created by mac on 6/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpcomingBirthdayTableViewCellDelegate <NSObject>

- (void) userWasClicked:(FZUser*) userInfo;
@optional
- (void) moreButtonClicked;
@optional
- (void)facebookConnectClicked;

@end

@interface UpcomingBirthdayTableViewCell : UITableViewCell <UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *facebookConnectView;

@property (strong, nonatomic) NSArray *userInfos;
@property (assign, nonatomic) int nbLimit;

@property (weak, nonatomic) id<UpcomingBirthdayTableViewCellDelegate> delegate;

- (void)setCell:(NSArray *)userInfos;

@end
