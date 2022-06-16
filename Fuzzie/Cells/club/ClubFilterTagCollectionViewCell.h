//
//  ClubFilterTagCollectionViewCell.h
//  Fuzzie
//
//  Created by joma on 6/25/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubFilterTagCollectionViewCellDelegate <NSObject>

- (void)tagDeleteButtonPressed:(NSDictionary*)dict;

@end

@interface ClubFilterTagCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<ClubFilterTagCollectionViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lbTag;

@property (strong, nonatomic) NSDictionary *dict;

- (void)setCell:(NSDictionary*)dict;

@end
