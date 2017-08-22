//
//  ScaleLabel.h
//  Animations
//
//  Created by Scarlett on 2017/7/4.
//  Copyright © 2017年 Scarlett Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleLabel : UIView

/**
 *  Label's text.
 */
@property (nonatomic, strong) NSString *text;

/**
 *  Label's color.
 */
@property (nonatomic, strong) UIFont   *font;

/**
 *  The Label's scale before the animation start.
 */
@property (nonatomic, assign) CGFloat   startScale;

/**
 *  The label's scale after the animation ended.
 */
@property (nonatomic, assign) CGFloat   endScale;

/**
 *  The show label's color.
 */
@property (nonatomic, strong) UIColor  *backedLabelColor;

/**
 *  The animated label's color.
 */
@property (nonatomic, strong) UIColor  *colorLabelColor;

/**
 *  Start animation.
 */
- (void)startAnimation;

- (NSString *)addString:(NSString *)str;

@end
