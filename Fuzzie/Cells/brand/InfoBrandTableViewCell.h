//
//  InfoBrandTableViewCell.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/17/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InfoBrandTableViewCellDelegate <NSObject>
- (void)cellInfoTapped:(NSUInteger)typeInfoCell;
@end


@interface InfoBrandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UIView *topSeparator;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UILabel *infoBrandLabel;
@property (assign, nonatomic) NSUInteger typeCell;
@property (weak, nonatomic) id<InfoBrandTableViewCellDelegate> delegate;



typedef enum : NSUInteger {
    InfoBrandTypeCondition,
    InfoBrandTypeRedeem,
    InfoBrandTypeStoreLocator,
} InfoBrandType;

@end
