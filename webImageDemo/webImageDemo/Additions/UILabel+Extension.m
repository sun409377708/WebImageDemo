//
//  UILabel+Extension.m
//  生活圈
//
//  Created by maoge on 16/8/8.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (instancetype)labelWithTitle:(NSString *)title andColor:(UIColor *)color andFontSize:(CGFloat)size {
    
    UILabel *label = [[self alloc] init];
    
    label.text = title;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:size];
    
    return label;
}

@end
