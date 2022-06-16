//
//  UpcomingBirthdayTableViewCell.m
//  Fuzzie
//
//  Created by mac on 6/26/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "UpcomingBirthdayTableViewCell.h"
#import "UpcomingBirthdayCollectionViewCell.h"

@implementation UpcomingBirthdayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UINib *brandListCellNib = [UINib nibWithNibName:@"UpcomingBirthdayCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:brandListCellNib forCellWithReuseIdentifier:@"UpcomingBirthdayCell"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)facebookConnectPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(facebookConnectClicked)]) {
        [self.delegate facebookConnectClicked];
    }
}


- (void)setCell:(NSArray *)userInfos{
    
    if (userInfos) {
        
        self.facebookConnectView.hidden = YES;
        self.collectionView.hidden = NO;
        self.userInfos = userInfos;
        [self.collectionView reloadData];
    } else{
        self.facebookConnectView.hidden = NO;
        self.collectionView.hidden = YES;
    }
  
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.nbLimit;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UpcomingBirthdayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UpcomingBirthdayCell" forIndexPath:indexPath];
    cell.userInfo = self.userInfos[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UpcomingBirthdayCollectionViewCell *userCell = (UpcomingBirthdayCollectionViewCell*)cell;
    [userCell setCellWithUser:self.userInfos[indexPath.row]];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(76.0f, 107.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return -8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.nbLimit - 1) {
         [self.delegate moreButtonClicked];
    } else{
         [self.delegate userWasClicked:self.userInfos[indexPath.row]];
    }
}

@end
