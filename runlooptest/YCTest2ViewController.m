//
//  YCTest2ViewController.m
//  runlooptest
//
//  Created by 赵燕超 on 2017/7/20.
//  Copyright © 2017年 yc.test. All rights reserved.
//

#import "YCTest2ViewController.h"

@interface YCTest2ViewController ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation YCTest2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"test2";
    
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"%@", [NSThread currentThread]);
    });
    dispatch_resume(timer);
    self.timer = timer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.timer = nil;
}

@end
