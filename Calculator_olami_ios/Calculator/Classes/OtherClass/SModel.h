//
//  SModel.h
//  Calculator
//
//  Created by Scarlett on 2017/7/20.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SModel : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL select;

+(NSArray *)array1;
+(NSArray *)array2;
+(NSArray *)array3;
+(NSArray *)array4;

@end
