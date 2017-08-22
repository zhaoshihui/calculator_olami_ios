//
//  HistoryTableViewCell.m
//  Calculator
//
//  Created by Scarlett on 2017/7/19.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


    }
    return self;
}

- (void)setEquationModel:(Equation *)equationModel {
    _equationModel = equationModel;
    //    self.saveLabel.text = eqModel.content;
    self.saveLabel.text = _equationModel.resultstr;
    self.backView.layer.shadowOffset =CGSizeMake(0, 15);
    self.backView.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.backView.layer.shadowOpacity = .9f;
    self.backView.layer.masksToBounds = NO;
        

}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
