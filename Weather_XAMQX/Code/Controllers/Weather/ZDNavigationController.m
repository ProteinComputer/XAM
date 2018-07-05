//
//  UINavigationController子类，允许在隐藏导航栏或使用自定义后退按钮时识别交互式pop手势。
//
//  ZDNavigationController.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/5.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "ZDNavigationController.h"

@interface ZDNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

/* 一个布尔值，指示导航控制器当前是否在堆栈上推新的视图控制器 */
@property (nonatomic, getter = isDuringPushAnimation) BOOL duringPushAnimation;

/* 类的一个真正的委托。“委托”属性仅用于在动画期间保持内部状态——我们需要知道动画何时结束，而该信息只能从"navigationController:didShowViewController:animated:"方法中获得。 */
@property (weak, nonatomic) id<UINavigationControllerDelegate> realDelegate;

@end

@implementation ZDNavigationController

#pragma mark - NSObject

- (void)dealloc {
    
    self.delegate = nil;
    
    self.interactivePopGestureRecognizer.delegate = nil; //交互式流行手势识别器
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!self.delegate) {
        
        self.delegate = self;
    }
    
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UINavigationController

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    
    self.realDelegate = delegate != self ? delegate : nil;
    
    [super setDelegate:delegate ? self : nil];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated __attribute__((objc_requires_super)) {
    
    self.duringPushAnimation = YES;
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    /* 交互式流行手势识别器代理变更的断言 */
    NSCAssert(self.interactivePopGestureRecognizer.delegate == self, @"AHKNavigationController won't work correctly if you change interactivePopGestureRecognizer's delegate.");
    
    self.duringPushAnimation = NO;
    
    if ([self.realDelegate respondsToSelector:_cmd]) {
        
        [self.realDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        
        /* 在以下两种情况下禁用pop手势: 1) 当弹出动画正在进行中。2) 当用户快速滑动几次时，动画就没有时间执行了。 */
        return [self.viewControllers count] > 1 && !self.isDuringPushAnimation;
    } else {
        
        return YES;//默认值
    }
}

#pragma mark - Delegate Forwarder - 代理转发器

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    return [super respondsToSelector:aSelector] || [self.realDelegate respondsToSelector:aSelector];
}

/* 方法签名的选择器 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    return [super methodSignatureForSelector:aSelector] ? : [(id)self.realDelegate methodSignatureForSelector:aSelector];
}

/* 提前调用 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    id delegate = self.realDelegate;
    
    if ([delegate respondsToSelector:anInvocation.selector]) {
        
        [anInvocation invokeWithTarget:delegate];
    }
}

@end

















