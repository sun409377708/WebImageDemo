//
//  UIImage+Extension.h
//  生活圈story
//
//  Created by maoge on 16/9/8.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

//等比例绘制缩放
- (instancetype)scaleToWidth:(CGFloat)width;

- (instancetype)scaleToWidth:(CGFloat)width height:(CGFloat)height;

//等比例大小缩放
- (CGSize)scaleOriginalImageWidth:(CGFloat )imageWidth height:(CGFloat)imageHeight;

//保存图片至沙盒
- (void)saveToBoxWithName:(NSString *)imageName;

@end
