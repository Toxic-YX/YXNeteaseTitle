//
//  YXBaseViewController.h
//  NeteaseTitle
//
//  Created by Rookie_YX on 16/10/25.
//  Copyright © 2016年 Rookie_YX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXBaseViewController : UIViewController
/**
 *  url端口
 */
@property(nonatomic,copy) NSString *urlString;

/**
 当前页码
 */
@property (nonatomic,assign) NSInteger index;

/**
 当前页的标题
 */
@property (nonatomic, strong) NSMutableArray *pageStr;

@end
