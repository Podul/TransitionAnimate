//
//  ViewController.m
//  Gestrue
//
//  Created by Podul on 2017/11/27.
//  Copyright © 2017年 Podul. All rights reserved.
//

#import "ViewController.h"
#import "InteractiveTransition.h"
#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"
#import "DViewController.h"

@interface ViewController ()
@property (nonatomic, strong) InteractiveTransition *interactive1;
@property (nonatomic, strong) InteractiveTransition *interactive2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _interactive1 = [InteractiveTransition transitionWithTransitionType:TransitionTypePresent gestureDirection:TransitionGestureDirectionRight];
    __weak __typeof(self) weakSelf = self;
    _interactive1.presentConifg = ^(TransitionGestureDirection direction) {
        switch (direction) {
            case TransitionGestureDirectionUnknow: {
                
            }
                break;
            case TransitionGestureDirectionUp: {
                [weakSelf present4];
            }
                break;
            case TransitionGestureDirectionLeft: {
                [weakSelf present2];
            }
                break;
            case TransitionGestureDirectionDown: {
                [weakSelf present3];
            }
                break;
            case TransitionGestureDirectionRight: {
                [weakSelf present1];
            }
                break;
        }
        
    };
    [_interactive1 addPanGestureForViewController:self];
}

- (void)present1 {
    AViewController *presentedVC = [AViewController new];
    presentedVC.interactive = _interactive1;
    presentedVC.gestureDirection = TransitionGestureDirectionLeft;
    [self presentViewController:presentedVC animated:YES completion:nil];
}

- (void)present2 {
    BViewController *presentedVC = [BViewController new];
    presentedVC.interactive = _interactive1;
    presentedVC.gestureDirection = TransitionGestureDirectionRight;
    [self presentViewController:presentedVC animated:YES completion:nil];
}

- (void)present3 {
    CViewController *presentedVC = [CViewController new];
    presentedVC.interactive = _interactive1;
    presentedVC.gestureDirection = TransitionGestureDirectionUp;
    [self presentViewController:presentedVC animated:YES completion:nil];
}

- (void)present4 {
    DViewController *presentedVC = [DViewController new];
    presentedVC.interactive = _interactive1;
    presentedVC.gestureDirection = TransitionGestureDirectionDown;
    [self presentViewController:presentedVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
