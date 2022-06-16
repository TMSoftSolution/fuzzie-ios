//
//  TutoViewController.m
//  Fuzzie
//
//  Created by mac on 5/10/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import "TutoViewController.h"
#import "TAPageControl.h"

@interface TutoViewController () <TAPageControlDelegate>
@property (weak, nonatomic) IBOutlet TAPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) NSArray *buttonTitleArray;
@property (nonatomic) int stepNumber;

- (IBAction)skipButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;

@end

@implementation TutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setStyling];
    
}

- (void)initData{
    self.stepNumber = 0;
    self.buttonTitleArray = @[@"START TUTORIAL", @"NEXT STEP", @"NEXT STEP", @"NEXT STEP", @"CONTINUE"];
    [self update];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:TUTORIAL_VIEWED];
}

- (void)exitTutorial {
    
    UIViewController *notiEnableView = [self.storyboard instantiateViewControllerWithIdentifier:@"NotiEnableView"];
    [UIApplication sharedApplication].delegate.window.rootViewController = notiEnableView;
}

- (void)update{

    if (self.stepNumber == 0) {
        self.startView.hidden = NO;
        self.pageControl.hidden = YES;
    } else{
        self.startView.hidden = YES;
        self.pageControl.hidden = NO;
        [self TAPageControl:self.pageControl didSelectPageAtIndex:self.stepNumber - 1];
    }
    
    [self.nextButton setTitle:self.buttonTitleArray[self.stepNumber] forState:UIControlStateNormal];

}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageIndex = self.scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.pageControl.currentPage = pageIndex;
    [self.nextButton setTitle:self.buttonTitleArray[pageIndex + 1] forState:UIControlStateNormal];
    self.stepNumber = (int)pageIndex + 1;
}

#pragma mark - TAPageControlDelegate

- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index
{
    NSLog(@"Bullet index %ld", (long)index);
    [self.scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.scrollView.frame) * index, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame)) animated:YES];
    self.stepNumber = (int)index + 1;
}

- (void)setStyling{
    self.pageControl.dotImage = [UIImage imageNamed:@"dot-inactive"];
    self.pageControl.currentDotImage = [UIImage imageNamed:@"dot-active"];
    self.pageControl.numberOfPages = 4;
    self.pageControl.delegate = self;
    self.pageControl.hidden = YES;
}

- (IBAction)skipButtonPressed:(id)sender {
    [self exitTutorial];
}

- (IBAction)nextButtonPressed:(id)sender {
    if (++self.stepNumber == 5) {
        [self exitTutorial];
        return;
    }
    [self update];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
