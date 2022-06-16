//
//  LocationNoMatchView.h
//  Fuzzie
//
//  Created by joma on 12/13/18.
//  Copyright © 2018 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationNoMatchViewDelegate  <NSObject>

- (void)locationNoMatchViewChangeButtonPressed;
- (void)locationNoMatchViewCancelButtonPressed;

@end

@interface LocationNoMatchView : UIView

@property (weak, nonatomic) id<LocationNoMatchViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnChange;

- (IBAction)changeButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
