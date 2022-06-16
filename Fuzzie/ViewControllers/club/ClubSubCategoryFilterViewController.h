//
//  ClubSubCategoryFilterViewController.h
//  
//
//  Created by joma on 6/26/18.
//

#import "FZBaseViewController.h"

@protocol ClubSubCategoryFilterViewControllerDelegate <NSObject>

-(void)filterApplied:(NSMutableArray*)selectedCategories components:(NSMutableArray*)selectedComponents;

@end

@interface ClubSubCategoryFilterViewController : FZBaseViewController

@property (weak, nonatomic) id<ClubSubCategoryFilterViewControllerDelegate> delegate;

@property (strong, nonatomic) NSDictionary *brandType;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *filters;

@property (strong, nonatomic) NSMutableArray *selectedCategories;
@property (strong, nonatomic) NSMutableArray *selectedComponents;

@end
