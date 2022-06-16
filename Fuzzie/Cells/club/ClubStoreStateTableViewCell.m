//
//  ClubStoreStateTableViewCell.m
//  Fuzzie
//
//  Created by joma on 9/20/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import "ClubStoreStateTableViewCell.h"

@implementation ClubStoreStateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCell:(NSDictionary *)dict moreStores:(NSArray *)moreStores{
    
    if (dict) {
  
        self.dict = dict;
        self.moreStores = moreStores;
        
        self.lbStoreName.text = dict[@"store_name"];
        if (dict[@"distance"] && ![dict[@"distance"] isKindOfClass:[NSNull class]]) {
            
            float distance = [dict[@"distance"] floatValue];
            self.lbDistance.text = [NSString stringWithFormat:@"%.2f km", distance];
            
        } else {
            
            self.lbDistance.text = @"";
        }
        
        if ([dict[@"closing_soon"] boolValue]) {
            
            [CommonUtilities setView:self.lbOpen withBackground:[UIColor colorWithHexString:@"#F5A623"] withRadius:6.0f];
            self.lbOpen.text = @"   CLOSING SOON   ";
            self.lbOpenState.text = [NSString stringWithFormat:@"AT %@ TODAY", dict[@"close_time"]];
            
        } else {
            
            if ([dict[@"open_now"] boolValue]) {
                
                [CommonUtilities setView:self.lbOpen withBackground:[UIColor colorWithHexString:@"#50AE32"] withRadius:6.0f];
                self.lbOpen.text = @"   OPEN NOW   ";
                self.lbOpenState.text = [NSString stringWithFormat:@"UNTIL %@ TODAY", dict[@"close_time"]];
                
                
            } else {
                
                [CommonUtilities setView:self.lbOpen withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:6.0f];
                self.lbOpen.text = @"   CLOSE   ";
                self.lbOpenState.text = [NSString stringWithFormat:@"OPEN AT %@ TOMORROW", dict[@"open_time"]];
            }
            
        }

        if (moreStores) {
            
            [self.btnMore setTitle:[NSString stringWithFormat:@"%ld more stores", moreStores.count] forState:UIControlStateNormal];
            self.btnMore.enabled = YES;
            
        } else {
            
            [self.btnMore setTitle:@"" forState:UIControlStateNormal];
            self.btnMore.enabled = NO;
        }
        
    }
}

- (IBAction)moreButtonPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(moreButtonPressed)]) {
        [self.delegate moreButtonPressed];
    }
}

@end
