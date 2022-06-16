//
//  ClubStoreOtherLinkTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kLinkTypMoreLocation,
    kLinkTypeGrab,
    kLinkTypeQuandoo,
} kLinkType;

@protocol ClubStoreOtherLinkTableViewCellDelegate <NSObject>

- (void)otherLinkCellTapped:(NSUInteger)linkType;

@end

@interface ClubStoreOtherLinkTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubStoreOtherLinkTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *ivType;
@property (weak, nonatomic) IBOutlet UILabel *lbType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorLeftMargin;

@property (assign, nonatomic) kLinkType linkType;
- (void)setCellWithType:(NSUInteger)linkType;

@end
