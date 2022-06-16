//
//  UITableView+Reload.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 23/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Reload)

- (void)reloadRowsInSection:(NSUInteger)sectionIndex withRowAnimation:(UITableViewRowAnimation)rowAnimation oldCount:(NSUInteger)oldCount newCount:(NSUInteger)newCount;

@end
