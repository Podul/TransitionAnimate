//
//  TransitionAnimate.m
//  Gestrue
//
//  Created by Podul on 2017/11/28.
//  Copyright © 2017年 Podul. All rights reserved.
//

#import "TransitionAnimate.h"
#import "InteractiveTransition.h"

@interface TransitionAnimate()
@property (nonatomic, assign) TransitionAnimateType type;
@property (nonatomic, assign) TransitionGestureDirection direction;
@end

static id<UIViewControllerContextTransitioning> _transitionContext = nil;

@implementation TransitionAnimate

#pragma mark - init
/// 初始化
+ (instancetype)transitionWithTransitionType:(TransitionAnimateType)type direction:(TransitionGestureDirection)direction{
    return [[self alloc] initWithTransitionType:type direction:direction];
}

- (instancetype)initWithTransitionType:(TransitionAnimateType)type direction:(TransitionGestureDirection)direction {
    self = [super init];
    if (self) {
        _type = type;
        _direction = direction;
    }
    return self;
}

#pragma mark - 动画
/// 转场持续时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    // 两种动画
    switch (_type) {
        case TransitionAnimateTypeShow:
            [self showAnimation];
            break;
            
        case TransitionAnimateTypeHide:
            [self hideAnimation];
            break;
    }
}

/// 实现出现动画
- (void)showAnimation {
    // 取出两个 controller
    UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
//    NSLog(@"%@--%@",toVC, fromVC);
    
    // 截图
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromVC.view.frame;
    fromVC.view.hidden = YES;
    // 加到 containerView 中
    [_transitionContext.containerView addSubview:tempView];
    [_transitionContext.containerView addSubview:toVC.view];
    
    switch (_direction) {
        case TransitionGestureDirectionUp:{
            toVC.view.frame = CGRectMake(0, -CGRectGetHeight(_transitionContext.containerView.bounds), _transitionContext.containerView.bounds.size.width, _transitionContext.containerView.bounds.size.height);
            [self showControllerWithView:tempView animations:^{
                // 让 vc2 平移
                toVC.view.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(_transitionContext.containerView.bounds));
                // 然后让截图视图隐藏
                tempView.alpha = 0;
            }];
        }
            break;
        case TransitionGestureDirectionLeft:{
            toVC.view.frame = CGRectMake(-_transitionContext.containerView.bounds.size.width, 0, _transitionContext.containerView.bounds.size.width, _transitionContext.containerView.bounds.size.height);
            [self showControllerWithView:tempView animations:^{
                // 让 vc2 向右移动
                toVC.view.transform = CGAffineTransformMakeTranslation(_transitionContext.containerView.bounds.size.width, 0);
                // 然后让截图视图隐藏
                tempView.alpha = 0;
            }];
        }
            break;
        case TransitionGestureDirectionDown:{
            toVC.view.frame = CGRectMake(0, CGRectGetHeight(_transitionContext.containerView.bounds), _transitionContext.containerView.bounds.size.width, _transitionContext.containerView.bounds.size.height);
            [self showControllerWithView:tempView animations:^{
                // 让 vc2 向右移动
                toVC.view.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(_transitionContext.containerView.bounds));
                // 然后让截图视图隐藏
                tempView.alpha = 0;
            }];
        }
            break;
        case TransitionGestureDirectionRight:{
            toVC.view.frame = CGRectMake(_transitionContext.containerView.bounds.size.width, 0, _transitionContext.containerView.bounds.size.width, _transitionContext.containerView.bounds.size.height);
            [self showControllerWithView:tempView animations:^{
                // 让 vc2 向右移动
                toVC.view.transform = CGAffineTransformMakeTranslation(-_transitionContext.containerView.bounds.size.width, 0);
                // 然后让截图视图隐藏
                tempView.alpha = 0;
            }];
        }
            break;
        case TransitionGestureDirectionUnknow: {
            break;
        }
    }
}

/// 显示通用部分
- (void)showControllerWithView:(UIView *)tempView animations:(void (^)(void))animations {
    // 开始动画，使用产生弹簧效果的动画 API
    [UIView animateWithDuration:[self transitionDuration:_transitionContext] animations:^{
        if (animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        // 使用如下代码标记整个转场过程是否正常完成 [transitionContext transitionWasCancelled] 代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不是用手势的话直接传YES也是可以的，我们必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在，会出现无法交互的情况，切记
        [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
        // 转场失败后的处理
        if ([_transitionContext transitionWasCancelled]) {
            // 失败后，我们要把vc1显示出来
            UIViewController *fromVC = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            fromVC.view.hidden = NO;
            // 然后移除截图视图
            [tempView removeFromSuperview];
        }
    }];
}

/// 实现消失动画
- (void)hideAnimation {
    
    // 注意在 dismiss 的时候 fromVC 就是 vc2 了，toVC 才是 VC1 了，注意理解这个逻辑关系
    UIViewController *fromVC = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 参照 present 动画的逻辑，present 成功后，containerView 的最后一个子视图就是截图视图，我们将其取出准备动画
    UIView *containerView = [_transitionContext containerView];
    NSArray *subviewsArray = containerView.subviews;
    UIView *tempView = subviewsArray[MIN(subviewsArray.count, MAX(0, subviewsArray.count - 2))];
    
    // 动画
    [UIView animateWithDuration:[self transitionDuration:_transitionContext] animations:^{
        // 因为 present 的时候都是使用的 transform，这里的动画只需要将 transform 恢复就可以了
        fromVC.view.transform = CGAffineTransformIdentity;
        tempView.transform = CGAffineTransformIdentity;
        tempView.alpha = 1;
    } completion:^(BOOL finished) {
        if ([_transitionContext transitionWasCancelled]) {
            // 失败了接标记失败
            [_transitionContext completeTransition:NO];
        }else{
            // 如果成功了，我们需要标记成功，同时让 vc1 显示出来，然后移除截图视图，
            [_transitionContext completeTransition:YES];
            toVC.view.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}
@end
