//
//  ClubTopTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/17/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubTopTableViewCellDelegate <NSObject>

- (void)brandWasClicked:(FZBrand*)brand;

@end

@interface ClubTopTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<ClubTopTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *brands;

- (void)setCell:(NSArray*)brands;

@end
