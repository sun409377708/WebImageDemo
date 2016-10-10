//
//  UIImage+Extension.m
//  生活圈story
//
//  Created by maoge on 16/9/8.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (instancetype)scaleToWidth:(CGFloat)width {
    
    if (self.size.width < width) {
        return self;
    }
    
    CGFloat height = width / self.size.width * self.size.height;
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    //开启
    UIGraphicsBeginImageContext(rect.size);
    
    //绘图
    [self drawInRect:rect];
    
    
    //取图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (instancetype)scaleToWidth:(CGFloat)width height:(CGFloat)height {
    
    CGSize size = [self scaleOriginalImageWidth:width height:height];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    //开启
    UIGraphicsBeginImageContext(rect.size);
    
    //绘图
    [self drawInRect:rect];
    
    
    //取图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭
    UIGraphicsEndImageContext();
    
    return image;
    
}


- (CGSize)scaleOriginalImageWidth:(CGFloat )imageWidth height:(CGFloat)imageHeight{
    CGSize imageSize = self.size;
    
    CGFloat width;
    
    if (imageSize.width > imageWidth) {
        
        width = imageWidth;
    }else {
        width = imageSize.width;
        
    }
    
    CGFloat height = imageSize.height * width / imageSize.width;
    
    if (height >= imageHeight) {
        height = imageHeight;
     
        width = height * imageSize.width / imageSize.height;
    }
    
    return CGSizeMake(width, height);
}

//保存图像至沙盒
- (void)saveToBoxWithName:(NSString *)imageName {
    
    NSData * imageData = UIImagePNGRepresentation(self);
    NSString * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString * fullPathToFile = [paths stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    NSLog(@"fullPathToFile:%@", fullPathToFile);
    
    
    //取出
    //    NSString * path = fullPathToFile;
    //    // 二进制的数据就可以进行上传
    //    NSData * data = [NSData dataWithContentsOfFile:path];
    //    UIImage * image = [UIImage imageWithData:data];
}

@end
