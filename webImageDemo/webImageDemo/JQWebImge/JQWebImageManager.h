//
//  JQWebImageManager.h
//  webImageDemo
//
//  Created by maoge on 16/10/11.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQWebImageManager : NSObject

//全局单例
+ (instancetype)sharedManager;

//下载方法
- (void)downloadImageWithUrlStrng:(NSString *)urlString completion:(void(^)(UIImage *image))completion;

@end
