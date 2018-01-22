//
//  YCTest3ViewController.m
//  runlooptest
//
//  Created by 赵燕超 on 2017/7/20.
//  Copyright © 2017年 yc.test. All rights reserved.
//

#import "YCTest3ViewController.h"

static NSString * IDENTIFIER = @"IDENTIFIER";
static CGFloat CELL_HEIGHT = 135.f;

typedef void(^RunloopBlock)();

@interface YCTest3ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *exampleTableView;

@property (nonatomic, strong)NSMutableArray *tasks;

@property (nonatomic, assign)NSUInteger maxQueueLength;

@end

@implementation YCTest3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"test3";
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.frame;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = CELL_HEIGHT;
    tableView.rowHeight = CELL_HEIGHT;
    [self.view addSubview:tableView];
    self.exampleTableView = tableView;
    
    
    self.maxQueueLength = 18;
    self.tasks = [NSMutableArray array];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.00001 repeats:YES block:^(NSTimer * _Nonnull timer) {}];
    
    [self addRunloopObserver];

}

+ (void)addlabel:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%zd - Learn wisdom by the follies of others", indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 4;
    [cell.contentView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines = 0;
    label1.textColor = [UIColor grayColor];
    label1.text = [NSString stringWithFormat:@"%zd - a specific fact, idea, person, or thing that is used to explain or support a general idea, or to show what is typical of a larger group", indexPath.row];
    label1.font = [UIFont boldSystemFontOfSize:13];
    label1.tag = 5;
    [cell.contentView addSubview:label1];
    
}

+ (void)addImage1With:(UITableViewCell *)cell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
    imageView.tag = 1;
    NSString *path1 = [[NSBundle mainBundle]pathForResource:@"spaceship.jpg" ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
    
}
+ (void)addImage2With:(UITableViewCell *)cell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
    imageView.tag = 2;
    NSString *path1 = [[NSBundle mainBundle]pathForResource:@"spaceship.jpg" ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
    
}
+ (void)addImage3With:(UITableViewCell *)cell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 85, 85)];
    imageView.tag = 3;
    NSString *path1 = [[NSBundle mainBundle]pathForResource:@"spaceship.jpg" ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.image = image;
    [UIView transitionWithView:cell.contentView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imageView];
    } completion:nil];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 399;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    // 添加文字
    [YCTest3ViewController addlabel:cell indexPath:indexPath];
    
    // 添加图片
    [self addTask:^{
        [YCTest3ViewController addImage1With:cell];
    }];
    [self addTask:^{
        [YCTest3ViewController addImage2With:cell];
    }];
    [self addTask:^{
        [YCTest3ViewController addImage3With:cell];
    }];
    
    return cell;
}

#pragma mark - runloop
- (void)addTask:(RunloopBlock)task
{
    [self.tasks addObject:task];
    if (self.tasks.count > self.maxQueueLength) {
        [self.tasks removeObjectAtIndex:0];
    }
}

- (void)addRunloopObserver
{
    // 获取runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    // 定义观察者
    static CFRunLoopObserverRef defaultModeObserver;
    
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    // 创建
    defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &context);
    // 添加到runloop中
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopCommonModes);
    
}

// 回调
static void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    YCTest3ViewController *vc = (__bridge YCTest3ViewController *)info;
    if (vc.tasks.count == 0) {
        return;
    }
    RunloopBlock task = vc.tasks.firstObject;
    task();
    [vc.tasks removeObjectAtIndex:0];
}








@end
