//
//  YXBaseViewController.m
//  NeteaseTitle
//
//  Created by Rookie_YX on 16/10/25.
//  Copyright © 2016年 Rookie_YX. All rights reserved.
//

#import "YXBaseViewController.h"

@interface YXBaseViewController ()
@property(nonatomic,strong) NSMutableArray *arrayList;
@end

@implementation YXBaseViewController
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  UILabel *lab = [[UILabel alloc] init];
  lab.frame = CGRectMake(0, 200, self.view.frame.size.width, 35);
  lab.textAlignment = 1;
  lab.text = [NSString stringWithFormat:@"%@",self.pageStr];
  [self.view addSubview:lab];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
}
@end
