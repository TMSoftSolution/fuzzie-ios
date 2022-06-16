//
//  ClubStoreCollectionViewCell.h
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubStoreCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivStore;
@property (weak, nonatomic) IBOutlet TKRoundedView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *lbBrandName;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreName;
@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;

@property (strong, nonatomic) NSDictionary *dict;

- (void)setCell:(NSDictionary*)dict;

@end
