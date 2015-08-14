//
//  STFrontModal.m
//  STModalDemo
//
//  Created by zhenlintie on 15/8/14.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "STFrontModal.h"

@interface STModal (STFrontModal)

@property (strong, nonatomic) UIView *containerView;

@end

@interface STFrontModal ()

@property (strong, nonatomic) STModal *modal;

@end

@implementation STFrontModal

+ (instancetype)sharedFrontModal{
    static STFrontModal *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[STFrontModal alloc] _init];
    });
    return _shared;
}

- (instancetype)_init{
    if (self = [super init]){
        _modal = [STModal new];
        _modal.hideWhenTouchOutside = YES;
        _modal.positionMode = STModelPositionCenterBottom;
        _modal.showAnimation = [self showAnimation];
        _modal.hideAnimation = [self hideAnimation];
    }
    return self;
}

- (instancetype)init{
    return [[self class] sharedFrontModal];
}

+ (void)showView:(UIView *)view animated:(BOOL)animated{
    [[self sharedFrontModal] showView:view animated:animated];
}

+ (void)hide:(BOOL)animated{
    [[self sharedFrontModal] hide:animated];
}

- (void)showView:(UIView *)view animated:(BOOL)animated{
    [_modal showContentView:view animated:animated];
}

- (void)hide:(BOOL)animated{
    [_modal hide:animated];
}

- (st_modal_animation)showAnimation{
    return ^CGFloat(){
        _modal.contentView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(_modal.contentView.frame));
        
        CGFloat d = 0.35;
        [UIView animateWithDuration:d
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _modal.contentView.transform = CGAffineTransformIdentity;
                             [self keyWindow].transform = CGAffineTransformMakeScale(0.85, 0.85);
                         }
                         completion:nil];
        return d;
    };
}

- (st_modal_animation)hideAnimation{
    return ^CGFloat(){
        CGFloat d = 0.3;
        [UIView animateWithDuration:d
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _modal.contentView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(_modal.contentView.frame)+5);
                             [self keyWindow].transform = CGAffineTransformIdentity;
                         }
                         completion:nil];
        return d;
    };
}

- (UIWindow *)keyWindow{
    return [UIApplication sharedApplication].keyWindow;
}

@end
