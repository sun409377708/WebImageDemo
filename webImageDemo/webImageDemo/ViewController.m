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
#import "UIImageView+WebCache.h"
#import "AppCell.h"

static NSString *cellId = @"cellId";

@interface ViewController ()<UITableViewDataSource>

@property (nonatomic, strong) NSArray *appArray;

@property (nonatomic, strong) UITableView *tableView;

//下载队列
@property (nonatomic, strong) NSOperationQueue *downLoadQueue;


@end

@implementation ViewController

- (void)loadView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [_tableView registerNib:[UINib nibWithNibName:@"AppCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    self.view = _tableView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    _downLoadQueue = [[NSOperationQueue alloc] init];
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
        
        //异步请求, 需要刷新数据
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.appArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    AppInfo *appInfo = _appArray[indexPath.row];
    cell.nameLabel.text = appInfo.name;
    cell.downLabel.text = appInfo.download;
    
     // ************ 2 避免图片重复下载, 加载内存缓存下的图片
    if (appInfo.image != nil) {
        cell.iconView.image = appInfo.image;
        return cell;
    }
    
    
    // ************ 1 网络有延时, 因为无法及时获取图像, 导致cell出现复用现象, 使用占位图片
    UIImage *placehoder = [UIImage imageNamed:@"user_default"];
    cell.iconView.image = placehoder;

    
    NSURL *url = [NSURL URLWithString:appInfo.icon];
 
    //不用SDWebImage
    // 1 .创建操作
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        [NSThread sleepForTimeInterval:1];//模拟延时
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *image = [UIImage imageWithData:data];
        
        // ************ 2.1 模型记录下载的图片
        appInfo.image = image;
        
        //主线程更新
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.iconView.image = image;
        }];
    }];
    
    // 2. 添加队列
    [_downLoadQueue addOperation:op];
    
    return cell;
    
}

@end
