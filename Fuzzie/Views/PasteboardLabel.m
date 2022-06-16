//
//  PasteboardLabel.m
//  Fuzzie
//
//  Created by mac on 5/5/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "PasteboardLabel.h"

@implementation PasteboardLabel

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

#pragma mark - UIResponderStandardEditActions
- (void)copy:(id)sender
{
    UIPasteboard *generalPasteboard = [UIPasteboard generalPasteboard];
    generalPasteboard.string = self.text;
}

@end
