//
//  ClubStoreLocationTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/12/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubStoreLocationTableViewCellDelegate <NSObject>

- (void)storeLocationCellTapped:(NSDictionary*)dict;

@end

@interface ClubStoreLocationTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubStoreLocationTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UILabel *lbStoreName;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;

- (void)setCellWith:(NSDictionary*) dict;

@end
