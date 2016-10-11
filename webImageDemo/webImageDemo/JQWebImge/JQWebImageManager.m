//
//  JQWebImageManager.m
//  webImageDemo
//
//  Created by maoge on 16/10/11.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import "JQWebImageManager.h"

@interface JQWebImageManager ()
//下载队列
@property (nonatomic, strong) NSOperationQueue *downLoadQueue;

//内存缓存
@property (nonatomic, strong) NSMutableDictionary *imageCache;

//下载操作缓存
@property (nonatomic, strong) NSMutableDictionary *operationCache;
@end

@implementation JQWebImageManager

//加载图片
- (void)downloadImageWithUrlStrng:(NSString *)urlString completion:(void (^)(UIImage *image))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        //异步执行
        [NSThread sleepForTimeInterval:1];
        
        UIImage *image = [UIImage imageNamed:@"user_default"];
        
        //主线程更新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"执行完成回调");
            completion(image);
        });
    });
}


+ (instancetype)sharedManager {
    
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        //初始化队列
        _downLoadQueue = [[NSOperationQueue alloc] init];
        
        //实例化图片缓存可变字典
        _imageCache = [NSMutableDictionary dictionary];
        
        //实例化操作缓存可变字典
        _operationCache = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
