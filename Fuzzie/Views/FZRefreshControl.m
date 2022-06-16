//
//  FZRefreshControl.m
//  Fuzzie
//
//  Created by Alexis Creuzot on 04/07/2015.
//  Copyright © 2015 fuzzie. All rights reserved.
//

#import "FZRefreshControl.h"

@implementation FZRefreshControl
{
	NSMutableArray * _images;
	UIImageView * _imageView;
	
	UIEdgeInsets _previousInsets;
	UIScrollView * _scrollView;
}

- (nonnull instancetype)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame]){
		
		CGRect rect = self.bounds;
		rect.origin.x -= 6;
		rect.size.height += 6;
		_imageView = [[UIImageView alloc] initWithFrame:rect];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		_images = @[].mutableCopy;
        for (NSInteger i=0; i<100; i++) {
			[_images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loader%d",(int)i]]];
        };
		[_imageView setImage:_images.firstObject];
		[_imageView setAnimationImages:_images];
		[_imageView setAnimationDuration:3.3];
		
		_imageView.transform = CGAffineTransformMakeScale(.01, .01);
		
		[self addSubview:_imageView];
	}
	return self;
}


- (void)containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView
{
	CGFloat minOffsetToTriggerRefresh = self.bounds.size.height + 40;
	if (containingScrollView.contentOffset.y <= -minOffsetToTriggerRefresh) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
		[self beginRefreshing];
		_scrollView = containingScrollView;
		
		_previousInsets = containingScrollView.contentInset;
		UIEdgeInsets insets = containingScrollView.contentInset;
		insets.top = self.bounds.size.height;
		
		CGPoint contentOffset = containingScrollView.contentOffset;
		[UIView animateWithDuration:0.2 animations:^{
			 [containingScrollView setContentInset:insets];
			 [containingScrollView setContentOffset:contentOffset];
		 } completion:^(BOOL finished) {
             [_scrollView setScrollEnabled:NO];
         }];
	}
}

- (void) containingScrollViewDidScroll:(UIScrollView *)containingScrollView
{
	CGFloat ratio = -containingScrollView.contentOffset.y/self.bounds.size.height;
	ratio = MIN(1.2,ratio);
	ratio = MAX(0, ratio);
	_imageView.transform = CGAffineTransformMakeScale(ratio, ratio);
	
}

- (void)beginRefreshing
{
	[_imageView startAnimating];
}

- (void)endRefreshing
{
    [_scrollView setScrollEnabled:YES];
	[UIView animateWithDuration:0.25 animations:^{
		[_scrollView setContentInset:_previousInsets];
	} completion:^(BOOL finished) {
		[_imageView stopAnimating];
	}];
}

@end
