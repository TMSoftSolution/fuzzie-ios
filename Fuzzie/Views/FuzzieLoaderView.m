//
//  FuzzieLoaderView.m
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/25/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FuzzieLoaderView.h"
#import "FLAnimatedImage.h"

@implementation FuzzieLoaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.fuzzieLoader.layer.cornerRadius = self.fuzzieLoader.frame.size.width/2.0;
    self.fuzzieLoader.layer.masksToBounds = YES;
    
    [FLAnimatedImage setLogBlock:^(NSString *logString, FLLogLevel logLevel) {
        // Using NSLog
        NSLog(@"%@", logString);
        
        // ...or CocoaLumberjackLogger only logging warnings and errors
        if (logLevel == FLLogLevelError) {
            DDLogError(@"%@", logString);
        } else if (logLevel == FLLogLevelWarn) {
            DDLogWarn(@"%@", logString);
        }
    } logLevel:FLLogLevelWarn];
    
    NSString* path = [[NSBundle mainBundle] pathForResource: @"loader" ofType: @"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile: path];
    self.fuzzieLoader.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
    
}

- (void)startLoader {
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         self.layer.opacity = 1;
                     }
                     completion:^(BOOL finished) {
                          [self.fuzzieLoader startAnimating];
                     }];
}

- (void)stopLoader {
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         self.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.fuzzieLoader stopAnimating];
                     }];
}
@end
