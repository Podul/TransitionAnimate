//
//  TransitionViewController.h
//  Gestrue
//
//  Created by Podul on 2017/11/28.
//  Copyright © 2017年 Podul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractiveTransition.h"

@interface TransitionViewController : UIViewController
@property (nonatomic, assign) TransitionGestureDirection gestureDirection;  ///< 手势方向
@property (nonatomic, assign) TransitionType transitionType;                ///< 转场方式
@property (nonatomic, strong) InteractiveTransition *interactive;           ///<
@end
