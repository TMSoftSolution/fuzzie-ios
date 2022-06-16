//
//  BannerSliderItemView.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerSliderItemView : UIView
@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UILabel *subHeader;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *shadowLayer;

@end
