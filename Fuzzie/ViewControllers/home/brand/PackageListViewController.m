//
//  PackageListViewController.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 6/12/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "PackageListViewController.h"
#import "PackageTableViewCell.h"

#import "CardViewController.h"
#import "Masonry.h"
#import "PackageViewController.h"

@interface PackageListViewController () <UITableViewDataSource, UITableViewDelegate, PackageTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerUpLabel;
@property (weak, nonatomic) IBOutlet TKRoundedView *powerupContainer;
@property (weak, nonatomic) IBOutlet UILabel *cashbackLabel;
@property (weak, nonatomic) IBOutlet TKRoundedView *cashbackContainer;
@property (weak, nonatomic) IBOutlet UIView *cashbaclkView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackViewHeightAnchor;
@property (weak, nonatomic) IBOutlet UIImageView *ivPowerUp;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashbackContainerWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *powerupContainerWidthConstraint;

@property (strong, nonatomic) IBOutlet UIView *giftCardHeaderView;

@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftCardPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftCardNameLabel;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftViewHeightAnchor;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *categoryArray;


- (IBAction)backButtonPressed:(id)sender;
- (IBAction)giftButtonPressed:(id)sender;

@end

@implementation PackageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyling];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)giftButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"pushToBrandCardGift" sender:self.brand];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.categoryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *categoryDict = self.categoryArray[section];
    NSArray *serviceArray = categoryDict[@"services"];
    return serviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *categoryDict = self.categoryArray[indexPath.section];
    NSArray *serviceArray = categoryDict[@"services"];
    NSDictionary *serviceDict = serviceArray[indexPath.row];
    
    PackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackageCell" forIndexPath:indexPath];
    cell.packageDict = serviceDict;
    cell.delegate = self;
    cell.packageNameLabel.text = serviceDict[@"name"];
    
    if (serviceDict[@"discounted_price"]) {
        
        CGFloat originalPrice = [serviceDict[@"price"][@"value"] floatValue];
        CGFloat discountedPrice = [serviceDict[@"discounted_price"] floatValue];
        
        cell.packagePriceLabel.text = [NSString stringWithFormat:@"%@%.0f",serviceDict[@"price"][@"currency_symbol"], discountedPrice];
        
        if (originalPrice == discountedPrice) {
            cell.packageOriginalPriceLabel.text = @"";
        } else {
            cell.packageOriginalPriceLabel.text = [NSString stringWithFormat:@"%@%.0f", serviceDict[@"price"][@"currency_symbol"], [serviceDict[@"price"][@"value"] floatValue]];
            NSAttributedString *theAttributedString = [[NSAttributedString alloc] initWithString:cell.packageOriginalPriceLabel.text
                                                                                      attributes:@{NSStrikethroughStyleAttributeName:
                                                                                                       [NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
            cell.packageOriginalPriceLabel.attributedText = theAttributedString;
        }
        
    } else {
        cell.packagePriceLabel.text = [NSString stringWithFormat:@"%@%.0f",serviceDict[@"price"][@"currency_symbol"], [serviceDict[@"price"][@"value"] floatValue]];
        cell.packageOriginalPriceLabel.text = @"";
    }
    
    cell.packageDescriptionLabel.text = serviceDict[@"description"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSDictionary *categoryDict = self.categoryArray[section];
    return categoryDict[@"name"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *categoryDict = self.categoryArray[section];
    NSArray *services = categoryDict[@"services"];
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    
    if (sectionTitle) {
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 65.0f)];
        sectionView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, tableView.frame.size.width-30.0f, 15.0f)];
        headerLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0f];
        headerLabel.text = sectionTitle;
        headerLabel.textColor = [UIColor colorWithHexString:@"#424242"];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f+15.0f+5.0f, tableView.frame.size.width-30.0f, 15.0f)];
        numberLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
        numberLabel.textColor = [UIColor colorWithHexString:@"#ADADAD"];
        
        if (services.count == 1) {
            numberLabel.text = [NSString stringWithFormat:@"%d Package",(int)services.count];
        } else {
            numberLabel.text = [NSString stringWithFormat:@"%d Packages",(int)services.count];
        }
        
        [sectionView addSubview:headerLabel];
        [sectionView addSubview:numberLabel];
        
        return sectionView;
        
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    
    if (sectionTitle) {
        return 65.0f;
    } else {
        return 0.0f;
    }
}

#pragma mark - UITableViewCellDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *categoryDict = self.categoryArray[indexPath.section];
    NSArray *serviceArray = categoryDict[@"services"];
    NSDictionary *serviceDict = serviceArray[indexPath.row];

    
    [self performSegueWithIdentifier:@"pushToPackage"
                              sender:@{@"brand":self.brand,@"packageDict":serviceDict}];
    
}

