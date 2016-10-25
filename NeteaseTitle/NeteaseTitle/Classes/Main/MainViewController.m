//
//  ViewController.m
//  NeteaseTitle
//
//  Created by Rookie_YX on 16/10/25.
//  Copyright © 2016年 Rookie_YX. All rights reserved.
//

#import "MainViewController.h"
#import "YXBaseViewController.h"
#import "YXTitleLable.h"
#import "UIColor+XCF.h"

#define kTitleLabelTag 1000
#define kTabLabelHeight 40
#define kTabLabelMargin 10

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface MainViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *smallScrollView;
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation MainViewController

#pragma mark - life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.titleArray = @[@"头条",@"NBA",@"时尚",@"手机",@"移动互联",@"娱乐",@"美女",@"电影",@"IT",@"科技"];
  self.title =@"网易新闻";
   [self setupChildViews];
  
  // 第一个tabButton设为选中
  YXTitleLable *titleLable = [self.smallScrollView.subviews firstObject];
  titleLable.scale =1.0;
 
  // 添加第一个控制器的view
  YXBaseViewController *firstVC =self.childViewControllers[0];
  firstVC.view.frame =self.bigScrollView.bounds;
  firstVC.pageStr = self.titleArray[0];
  [self.bigScrollView addSubview:firstVC.view];
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self viewDidLoad];
}

#pragma mark - 初始化子控件
- (void)setupChildViews {
  // 小滚动
  UIScrollView *smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, kScreenWidth,kTabLabelHeight)];
  smallScrollView.showsHorizontalScrollIndicator =NO;
  smallScrollView.showsVerticalScrollIndicator =NO;
  [self.view addSubview:smallScrollView];
  self.smallScrollView = smallScrollView;
  // 大滚动
  UIScrollView *bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kTabLabelHeight + 64, kScreenWidth,kScreenHeight - kTabLabelHeight)];
  bigScrollView.contentSize =CGSizeMake(kScreenWidth *self.titleArray.count,0);
  bigScrollView.pagingEnabled =YES;
  bigScrollView.delegate  =self;
  [self.view addSubview:bigScrollView];
  self.bigScrollView = bigScrollView;
  // YXTitlelabel按钮
  
  CGFloat labX =0;
  
  for (NSUInteger i =0; i<self.titleArray.count; i++) {
    
    CGFloat length = [self.titleArray[i]sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].width;
    CGFloat labW = length + kTabLabelMargin;
    YXTitleLable *lab = [[YXTitleLable alloc] initWithFrame:CGRectMake(labX,0, labW, kTabLabelHeight)];
    lab.text = self.titleArray[i];
    labX += labW;
    lab.userInteractionEnabled = YES;
    [lab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblClick:)]];
    lab.tag = i;
    YXBaseViewController *vc = [[YXBaseViewController alloc] init];
    vc.view.backgroundColor =[UIColor randomColor];
    vc.pageStr = self.titleArray[i];
    
    [self addChildViewController:vc];
    [self.smallScrollView addSubview:lab];
  }
  self.smallScrollView.contentSize =CGSizeMake(labX, 0);
}

- (void)lblClick:(UITapGestureRecognizer *)recognizer{
  
  YXTitleLable *titlelable = (YXTitleLable *)recognizer.view;
  CGFloat offsetX = titlelable.tag *kScreenWidth;
  CGFloat offsetY =self.bigScrollView.contentOffset.y;
  CGPoint offset =CGPointMake(offsetX, offsetY);
  [self.bigScrollView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  NSUInteger index = scrollView.contentOffset.x /kScreenWidth;
  YXTitleLable *leftLable =self.smallScrollView.subviews[index];
  CGFloat leftScale =1.0 - (int)scrollView.contentOffset.x % (int)kScreenWidth / kScreenWidth;
  leftLable.scale = leftScale;

  // 判断还没移动到最右边
  if (index <self.smallScrollView.subviews.count -1) {
    YXTitleLable *rightLable =self.smallScrollView.subviews[index+1];
    rightLable.scale =1.0 - leftScale;
  }
}
/**
 *  滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 *  滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  NSUInteger index = scrollView.contentOffset.x /kScreenWidth;
  NSLog(@"%f %zd",scrollView.contentOffset.x,index);
  // 计算滚动导航栏标题的距离
  CGFloat smallX =0;
  for (NSUInteger i =0; i<=index; i++) {
    CGFloat length = [self.titleArray[i]sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].width +kTabLabelMargin;
    if (i == index -1) { //如果是最后一个，加一半宽度
      smallX += length * 0.5;
    } else {// 其他加整个标题宽度
      smallX += length;
    }
  }
  
  if (smallX <kScreenWidth * 0.5) {// smallScrollView滑到最前面
    smallX = 0;
  } else if (smallX + kScreenWidth *0.5 > self.smallScrollView.contentSize.width) { // smallScrollView滑到最后面
    smallX = self.smallScrollView.contentSize.width - kScreenWidth;
  } else {
    smallX = smallX - kScreenWidth *0.5;
  }
  
  [self.smallScrollView setContentOffset:CGPointMake(smallX,0) animated:YES];
  [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj,NSUInteger idx, BOOL *_Nonnull stop) {
    if (idx != index) {
      YXTitleLable *lable =self.smallScrollView.subviews[idx];
      lable.scale =0;
    }
  }];
  // 添加控制器
  UIViewController *vc =self.childViewControllers[index];
  if (vc.view.superview)return;
  NSLog(@"来了%zd号控制器",index);
  vc.view.frame = scrollView.bounds;
  [self.bigScrollView addSubview:vc.view];
}
#pragma mark - getting
@end
