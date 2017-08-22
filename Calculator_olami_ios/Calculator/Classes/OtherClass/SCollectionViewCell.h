//
//  SCollectionViewCell.h
//  Calculator
//
//  Created by Scarlett on 2017/7/20.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SModel.h"
#import "SkinModel.h"

@interface SCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;

@property (nonatomic, strong) SModel *model;
@property (nonatomic, strong) SkinModel *smodel;
@property (nonatomic, assign) BOOL select;

@end
