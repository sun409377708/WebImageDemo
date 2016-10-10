//
//  ViewController.m
//  webImageDemo
//
//  Created by maoge on 16/10/10.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AppInfo.h"
@interface ViewController ()

@property (nonatomic, strong) NSArray *appArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)loadData {
    //https://raw.githubusercontent.com/sun409377708/WebImageDemo/master/apps.json
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlString = @"https://raw.githubusercontent.com/sun409377708/WebImageDemo/master/apps.json";
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
        
        
        NSMutableArray *arrM = [NSMutableArray array];
        //字典转模型
        for (NSDictionary *dict in responseObject) {
            AppInfo *appInfo = [[AppInfo alloc] init];
            
            [appInfo setValuesForKeysWithDictionary:dict];
            
            [arrM addObject:appInfo];
        }
        
        self.appArray = arrM;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
    }];
}

@end
