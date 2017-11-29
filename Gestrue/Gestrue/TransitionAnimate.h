//
//  TransitionAnimate.h
//  Gestrue
//
//  Created by Podul on 2017/11/28.
//  Copyright © 2017年 Podul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InteractiveTransition.h"

typedef NS_ENUM(NSUInteger, TransitionAnimateType) {
    TransitionAnimateTypeShow = 0,      ///< 管理出现动画
    TransitionAnimateTypeHide           ///< 管理消失动画
};

@interface TransitionAnimate : NSObject<UIViewControllerAnimatedTransitioning>

/// 初始化方法
+ (instancetype)transitionWithTransitionType:(TransitionAnimateType)type direction:(TransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(TransitionAnimateType)type direction:(TransitionGestureDirection)direction;

@end
