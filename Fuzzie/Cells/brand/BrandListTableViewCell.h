//
//  BrandListTableViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    BrandListTableViewCellTypeRecommended,
    BrandListTableViewCellTypeClub,
    BrandListTableViewCellTypeTrending,
    BrandListTableViewCellTypeNew,
    BrandListTableViewCellTypeTop,
    BrandListTableViewCellTypeOtherAlsoBought
    
} BrandListTableViewCellType;

@protocol BrandListTableViewCellDelegate <NSObject>

- (void)brandWasClicked:(FZBrand *)brand type:(BrandListTableViewCellType)type;

@optional
- (void)viewAllWasClickedForTitle:(BrandListTableViewCellType)type;
- (void)likeButtonTappedOn:(FZBrand *)brand WithState:(BOOL)state;

@end

@interface BrandListTableViewCell : UITableViewCell

@property (weak, nonatomic) id<BrandListTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSArray *brandArray;
@property (weak, nonatomic) IBOutlet UIButton *viewAllButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) int nbLimit;
@property (assign, nonatomic) BrandListTableViewCellType type;

- (void)setCell:(NSArray*)brandArray title:(NSString*)title limit:(int)limit type:(BrandListTableViewCellType)type showViewAll:(BOOL)showViewAll;

- (void)getOtherBrandsBy:(NSString *)brandId;
- (void)startLoader;
- (void)stopLoader;

@end
