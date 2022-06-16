//
//  StaticMiniBannerCell.m
//  Fuzzie
//
//  Created by mac on 5/4/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "StaticMiniBannerCell.h"

@implementation StaticMiniBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
    [self addGestureRecognizer:gusture];
}

- (void)setCell:(NSDictionary *)dict{
    if (dict) {
        self.dict = dict;
            [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
    }

}

- (void)cellTapped{
    if([self.delegate respondsToSelector:@selector(miniBannerCellTapped:)]){
        [self.delegate miniBannerCellTapped:self.dict];
    }
}

@end
