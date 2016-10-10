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
    
    NSURL *url = [NSURL URLWithString:appInfo.icon];
    
    [cell.iconView sd_setImageWithURL:url];
    cell.nameLabel.text = appInfo.name;
    
    return cell;
    
}

@end
