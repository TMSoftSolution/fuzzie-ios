//
//  BannerTableViewCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 21/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "BannerTableViewCell.h"
#import "BannerCollectionViewCell.h"

@interface BannerTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *autoScrollTimer;

@end

@implementation BannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
}

- (void)autoScroll {
    if (self.bannerArray && self.bannerArray.count > 1) {
        if (self.pageControl.currentPage == self.pageControl.numberOfPages-1) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            self.pageControl.currentPage = 0;
        } else {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageControl.currentPage+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            self.pageControl.currentPage = self.pageControl.currentPage+1;
        }
    }
}

- (void)dealloc {
    if (self.autoScrollTimer) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBannerArray:(NSArray *)bannerArray {
    _bannerArray = bannerArray;
    self.pageControl.numberOfPages = bannerArray.count;
    self.pageControl.currentPage = 0;
    [self.collectionView reloadData];
    
    self.pageControl.hidden = (self.bannerArray.count == 1);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bannerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndexPath:indexPath];
    
    NSDictionary *bannerDict = self.bannerArray[indexPath.row];
    
    NSString *headerString = bannerDict[@"header"];
    NSString *subHeaderString = bannerDict[@"sub_header"];
    
    cell.titleLabel.text = headerString;
    cell.subtitleLabel.text = subHeaderString;
    
    if ((!headerString || headerString.length == 0) || (!subHeaderString || subHeaderString.length == 0)) {
        cell.gradientView.hidden = YES;
    } else {
        cell.gradientView.hidden = NO;
    }
    
    NSURL *imageURL = [NSURL URLWithString:bannerDict[@"image"]];
    [cell.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.frame.size.width, 240.0f);
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *bannerDict = self.bannerArray[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerWasClicked:)]) {
        [self.delegate bannerWasClicked:bannerDict];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.pageControl.currentPage = self.collectionView.contentOffset.x / pageWidth;
}

@end