#pragma mark - PackageTableViewCellDelegate

- (void)packageCellDidPressViewMoreForPackage:(NSDictionary *)packageDict {
}

#pragma mark - Helper Functions

- (void)setStyling {
    
    self.tableView.tableHeaderView = nil;
    self.tableView.tableFooterView = nil;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 78.0;
    
    [CommonUtilities setView:self.brandImageView withCornerRadius:2.5f];
    [CommonUtilities setView:self.cashbaclkView withCornerRadius:5.0f];
    self.cashbaclkView.layer.cornerRadius = 5.0f;
    self.cashbaclkView.layer.masksToBounds = YES;
    
    if (self.brand) {
        
        self.categoryArray = [NSMutableArray new];
        
        if (self.brand.serviceCategories && self.brand.services) {
            for (NSDictionary *categoryDict in self.brand.serviceCategories) {
                NSMutableArray *serviceArray = [NSMutableArray new];
                for (NSDictionary *serviceDict in self.brand.services) {
              
                    NSArray *serviceCategoryIds = serviceDict[@"service_category_ids"];
                    if (serviceCategoryIds.count > 0) {
                        for (NSNumber *serviceCategoryId in serviceCategoryIds) {
                            if ([serviceCategoryId isEqual:categoryDict[@"id"]]) {
                                [serviceArray addObject:serviceDict];
                                break;
                            }
                            
                        }
                    }
                }
                
                if (serviceArray.count > 0) {
                    NSMutableDictionary *categorySectionDict = [categoryDict mutableCopy];
                    [categorySectionDict setObject:serviceArray forKey:@"services"];
                    [self.categoryArray addObject:categorySectionDict];
                }
            }
            
        }
        
        NSMutableArray *noCategoryServices = [NSMutableArray new];
        for (NSDictionary *serviceDict in self.brand.services) {
            NSArray *categoryArray = serviceDict[@"service_category_ids"];
            if (categoryArray.count == 0) {
                [noCategoryServices addObject:serviceDict];
            }
        }
        
        if (noCategoryServices.count > 0) {
            NSDictionary *noCategoryDict = @{ @"services": noCategoryServices };
            [self.categoryArray insertObject:noCategoryDict atIndex:0];
        }
        
        [self.tableView reloadData];
        self.headerLabel.text = [self.brand.name uppercaseString];
        
        if (self.brand.cashbackPercentage && self.brand.powerupPercentage) {
            
            NSNumber *cashbackPercent = self.brand.cashbackPercentage;
            NSNumber *powerupPercent = self.brand.powerupPercentage;
               
            if (cashbackPercent.floatValue + powerupPercent.floatValue > 0) {
                
                self.cashbackViewHeightAnchor.constant = 80;
                [self.giftCardHeaderView setFrame:CGRectMake(0, 0, self.giftCardHeaderView.frame.size.width, 112)];
                
                if (cashbackPercent.floatValue > 0 && powerupPercent.floatValue > 0) {
                    
                    [self roundedCashbackContainer];
                    [self roundedPowerupContainer];
                    
                } else {
                    
                    if (cashbackPercent.floatValue > 0) {
                        
                        [self fullRoundedCashbackContainer];
                        
                    } else if (powerupPercent.floatValue > 0){
                        
                        [self fullRoundedPowerupContainer];
                    }
                }
                
                if (cashbackPercent.floatValue > 0) {
                    self.cashbackLabel.attributedText = [CommonUtilities getFormattedCashbackPercentage:cashbackPercent fontSize:13 decimalFontSize:13];
                    self.cashbackContainerWidthConstraint.priority = 200;
                    self.cashbackContainer.hidden = NO;
                } else {
                    self.cashbackLabel.text = @"";
                    self.cashbackContainerWidthConstraint.priority = 999;
                    self.cashbackContainer.hidden = YES;
                }
                if (powerupPercent.floatValue > 0) {
                    self.powerUpLabel.attributedText = [CommonUtilities getFormattedPowerUpPercentage:powerupPercent fontSize:13 decimalFontSize:13];
                    self.powerupContainerWidthConstraint.priority = 200;
                    self.powerupContainer.hidden = NO;
        
                } else {
                    self.powerUpLabel.text = @"";
                    self.powerupContainerWidthConstraint.priority = 999;
                    self.powerupContainer.hidden = YES;
                    
                }
            } else {
                self.cashbackViewHeightAnchor.constant = 0;
                self.cashbackLabel.text = @"";
                self.cashbackContainer.hidden = YES;
                self.powerUpLabel.text = @"";
                self.powerupContainer.hidden = YES;
            }
            
            NSArray *giftCards = self.brand.giftCards;
            
            self.giftView.translatesAutoresizingMaskIntoConstraints = NO;
            if (giftCards && giftCards.count > 0) {
                self.giftViewHeightAnchor.constant = 165;
                [self.giftCardHeaderView setFrame:CGRectMake(0, 0, self.giftCardHeaderView.frame.size.width, 277)];
                
                NSURL *imageUrl = [NSURL URLWithString:self.brand.backgroundImage];
                [self.brandImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"brand-placeholder"]];
                
                NSDictionary *firstGiftCard = [giftCards firstObject];
                NSDictionary *lastGiftCard = [giftCards lastObject];
                
                self.giftCardPriceLabel.text = [NSString stringWithFormat:@"%@%.0f - %@%.0f", firstGiftCard[@"price"][@"currency_symbol"], [firstGiftCard[@"price"][@"value"] floatValue], lastGiftCard[@"price"][@"currency_symbol"], [lastGiftCard[@"price"][@"value"] floatValue]];
                self.giftCardNameLabel.text = [NSString stringWithFormat:@"%@ Giftcard",self.brand.name];
                
                
            } else {
                self.giftViewHeightAnchor.constant = 0;
            }
            
            self.tableView.tableHeaderView = self.giftCardHeaderView;
            
        } else {
            self.cashbackViewHeightAnchor.constant = 0;
            self.cashbackLabel.text = @"";
            self.cashbackContainer.hidden = YES;
            self.powerUpLabel.text = @"";
            self.powerupContainer.hidden = YES;
        }
        
    }
}

