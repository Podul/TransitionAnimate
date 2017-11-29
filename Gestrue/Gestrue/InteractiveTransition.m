//
//  InteractiveTransition.m
//  Gestrue
//
//  Created by Podul on 2017/11/28.
//  Copyright © 2017年 Podul. All rights reserved.
//

#import "InteractiveTransition.h"

@interface InteractiveTransition ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, assign) TransitionGestureDirection toDirection;   ///< 传进来的手势方向
@property (nonatomic, assign) TransitionGestureDirection direction;     ///< 手势方向
@property (nonatomic, assign) TransitionType type;                      ///< 手势类型

@property (nonatomic, assign) BOOL needJudge;                           ///< 是否需要判断手势方向
@property (nonatomic, assign) BOOL needScroll;                          ///< 是否需要滑动

@end

@implementation InteractiveTransition

/// 初始化
+ (instancetype)transitionWithTransitionType:(TransitionType)type gestureDirection:(TransitionGestureDirection)direction {
    return [[self alloc] initWithTransitionType:type gestureDirection:direction];
}

- (instancetype)initWithTransitionType:(TransitionType)type gestureDirection:(TransitionGestureDirection)direction {
    self = [super init];
    if (self) {
        _toDirection = direction;
        _type = type;
        _needJudge = YES;
        _needScroll = YES;
    }
    return self;
}

/// 创建并添加手势
- (void)addPanGestureForViewController:(UIViewController *)viewController {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    pan.delegate = self;
    [viewController.view addGestureRecognizer:pan];
}

/// 手势过渡的过程
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture translationInView:panGesture.view];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _needJudge = YES;
    }
    
    if (_needJudge) {
        // 先判断方向
        [self commitTranslation:point];
    }
    
    // 手势百分比
    CGFloat ratio = 0.f;
    _needJudge = NO;
    switch (_direction) {
        case TransitionGestureDirectionUnknow: {
            _needJudge = YES;
            break;
        }
        case TransitionGestureDirectionLeft: {
            ratio = -point.x / CGRectGetWidth(panGesture.view.frame);
        }
            break;
        case TransitionGestureDirectionRight: {
            ratio = point.x / CGRectGetWidth(panGesture.view.frame);
        }
            break;
        case TransitionGestureDirectionUp: {
            ratio = -point.y / CGRectGetHeight(panGesture.view.frame);
        }
            break;
        case TransitionGestureDirectionDown: {
            ratio = point.y / CGRectGetHeight(panGesture.view.frame);
        }
            break;
    }
    
//    if (ratio < 0) {
//        ratio = 0;
//        [self cancelInteractiveTransition];
//        return;
//    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            _needScroll = YES;
            // 手势开始的时候标记手势状态，并开始相应的事件
            self.interation = YES;
            [self startGesture];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self startGesture];
            // 手势过程中，通过 updateInteractiveTransition 设置 pop 过程进行的百分比
            [self updateInteractiveTransition:ratio];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            _needJudge = YES;
            // 手势完成后结束标记并且判断移动距离是否过 30%，过则 finishInteractiveTransition 完成转场操作，否则取消转场操作
            self.interation = NO;
            if (ratio > 0.3) {
                [self finishInteractiveTransition];
            }else {
                [self cancelInteractiveTransition];
            }
        }
            break;
        default:
            break;
    }
}

/// 手势触发
- (void)startGesture {
    if (_needJudge) {
        return;
    }
    
    if (!_needScroll) {
        return;
    }
    
    switch (_type) {
        case TransitionTypePresent: {
            if (_presentConifg) {
                _presentConifg(_direction);
            }
        }
            break;
        case TransitionTypeDismiss: {
            if (_direction == _toDirection) {
                [_vc dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case TransitionTypePush: {
            if (_pushConifg) {
                _pushConifg(_direction);
            }
        }
            break;
        case TransitionTypePop:{
            if (_direction == _toDirection) {
                [_vc.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
    }
    _needScroll = NO;
}

/// 判断手势方向
- (void)commitTranslation:(CGPoint)translation {
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    _direction = TransitionGestureDirectionUnknow;
    // 设置滑动有效距离
    if (MAX(absX, absY) < 1.0) {
        _needJudge = YES;
        return;
    }
    
    if (absX > absY ) {
        if (translation.x < 0) {
            // 向左滑动
            _direction = TransitionGestureDirectionLeft;
        }else {
            // 向右滑动
            _direction = TransitionGestureDirectionRight;
        }
    }else if (absY > absX) {
        if (translation.y < 0) {
            // 向上滑动
            _direction = TransitionGestureDirectionUp;
        }else {
            // 向下滑动
            _direction = TransitionGestureDirectionDown;
        }
    }else {
        
    }
}

//#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

@end
