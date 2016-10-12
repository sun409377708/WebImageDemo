//
//  UIImageView+JQWebCache.m
//  webImageDemo
//
//  Created by maoge on 16/10/12.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import "UIImageView+JQWebCache.h"
#import "JQWebImageManager.h"
#import <objc/runtime.h>

const char *jq_URLStringKey = "jq_URLStringKey";

@implementation UIImageView (JQWebCache)

- (void)jq_setImageWithUrlString:(NSString *)urlString {
    
    // 判断上一次记录的与本次如果不一样, 则下载新的图像, 将之前的下载操作取消
    if (![self.jq_urlString isEqualToString:urlString] && self.jq_urlString != nil) {
    
        [[JQWebImageManager sharedManager] cancelImageDownloadWithUrlString:self.jq_urlString];
    }
    //属性记录
    self.jq_urlString = urlString;
    //下载之前, 设置为nil
    self.image = nil;
    
    [[JQWebImageManager sharedManager] downloadImageWithUrlStrng:urlString completion:^(UIImage *image) {
        //下载完成. 将jq_urlString 设置为nil
        self.jq_urlString = nil;
        
        self.image = image;
    }];
}



- (NSString *)jq_urlString {
    //利用运行时记录属性
    return objc_getAssociatedObject(self, jq_URLStringKey);
}

- (void)setJq_urlString:(NSString *)jq_urlString {
    
    objc_setAssociatedObject(self, jq_URLStringKey, jq_urlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
