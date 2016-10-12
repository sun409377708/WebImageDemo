//
//  UIImageView+JQWebCache.h
//  webImageDemo
//
//  Created by maoge on 16/10/12.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JQWebCache)

- (void)jq_setImageWithUrlString:(NSString *)urlString;


/**
 * 下载图像的 URL 字符串
 * 一个属性：分类中不能有 ivar(成员变量) / getter / setter
 */

@property (nonatomic, copy) NSString *jq_urlString;

@end
