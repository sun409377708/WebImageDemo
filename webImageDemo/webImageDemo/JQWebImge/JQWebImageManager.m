//
//  JQWebImageManager.m
//  webImageDemo
//
//  Created by maoge on 16/10/11.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import "JQWebImageManager.h"
#import "CZAdditions.h"
#import "JQWebImageDownloadOperation.h"

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
    // 0. 断言
    NSAssert(completion != nil, @"必须传入完成回调");
    
    UIImage *imageCache = _imageCache[urlString];
    // 1. 内存缓存
    if (imageCache != nil) {
        NSLog(@"内存缓存");
        
        completion(imageCache);
        return;
    }
    
    
    NSString *cachePath = [self cachePathWithUrlString:urlString];
    
    imageCache = [UIImage imageWithContentsOfFile:cachePath];
    // 2. 沙盒缓存
    if (imageCache != nil) {
        NSLog(@"沙盒缓存");
        
        // 1 .设置内存缓存
        [_imageCache setObject:imageCache forKey:urlString];
        
        completion(imageCache);
        return;
    }

    // 3. 下载超时, 避免重复下载操作
    if (_operationCache[urlString] != nil) {
        NSLog(@"正在下载...");
    }
    
    NSLog(@"准备下载图片");
    // 4. 创建操作
    JQWebImageDownloadOperation *op = [JQWebImageDownloadOperation downloadOperationWithURLString:urlString cachePath:cachePath];
    
    // 5. 添加队列
    [_downLoadQueue addOperation:op];
    
    __weak typeof(JQWebImageDownloadOperation *)weakOp = op;
    [op setCompletionBlock:^{
        
        UIImage *image = weakOp.image;
        
        if (image != nil) {
            [self.imageCache setObject:image forKey:urlString];
        }
        // 下载完成后, 将对应的操作缓存清除
        [self.operationCache removeObjectForKey:urlString];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(image);
        }];
        
    }];
    
    // 6. 记录操作缓存
    [_operationCache setObject:op forKey:urlString];
}


//MD5
- (NSString *)cachePathWithUrlString:(NSString *)urlString {
    
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    //生成md5加密字符串
    NSString *fileName = [urlString cz_md5String];
    
    //返回合成的路径
    return [cacheDir stringByAppendingPathComponent:fileName];
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
