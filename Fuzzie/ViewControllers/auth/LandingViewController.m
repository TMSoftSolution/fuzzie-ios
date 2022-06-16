//
//  LandingViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 17/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "LandingViewController.h"
@import AVKit;
@import AVFoundation;

@interface LandingViewController ()

@property (weak, nonatomic) IBOutlet UIView *videoCover;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;

@property (nonatomic, strong) AVPlayer *avplayer;

- (IBAction)joinButtonPressed:(id)sender;
- (IBAction)signinButtonPressed:(id)sender;

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.avplayer play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.avplayer pause];
}


#pragma mark - Button Actions
- (IBAction)joinButtonPressed:(id)sender {
    
    UIViewController *joinView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"JoinView"];
    [self.navigationController pushViewController:joinView animated:YES];
}

- (IBAction)signinButtonPressed:(id)sender {
    
    UIViewController *loginView = [[GlobalConstants mainStoryboard] instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController pushViewController:loginView animated:YES];
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    [self.navigationController.navigationBar setTranslucent:NO];
 
    [CommonUtilities setView:self.joinButton withBackground:[UIColor colorWithHexString:HEX_COLOR_RED] withRadius:4.0f];
    [CommonUtilities setView:self.signinButton withBackground:[UIColor whiteColor] withRadius:4.0f];
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"login" ofType:@"mp4"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [self.videoCover.layer addSublayer:avPlayerLayer];
    
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero completionHandler:nil];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
