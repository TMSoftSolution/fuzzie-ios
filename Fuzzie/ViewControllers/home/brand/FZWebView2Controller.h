//
//  FZWebView2Controller.h
//  Fuzzie
//
//  Created by Kévin la Rosa on 2/19/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "FZStore.h"

@interface FZWebView2Controller : UIViewController
@property (strong, nonatomic) NSString *URL;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) NSString *titleHeader;
@property (assign, nonatomic) BOOL showLoading;


@end
