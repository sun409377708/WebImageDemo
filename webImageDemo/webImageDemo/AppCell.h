//
//  AppCell.h
//  webImageDemo
//
//  Created by maoge on 16/10/10.
//  Copyright © 2016年 maoge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@end
