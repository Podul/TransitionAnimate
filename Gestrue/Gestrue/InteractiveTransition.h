//
//  InteractiveTransition.h
//  Gestrue
//
//  Created by Podul on 2017/11/28.
//  Copyright © 2017年 Podul. All rights reserved.
//  手势管理

#import <UIKit/UIKit.h>

// 手势的方向
typedef NS_ENUM(NSUInteger, TransitionGestureDirection) {
    TransitionGestureDirectionUnknow = -1,
    TransitionGestureDirectionLeft = 0,
    TransitionGestureDirectionRight,
    TransitionGestureDirectionUp,
    TransitionGestureDirectionDown
};

// 手势控制哪种转场
typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionTypePresent = 0,
    TransitionTypeDismiss,
    TransitionTypePush,
    TransitionTypePop,
};

typedef void(^GestureConifg)(TransitionGestureDirection direction);

@interface InteractiveTransition : UIPercentDrivenInteractiveTransition

/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;

/**触发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg presentConifg;

/**触发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg pushConifg;

//初始化方法
+ (instancetype)transitionWithTransitionType:(TransitionType)type gestureDirection:(TransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(TransitionType)type gestureDirection:(TransitionGestureDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;
@end
