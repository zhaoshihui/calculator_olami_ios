//
//  SModel.m
//  Calculator
//
//  Created by Scarlett on 2017/7/20.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import "SModel.h"

@implementation SModel

//风景
+(NSArray *)array1 {
    SModel *mmodel1 = [[SModel alloc] init];
    mmodel1.content = @"1423794199415.jpg";
//    mmodel1.select = NO;
    SModel *mmodel2 = [[SModel alloc] init];
    mmodel2.content = @"3186-150119164122-50.jpg";
//    mmodel2.select = NO;
    SModel *mmodel3 = [[SModel alloc] init];
    mmodel3.content = @"DUQ1F1CAE4NN.jpg";
//    mmodel3.select = NO;
    SModel *mmodel4 = [[SModel alloc] init];
    mmodel4.content = @"u=631465196,1018701104&fm=26&gp=0.jpg";
//    mmodel4.select = NO;
    return @[mmodel1,mmodel2,mmodel3,mmodel4];
}

//卡通
+(NSArray *)array2 {
    SModel *mmodel1 = [[SModel alloc] init];
    mmodel1.content = @"1483438321894.jpg";
//    mmodel1.select = NO;
    SModel *mmodel2 = [[SModel alloc] init];
    mmodel2.content = @"20150921002612_FUza8.jpeg";
//    mmodel2.select = NO;
    SModel *mmodel3 = [[SModel alloc] init];
    mmodel3.content = @"20150921002754_scZzn.jpeg";
//    mmodel3.select = NO;
    SModel *mmodel4 = [[SModel alloc] init];
    mmodel4.content = @"u=725175699,1222476565&fm=214&gp=0.jpg";
//    mmodel4.select = NO;
    return @[mmodel1,mmodel2,mmodel3,mmodel4];
}

//城市
+(NSArray *)array3 {
    SModel *mmodel1 = [[SModel alloc] init];
    mmodel1.content = @"t0105135ad8fb3d04f1.jpg";
//    mmodel1.select = NO;
    SModel *mmodel2 = [[SModel alloc] init];
    mmodel2.content = @"t01aff42f0c12df80a5.jpg";
//    mmodel2.select = NO;

    return @[mmodel1,mmodel2];

}

//游戏
+(NSArray *)array4 {
    SModel *mmodel1 = [[SModel alloc] init];
    mmodel1.content = @"139-161110152510.jpg";
//    mmodel1.select = NO;
    SModel *mmodel2 = [[SModel alloc] init];
    mmodel2.content = @"20160902025453826.jpg";
//    mmodel2.select = NO;
    SModel *mmodel3 = [[SModel alloc] init];
    mmodel3.content = @"wangzherongyao056.jpg";
//    mmodel3.select = NO;
    return @[mmodel1,mmodel2,mmodel3];

}


@end
