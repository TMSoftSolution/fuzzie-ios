//
//  ClubStoreLocationInfoView.h
//  Fuzzie
//
//  Created by joma on 6/15/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubStoreLocationInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbBrandName;
@property (weak, nonatomic) IBOutlet UILabel *lbStoreName;
@property (weak, nonatomic) IBOutlet UIImageView *ivCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;
@property (weak, nonatomic) IBOutlet UIImageView *ivBrand;

- (void)setViewWith:(NSDictionary*)dict brand:(FZBrand*)brand store:(FZStore*)store;

@end
