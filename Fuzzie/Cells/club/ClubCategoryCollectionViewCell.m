//
//  ClubCategoryCollectionViewCell.m
//  Fuzzie
//
//  Created by joma on 6/22/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubCategoryCollectionViewCell.h"

@implementation ClubCategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [CommonUtilities setView:self.vCategory withBackground:[UIColor colorWithHexString:@"#F9F9F9"] withRadius:25.0f withBorderColor:[UIColor colorWithHexString:@"#F2F2F2"] withBorderWidth:1.0f];
}

- (void)setCell:(NSDictionary *)dict{
    
    if (dict) {
        
        self.dict = dict;
        
        self.lbCategory.text = dict[@"name"];
        
        if (dict[@"image_red"] && ![dict[@"image_red"] isKindOfClass:[NSNull class]]) {
            
            [self.ivCategory sd_setImageWithURL:[NSURL URLWithString:dict[@"image_red"]]];
            
        } else{
            
            self.ivCategory.image = nil;
        }
        
    } else {
        
        self.ivCategory.image = nil;
        self.lbCategory.text = @"";
    }
}

@end
