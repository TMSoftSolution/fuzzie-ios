//
//  ClubSearchBarTableViewCell.h
//  Fuzzie
//
//  Created by joma on 6/24/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClubSearchBarTableViewCellDelegate <NSObject>

- (void)searchButtonPressed;

@end

@interface ClubSearchBarTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ClubSearchBarTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@end
