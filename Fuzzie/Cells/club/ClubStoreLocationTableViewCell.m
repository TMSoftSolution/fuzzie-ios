//
//  ClubStoreLocationTableViewCell.m
//  Fuzzie
//
//  Created by joma on 6/12/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreLocationTableViewCell.h"

@implementation ClubStoreLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:tapGuesture];
}

- (void)setCellWith:(NSDictionary *)dict{
    
    if (dict) {
 
        self.dict = dict;
        
        if (dict[@"store_name"]) {
            
            self.lbStoreName.text = dict[@"store_name"];
            
        } else if (dict[@"name"]){
            
            self.lbStoreName.text = dict[@"name"];
            
        } else{
            
            self.lbStoreName.text = @"";
        }
        
        if (dict[@"distance"] && ![dict[@"distance"] isKindOfClass:[NSNull class]]) {
            
            float distance = [dict[@"distance"] floatValue];
            self.lbDistance.text = [NSString stringWithFormat:@"%.2f km", distance];
            
        } else {
            
            self.lbDistance.text = @"";
        }
    }
}

- (void)cellTapped{
    
    if ([self.delegate respondsToSelector:@selector(storeLocationCellTapped:)]) {
        [self.delegate storeLocationCellTapped:self.dict];
    }
}

@end
