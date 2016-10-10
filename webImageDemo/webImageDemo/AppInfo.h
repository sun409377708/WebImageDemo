//
//  AppInfo.h
//  webImageDemo
//
//  Created by maoge on 16/10/10.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppInfo : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *download;

@property (nonatomic, copy) NSString *icon;

//记录内存图片下载
@property (nonatomic, strong) UIImage *image;

@end
