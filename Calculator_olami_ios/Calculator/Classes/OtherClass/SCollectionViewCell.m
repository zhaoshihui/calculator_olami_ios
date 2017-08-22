//
//  SCollectionViewCell.m
//  Calculator
//
//  Created by Scarlett on 2017/7/20.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import "SCollectionViewCell.h"

@interface SCollectionViewCell ()
@end

@implementation SCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    


}


- (void)setModel:(SModel *)model {
    _model = model;
    _picImageView.image = [UIImage imageNamed:_model.content];
    
    if (_model.select == NO) {
        _chooseImageView.image = [UIImage imageNamed:@"duihao.png"];
    }else{
        _chooseImageView.image = [UIImage imageNamed:@"duihao1.png"];
    }
    

}








@end
