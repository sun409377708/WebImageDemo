//
//  JQWebImageDownloadOperation.h
//  webImageDemo
//
//  Created by maoge on 16/10/11.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQWebImageDownloadOperation : NSOperation

+ (instancetype)downloadOperationWithURLString:(NSString *)urlString cachePath:(NSString *)cachePath;

@end
