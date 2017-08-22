//
//  SkinTableViewCell.h
//  Calculator
//
//  Created by Scarlett on 2017/7/20.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkinTableViewCell : UITableViewCell
@property(nonatomic, copy) void(^block)(NSString *);

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) NSInteger section;

@end
