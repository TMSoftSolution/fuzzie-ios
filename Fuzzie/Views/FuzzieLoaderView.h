//
//  FuzzieLoaderView.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/25/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"
@interface FuzzieLoaderView : UIView
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *fuzzieLoader;

- (void)startLoader;
- (void)stopLoader;
@end
