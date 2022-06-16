//
//  ClubStoreTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kStoreTypeRelated,
    kStoreTypeNear
} kStoreType;

@protocol ClubStoreTableViewCellDelegate <NSObject>

- (void)clubStoreCellTapped:(NSDictionary*)dict flashMode:(BOOL)flashMode;
- (void)viewAllButtonPressed:(NSArray*)array title:(NSString*)title flashMode:(BOOL)flashMode;

@end

@interface ClubStoreTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<ClubStoreTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbType;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)viewAllButtonPressed:(id)sender;

@property (strong, nonatomic) NSArray *stores;
@property (strong, nonatomic) NSArray *offers;
@property (assign, nonatomic) BOOL flashMode;

- (void)setCellWithStores:(NSArray *)stores;
- (void)setCellWithOffers:(NSArray*)offers;

@end
