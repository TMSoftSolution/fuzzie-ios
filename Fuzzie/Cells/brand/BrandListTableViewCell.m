//
//  BrandListTableViewCell.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "BrandListTableViewCell.h"
#import "BrandListCollectionViewCell.h"
#import "TopBrandCollectionViewCell.h"
#import "FLAnimatedImage.h"

@interface BrandListTableViewCell () <BrandListCollectionViewCellDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSArray *brandIdList;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *fuzzieLoader;


- (IBAction)viewAllButtonPressed:(id)sender;

@end

@implementation BrandListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nbLimit = -1;
    
    [self stopLoader];
    
    UINib *TopBrandCollectionViewCellNib = [UINib nibWithNibName:@"TopBrandCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:TopBrandCollectionViewCellNib forCellWithReuseIdentifier:@"TopBrandCell"];
    
    UINib *brandListCellNib = [UINib nibWithNibName:@"BrandListCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:brandListCellNib forCellWithReuseIdentifier:@"BrandListCell"];
    
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
}

- (void)setCell:(NSArray *)brandArray title:(NSString *)title limit:(int)limit type:(BrandListTableViewCellType)type showViewAll:(BOOL)showViewAll{
    
    if (brandArray) {
        
        [self stopLoader];
        
        self.brandArray = brandArray;
        
        self.titleLabel.text = title;
        self.nbLimit = limit;
        self.viewAllButton.hidden = !showViewAll;
        self.type = type;
        
        [self.collectionView reloadData];
        
    }
}

- (void)getOtherBrandsBy:(NSString *)brandId { 

    
    if (self.brandArray || self.brandIdList) {
        [self stopLoader];
        return;
    }
    
    [self startLoader];
    
    __typeof__(self) __weak weakSelf = self;
    [BrandController getOthersAlsoBoughtId:brandId withSuccess:^(NSArray *array, NSError *error) {
        [self stopLoader];
        if (error) {
            if (error.code == 417) {
                [AppDelegate logOut];
                return ;
            }
            return;
        } else {
            if (array.count > 0) {
                weakSelf.brandIdList = array;
                [self.collectionView reloadData];
            } 
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.brandArray) {
        if (self.nbLimit == -1) {
           return self.brandArray.count;
        } else {
            if (self.nbLimit < self.brandArray.count) {
                return self.nbLimit;
            }
        }
        return self.brandArray.count;
    } else if (self.brandIdList) {
        return self.brandIdList.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type != BrandListTableViewCellTypeTop) {
        BrandListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrandListCell" forIndexPath:indexPath];
        
        FZBrand *brand = self.brandArray[indexPath.row];
        cell.delegate = self;
        
        if (self.brandArray) {
            cell.brandId = brand.brandId;
        }
        return cell;
    } else {
        TopBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopBrandCell" forIndexPath:indexPath];
        return cell;
    }

}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.brandArray) {
        if (self.type != BrandListTableViewCellTypeTop) {
            BrandListCollectionViewCell *cellBrand = (BrandListCollectionViewCell *)cell;
            cellBrand.spinner.hidden = YES;
            FZBrand *brand = self.brandArray[indexPath.row];
            [cellBrand setDataWith:brand];
        } else {
            TopBrandCollectionViewCell *cellBrand = (TopBrandCollectionViewCell *)cell;
            [cellBrand setupWithBrand:self.brandArray[indexPath.row]];
        }
    } else if (self.brandIdList) {
        BrandListCollectionViewCell *cellBrand = (BrandListCollectionViewCell *)cell;
        [cellBrand setDataBrandBy:self.brandIdList[indexPath.row]];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == BrandListTableViewCellTypeTop) {
        return CGSizeMake(180.0f, 146.0f);
    } else {
        return CGSizeMake(180.0f, 205.0f);
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.brandArray.count > 0) {
        FZBrand *brand = self.brandArray[indexPath.row];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(brandWasClicked:type:)]) {
            [self.delegate brandWasClicked:brand type:self.type];
        }
    } else {
        BrandListCollectionViewCell *cell = (BrandListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.brand) {
           [self.delegate brandWasClicked:cell.brand type:self.type];
        }
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

#pragma mark - Button Actions

- (IBAction)viewAllButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewAllWasClickedForTitle:)]) {
        [self.delegate viewAllWasClickedForTitle:self.type];
    }
}

#pragma -mark BrandListCollectionViewCellDelegate {
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state {
    if ([self.delegate respondsToSelector:@selector(likeButtonTappedOn:WithState:)]) {
        [self.delegate likeButtonTappedOn:brand WithState:state];
    }
}

@end
