//
//  ClubStoreStateTableViewCell.h
//  Fuzzie
//
//  Created by joma on 9/20/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubStoreStateTableViewCellDelegate <NSObject>

- (void)moreButtonPressed;

@end

@interface ClubStoreStateTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubStoreStateTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) NSArray *moreStores;

@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreName;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;
@property (weak, nonatomic) IBOutlet UILabel *lbOpen;
@property (weak, nonatomic) IBOutlet UILabel *lbOpenState;

- (IBAction)moreButtonPressed:(id)sender;

- (void)setCell:(NSDictionary*) dict moreStores:(NSArray*)moreStores;

@end
