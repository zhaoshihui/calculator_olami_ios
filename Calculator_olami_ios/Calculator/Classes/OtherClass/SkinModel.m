//
//  SkinModel.m
//  Calculator
//
//  Created by Scarlett on 2017/7/20.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import "SkinModel.h"
#import "SModel.h"

@interface SkinModel ()

@end

@implementation SkinModel

+(NSArray *)dataArr {
    
    
    SkinModel *model1 = [[SkinModel alloc] init];
    model1.title = @"风景";
//    model1.select = NO;
    model1.contentArr = [NSMutableArray array];
    for (SModel *model in [SModel array1]) {
        [model1.contentArr addObject:model];
    }

    
    SkinModel *model2 = [[SkinModel alloc] init];
    model2.title = @"卡通";
//    model2.select = NO;
    model2.contentArr = [NSMutableArray array];
    
    for (SModel *model in [SModel array2]) {
        [model2.contentArr addObject:model];
    }
    
    
    SkinModel *model3 = [[SkinModel alloc] init];
    model3.title = @"城市";
//    model3.select = NO;
    model3.contentArr = [NSMutableArray array];
    for (SModel *model in [SModel array3]) {
        [model3.contentArr addObject:model];
    }

    
    
    SkinModel *model4 = [[SkinModel alloc] init];
    model4.title = @"游戏";
//    model4.select = NO;
    model4.contentArr = [NSMutableArray array];
    for (SModel *model in [SModel array4]) {
        [model4.contentArr addObject:model];
    }

    
    
    return @[model1, model2, model3, model4];
}
@end
