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

@property (nonatomic, strong) NSMutableDictionary *imageCache;

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
    
    //实例化可变字典
    _imageCache = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //清除缓存图像 需要用字典存储
    [_imageCache removeAllObjects];
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
    if (_imageCache[appInfo.icon] != nil) {
        NSLog(@"返回内存中的图片");
        cell.iconView.image = _imageCache[appInfo.icon];
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
        
        // ************ 3 可变字典记录下载的图片
        [self.imageCache setObject:image forKey:appInfo.icon];
        
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
