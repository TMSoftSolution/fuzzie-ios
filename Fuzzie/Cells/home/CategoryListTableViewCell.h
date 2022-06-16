//
//  CategoryListTableViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 22/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryListTableViewCellDelegate <NSObject>

- (void)categoryWasClicked:(NSDictionary *)categoryDict;
- (void)viewAllCategoryWasClicked;

@end

@interface CategoryListTableViewCell : UITableViewCell

@property (weak, nonatomic) id<CategoryListTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSArray *categoryArray;

@end
