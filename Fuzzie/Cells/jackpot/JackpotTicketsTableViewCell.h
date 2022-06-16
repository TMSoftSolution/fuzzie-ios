//
//  JackpotTicketsTableViewCell.h
//  Fuzzie
//
//  Created by mac on 9/24/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JackpotTicketsTableViewCellDelegate <NSObject>

- (void)liveButtonPressed;

@end

@interface JackpotTicketsTableViewCell : UITableViewCell  <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSDictionary *result;
@property (strong, nonatomic) NSArray *ticketsArray;
@property (strong, nonatomic) NSArray *prizeTicketsArray;
@property (strong, nonatomic) NSNumber *drawId;
@property (strong, nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *lbDrawTime;
@property (weak, nonatomic) IBOutlet UILabel *lbLeftTime;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *btnViewResult;
@property (weak, nonatomic) IBOutlet UILabel *lbNote;
@property (weak, nonatomic) IBOutlet UILabel *lbTicketsCount;

@property (weak, nonatomic) id<JackpotTicketsTableViewCellDelegate> delegate;
@property (assign, nonatomic) int position;

- (void)startTimer;
- (void)endTimer;
+ (CGFloat)estimateHeight:(NSDictionary*)result;
- (void)setCell:(NSDictionary*)result;

@end
