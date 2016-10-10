//
//  NSAttributedString+Extension.h
//  AliyPay
//
//  Created by maoge on 16/8/11.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (Extension)

+ (instancetype)imageTextWithImage:(UIImage *)image imageWH:(CGFloat)imageWH title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor spacing:(CGFloat)spacing;
@end
