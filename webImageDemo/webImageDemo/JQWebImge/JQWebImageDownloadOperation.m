
//
//  JQWebImageDownloadOperation.m
//  webImageDemo
//
//  Created by maoge on 16/10/11.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import "JQWebImageDownloadOperation.h"

@interface JQWebImageDownloadOperation ()

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *cachePath;

@end

@implementation JQWebImageDownloadOperation

+ (instancetype)downloadOperationWithURLString:(NSString *)urlString cachePath:(NSString *)cachePath {
    
    JQWebImageDownloadOperation *op = [[self alloc] init];
    
    //记录传递过来的属性
    op.urlString = urlString;
    op.cachePath = cachePath;
    
    return op;
}

//添加到队列后会自动执行
- (void)main {
    
    [NSThread sleepForTimeInterval:3];
    // 1. 创建URL
    NSURL *url = [NSURL URLWithString:_urlString];
    
    // 2. 创建数据
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // 3. 判断data
    if (data != nil) {
        //将图片回传至调用方
        _downloadImage = [UIImage imageWithData:data];
        
        // 4. 保存沙盒
        [data writeToFile:_cachePath atomically:YES];
        
        NSLog(@"保存成功");
        self.completionBlock(); 
    }
}

@end
