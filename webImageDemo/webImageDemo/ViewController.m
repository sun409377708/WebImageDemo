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
#import "AppCell.h"
#import "CZAdditions.h"
#import "UIImageView+JQWebCache.h"
static NSString *cellId = @"cellId";

@interface ViewController ()<UITableViewDataSource>

@property (nonatomic, strong) NSArray *appArray;

@property (nonatomic, strong) UITableView *tableView;

//下载队列
@property (nonatomic, strong) NSOperationQueue *downLoadQueue;

//内存缓存
@property (nonatomic, strong) NSMutableDictionary *imageCache;

//下载操作缓存
@property (nonatomic, strong) NSMutableDictionary *operationCache;

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
    
    //实例化图片缓存可变字典
    _imageCache = [NSMutableDictionary dictionary];
    
    //实例化操作缓存可变字典
    _operationCache = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //清除缓存图像 需要用字典存储
    [_imageCache removeAllObjects];
    
    //清除没有完成的下载操作
    [_downLoadQueue cancelAllOperations];
    
    //清除操作缓存
    [_operationCache removeAllObjects];
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
    
    //设置占位图片
//    cell.iconView.image = [UIImage imageNamed:@"user_default"];
    
    //测试图片管理器
    [cell.iconView jq_setImageWithUrlString:appInfo.icon];
//
    /*
    UIImage *imageCache = _imageCache[appInfo.icon];
    
     // ************ 2 避免图片重复下载, 加载内存缓存下的图片
    if (imageCache != nil) {
        NSLog(@"返回内存中的图片");
        cell.iconView.image = _imageCache[appInfo.icon];
        return cell;
    }
    
    // ************ 4 从沙盒中读取图片
    imageCache = [UIImage imageWithContentsOfFile:[self cachePathWithUrlString:appInfo.icon]];
    
    if (imageCache != nil) {
        NSLog(@"返回沙盒的数据");
        
        //沙盒中读取
        cell.iconView.image = imageCache;
        
        // ************ 4 设置内存缓存 - 第二次从沙盒取出来读到内存后, 再从内存中读取
        [_imageCache setObject:imageCache forKey:appInfo.icon];
        
        return cell;
    }
    
    // ************ 1 网络有延时, 因为无法及时获取图像, 导致cell出现复用现象, 使用占位图片
    UIImage *placehoder = [UIImage imageNamed:@"user_default"];
    cell.iconView.image = placehoder;

    NSURL *url = [NSURL URLWithString:appInfo.icon];
    
    // ************ 3 判断操作缓存, 避免因为网络过慢导致重复创建操作operation
    if (_operationCache[appInfo.icon] != nil) {
        NSLog(@"正在玩命加载");
        return cell;
    }
    
    // 1 .创建操作
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        //模拟第一张图片网络很慢
        if (indexPath.row == 0) {
            [NSThread sleepForTimeInterval:5];
        }
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *image = [UIImage imageWithData:data];
        // ************ 2 可变字典记录下载的图片, 有可能图片地址为空, 返回nil对象
        // 所以需要进行判断
        if (image != nil) {
            [self.imageCache setObject:image forKey:appInfo.icon];
            // ************ 4 将图像保存到沙盒
            [data writeToFile:[self cachePathWithUrlString:appInfo.icon] atomically:YES];
        }
        
        // ************ 3 下载完成后, 将对应的操作缓存清除
        [self.operationCache removeObjectForKey:appInfo.icon];
        
        //主线程更新
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSLog(@"操作数%zd +++++ 操作缓存池%@", self.downLoadQueue.operationCount, self.operationCache);
            cell.iconView.image = image;
        }];
    }];
    
    // 2. 添加队列
    [_downLoadQueue addOperation:op];
    
    // ************ 3 记录操作缓存
    [_operationCache setObject:op forKey:appInfo.icon];
    */
    return cell;
    
}

- (NSString *)cachePathWithUrlString:(NSString *)urlString {
    
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    //生成md5加密字符串
    NSString *fileName = [urlString cz_md5String];
    
    //返回合成的路径
    return [cacheDir stringByAppendingPathComponent:fileName];
}

@end
