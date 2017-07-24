//
//  YCTest1ViewController.m
//  runlooptest
//
//  Created by 赵燕超 on 2017/7/20.
//  Copyright © 2017年 yc.test. All rights reserved.
//

#import "YCTest1ViewController.h"

@interface YCTest1ViewController ()

@property (nonatomic, assign) BOOL finish;

@end

@implementation YCTest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"test1";
    self.finish = NO;
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSThread *thread = [[NSThread alloc] initWithBlock:^{
            
            NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            
            while (!self.finish) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.00001]];
            }
            
            NSLog(@"来了！！%@", [NSThread currentThread]);
        }];
        
        [thread start];
        
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}

- (void)timerMethod
{
    NSLog(@"come here");
    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.finish = YES;
}

@end
