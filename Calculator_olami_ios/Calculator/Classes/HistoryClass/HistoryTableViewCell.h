//
//  HistoryTableViewCell.h
//  Calculator
//
//  Created by Scarlett on 2017/7/19.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Equation.h"

@interface HistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;


@property (nonatomic, strong) Equation *equationModel;

@end
