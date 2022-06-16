//
//  PowerUpPreviewTableViewCell.m
//  Fuzzie
//
//  Created by Joma on 3/25/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "PowerUpPreviewTableViewCell.h"

@implementation PowerUpPreviewTableViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.fuzzieLoader.layer.cornerRadius = self.fuzzieLoader.frame.size.width/2.0;
    self.fuzzieLoader.layer.masksToBounds = YES;
    [FLAnimatedImage setLogBlock:^(NSString *logString, FLLogLevel logLevel) {
        // Using NSLog
        NSLog(@"%@", logString);
        
        // ...or CocoaLumberjackLogger only logging warnings and errors
        if (logLevel == FLLogLevelError) {
            DDLogError(@"%@", logString);
        } else if (logLevel == FLLogLevelWarn) {
            DDLogWarn(@"%@", logString);
        }
    } logLevel:FLLogLevelWarn];
    
    NSString* path = [[NSBundle mainBundle] pathForResource: @"loader" ofType: @"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile: path];
    self.fuzzieLoader.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
    [self stopLoader];
    
    UINib *brandListCellNib = [UINib nibWithNibName:@"BrandListCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:brandListCellNib forCellWithReuseIdentifier:@"BrandListCell"];
    
    if (!self.brandArray) {
        [self loadPowerUpPreview];
    }
}

- (void)startLoader {
    self.fuzzieLoader.hidden = NO;
    [self.fuzzieLoader startAnimating];
}

- (void)stopLoader {
    self.fuzzieLoader.hidden = YES;
    [self.fuzzieLoader stopAnimating];
}

- (void)loadPowerUpPreview{
    
    [self startLoader];

    [JackpotController getPowerUpPreviewBrandIds:^(NSDictionary *dictionary, NSError *error) {
        
        [self stopLoader];
        
        if (dictionary) {
            
            NSArray *brandIds = dictionary[@"brand_ids"];
            
            if (brandIds && brandIds.count > 0) {
                
                NSMutableArray *temp = [[NSMutableArray alloc] init];
                
                for (NSString *brandId in brandIds) {
                    
                    FZBrand *brand = [FZData getBrandById:brandId];
                    if (brand) {
                        [temp addObject:brand];
                    }
                }
                
                self.brandArray = temp;
                [self.collectionView reloadData];
            }
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.brandArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrandListCell" forIndexPath:indexPath];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandListCollectionViewCell *cellBrand = (BrandListCollectionViewCell *)cell;
    cellBrand.spinner.hidden = YES;
    cellBrand.delegate = self;
    FZBrand *brand = self.brandArray[indexPath.row];
    [cellBrand setDataWith:brand];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(180.0f, 205.0f);
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.brandArray.count > 0) {
        FZBrand *brand = self.brandArray[indexPath.row];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(brandWasClicked:)]) {
            [self.delegate brandWasClicked:brand];
        }
    } else {
        BrandListCollectionViewCell *cell = (BrandListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.brand) {
            [self.delegate brandWasClicked:cell.brand];
        }
    }
}

#pragma -mark BrandListCollectionViewCellDelegate {
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state {
    if ([self.delegate respondsToSelector:@selector(likeButtonTappedOn:WithState:)]) {
        [self.delegate likeButtonTappedOn:brand WithState:state];
    }
}

@end
