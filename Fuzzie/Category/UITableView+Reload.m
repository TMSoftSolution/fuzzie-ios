//
//  UITableView+Reload.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 23/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "UITableView+Reload.h"

@implementation UITableView (Reload)


- (void)reloadRowsInSection:(NSUInteger)sectionIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation oldCount:(NSUInteger)oldCount newCount:(NSUInteger)newCount {
    
    NSUInteger minCount = MIN(oldCount, newCount);
    
    NSMutableArray *insert = [NSMutableArray array];
    NSMutableArray *delete = [NSMutableArray array];
    NSMutableArray *reload = [NSMutableArray array];
    
    for (NSUInteger row = oldCount; row < newCount; row++) {
        [insert addObject:[NSIndexPath indexPathForRow:row inSection:sectionIndex]];
    }
    
    for (NSUInteger row = newCount; row < oldCount; row++) {
        [delete addObject:[NSIndexPath indexPathForRow:row inSection:sectionIndex]];
    }
    
    for (NSUInteger row = 0; row < minCount; row++) {
        [reload addObject:[NSIndexPath indexPathForRow:row inSection:sectionIndex]];
    }
    
    [self beginUpdates];
    
    [self insertRowsAtIndexPaths:insert withRowAnimation:rowAnimation];
    [self deleteRowsAtIndexPaths:delete withRowAnimation:rowAnimation];
    [self reloadRowsAtIndexPaths:reload withRowAnimation:rowAnimation];
    
    [self endUpdates];
}

@end