- (void)roundedCashbackContainer {
    
    self.cashbackContainer.roundedCorners = TKRoundedCornerTopLeft | TKRoundedCornerBottomLeft;
    self.cashbackContainer.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainer.cornerRadius = 2.0f;
}

- (void)fullRoundedCashbackContainer{
    
    self.cashbackContainer.roundedCorners = TKRoundedCornerAll;
    self.cashbackContainer.fillColor = [UIColor colorWithHexString:@"#3B93DA"];
    self.cashbackContainer.cornerRadius = 2.0f;
}

- (void)roundedPowerupContainer{
    
    self.powerupContainer.roundedCorners = TKRoundedCornerTopRight | TKRoundedCornerBottomRight;
    self.powerupContainer.drawnBordersSides =  TKDrawnBorderSidesTop | TKDrawnBorderSidesRight | TKDrawnBorderSidesBottom;
    self.powerupContainer.fillColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.powerupContainer.cornerRadius = 2.0f;
    self.powerupContainer.borderWidth = 1.0f;
    
    if ([UserController sharedInstance].currentUser.powerUpExpiryDate || [self.brand.powerUp boolValue]) {
        self.powerupContainer.borderColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lightning-icon"];
    } else {
        self.powerupContainer.borderColor = [UIColor colorWithHexString:@"#939393"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#939393"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lighting-icon-grey"];
    }
    
}

- (void)fullRoundedPowerupContainer{
    
    self.powerupContainer.roundedCorners = TKRoundedCornerAll;
    self.powerupContainer.fillColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.powerupContainer.cornerRadius = 2.0f;
    self.powerupContainer.borderWidth = 1.0f;
    
    if ([UserController sharedInstance].currentUser.powerUpExpiryDate || [self.brand.powerUp boolValue]) {
        self.powerupContainer.borderColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#3B93DA"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lightning-icon"];
    } else {
        self.powerupContainer.borderColor = [UIColor colorWithHexString:@"#939393"];
        self.powerUpLabel.textColor = [UIColor colorWithHexString:@"#939393"];
        self.ivPowerUp.image = [UIImage imageNamed:@"lighting-icon-grey"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushToBrandCardGift"]) {
        if ([segue.destinationViewController isKindOfClass:[CardViewController class]]) {
            CardViewController *cardViewController = (CardViewController *)segue.destinationViewController;
            cardViewController.hidesBottomBarWhenPushed = YES;
            if (sender){
                if ([sender isKindOfClass:[FZBrand class]]) {
                    cardViewController.brand = (FZBrand *)sender;
                }
            }
        }
    }
    
    if ([segue.identifier isEqualToString:@"pushToPackage"]) {
        if ([segue.destinationViewController isKindOfClass:[PackageViewController class]]) {
            PackageViewController *packageViewController = (PackageViewController *)segue.destinationViewController;
            packageViewController.hidesBottomBarWhenPushed = YES;
            if (sender){
                if ([sender isKindOfClass:[NSDictionary class]]) {
                    packageViewController.brand = [(NSDictionary *)sender objectForKey:@"brand"];
                    packageViewController.packageDict = [(NSDictionary *)sender objectForKey:@"packageDict"];
                }
            }
        }
    }
}


@end
