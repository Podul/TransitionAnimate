//
//  TransitionViewController.m
//  Gestrue
//
//  Created by Podul on 2017/11/28.
//  Copyright © 2017年 Podul. All rights reserved.
//

#import "TransitionViewController.h"
#import "TransitionAnimate.h"

@interface TransitionViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) InteractiveTransition *interactiveHide;
@end

@implementation TransitionViewController

- (void)dealloc {
//    NSLog(@"销毁了!!!!!");
}

- (instancetype)init {
    if (self = [super init]) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        // 默认值
        _transitionType = TransitionTypeDismiss;
        _gestureDirection = TransitionGestureDirectionUp;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactiveHide = [InteractiveTransition transitionWithTransitionType:_transitionType gestureDirection:_gestureDirection];
    [self.interactiveHide addPanGestureForViewController:self];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [TransitionAnimate transitionWithTransitionType:TransitionAnimateTypeShow direction:_gestureDirection];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [TransitionAnimate transitionWithTransitionType:TransitionAnimateTypeHide direction:_gestureDirection];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _interactiveHide.interation ? _interactiveHide : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactive.interation ? self.interactive : nil;
}

@end
