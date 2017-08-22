//
//  CulculatorViewController.h
//  Culculator
//
//  Created by Scarlett on 2017/6/29.
//  Copyright © 2017年 Scarlett Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CulculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *showTextView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
- (IBAction)recordButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
- (IBAction)tapAction:(UIButton *)sender;







@end
