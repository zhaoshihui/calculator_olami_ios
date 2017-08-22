//
//  SkinModel.h
//  Calculator
//
//  Created by Scarlett on 2017/7/20.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkinModel : NSObject
@property (nonatomic, assign) BOOL select;
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) NSString *title;

+(NSArray *)dataArr;

@end
