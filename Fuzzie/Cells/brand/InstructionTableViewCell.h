//
//  InstructionTableViewCell.h
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 18/3/17.
//  Copyright © 2017 Nur Iman Izam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionTableViewCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *instructionImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bodyLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionImageViewHeightContstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *instructionImageViewTopConstraint;

@end
