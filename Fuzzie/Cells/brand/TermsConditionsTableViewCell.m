//
//  TermsConditionsTableViewCell.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "TermsConditionsTableViewCell.h"

@interface TermsConditionsTableViewCell() <NSLayoutManagerDelegate>

@end


@implementation TermsConditionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.textConditionView.layoutManager.delegate = self;
}

//- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
//    return 20;
//}
@end
