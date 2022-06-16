//
//  FZRefreshControl.h
//  Fuzzie
//
//  Created by Alexis Creuzot on 04/07/2015.
//  Copyright © 2015 fuzzie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZRefreshControl : UIControl

- (void) containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView;
- (void) containingScrollViewDidScroll:(UIScrollView *)containingScrollView;

- (void) beginRefreshing;
- (void) endRefreshing;

@end
