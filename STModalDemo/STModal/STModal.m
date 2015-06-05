//
//  STModal.m
//  STModalDemo
//
//  Created by zhenlintie on 15/6/5.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "STModal.h"

@interface STModalWindow : NSObject

+ (instancetype)sharedModalWindow;

@property (assign, nonatomic) BOOL dimBackground;

- (void)setDimBackgroundColor:(UIColor *)color;

- (void)addView:(UIView *)view;
- (void)showWithAnimated:(BOOL)animated
                duration:(CGFloat)duration
                finished:(st_modal_block)handler;
- (void)removeViewAndHide:(UIView *)view
                 animated:(BOOL)animated
                 duration:(CGFloat)duration
                 finished:(st_modal_block)handler;

@end

@implementation STModalWindow{
    NSMutableArray *_viewStack;
    UIWindow *_window;
    UIView *_backgroundView;
}

+ (instancetype)sharedModalWindow{
    static dispatch_once_t onceToken;
    static STModalWindow *_sharedModalWindow = nil;
    dispatch_once(&onceToken, ^{
        _sharedModalWindow = [[self alloc] init];
    });
    return _sharedModalWindow;
}

- (instancetype)init{
    if (self = [super init]){
        _viewStack = [[NSMutableArray alloc] init];
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelAlert;
        _window.backgroundColor = [UIColor clearColor];
        _window.opaque = NO;
        _backgroundView = [[UIView alloc] initWithFrame:_window.bounds];
        [_window addSubview:_backgroundView];
        [self setDimBackgroundColor:nil];
    }
    return self;
}

- (void)setDimBackgroundColor:(UIColor *)color{
    _backgroundView.backgroundColor = color?:[UIColor colorWithWhite:0 alpha:0.55];
}

#pragma mark - views operation

- (void)addView:(UIView *)view{
    if (view){
        if ([_viewStack indexOfObject:view] == NSNotFound){
            [_window addSubview:view];
        }
        else{
            [_viewStack removeObject:view];
        }
        [_viewStack addObject:view];
        [self resetStackViewShowStatus];
    }
}

- (void)removeView:(UIView *)view{
    if (view && (NSNotFound != [_viewStack indexOfObject:view])){
        [_viewStack removeObject:view];
        [view removeFromSuperview];
        [self resetStackViewShowStatus];
    }
}

- (void)resetStackViewShowStatus{
    [_viewStack enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[(UIView *)obj layer] setHidden:(_viewStack.count-1)!=idx];
    }];
}

- (void)removeViewAndHide:(UIView *)view animated:(BOOL)animated duration:(CGFloat)duration finished:(st_modal_block)handler{
    NSInteger index = [_viewStack indexOfObject:view];
    if (NSNotFound != index){
        if (1 == _viewStack.count){
            [self hideWithAnimated:animated duration:duration completion:^(BOOL finished) {
                [self removeView:view];
                if (handler){
                    handler();
                }
            }];
        }
        else{
            CGFloat d = 0;
            if ((index == _viewStack.count-1) && animated){
                d = duration;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(d * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeView:view];
                if (handler){
                    handler();
                }
            });
        }
    }
}

#pragma mark show / hide

- (void)showWithAnimated:(BOOL)animated duration:(CGFloat)duration finished:(st_modal_block)handler{
    if (_viewStack.count > 0){
        if (1 == _viewStack.count){
            [_window setHidden:NO];
            _backgroundView.alpha = 0;
            [UIView animateWithDuration:animated?duration:0
                             animations:^{
                                 if (_dimBackground){
                                     _backgroundView.alpha = 1;
                                 }
                             }
             completion:^(BOOL finished) {
                 if (handler){
                     handler();
                 }
             }];
        }
    }
}

- (void)hideWithAnimated:(BOOL)animated duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion{
    
    if (animated && duration>0 && !_dimBackground){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_window setHidden:YES];
            _backgroundView.alpha = 1;
            completion(YES);
        });
    }
    else{
        [UIView animateWithDuration:animated?duration:0
                         animations:^{
                             _backgroundView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [_window setHidden:YES];
                             _backgroundView.alpha = 1;
                             completion(YES);
                         }];
    }
}

@end


#pragma mark - #################################

@interface STModal ()
@property (strong, nonatomic) UIView *containerView;
@end

@implementation STModal{
    STModalWindow *_window;
    UITapGestureRecognizer *_tap;
    BOOL _onShowing;
}

+ (instancetype)modal{
    return [self new];
}

+ (instancetype)modalWithContentView:(UIView *)contentView{
    STModal *modal = [self modal];
    [modal addModalContentView:contentView];
    return modal;;
}

- (instancetype)init{
    if (self = [super init]){
        _position = STModelPositionCenter;
        _onShowing = NO;
        _hideWhenTouchOutside = NO;
        _animatedHideWhenTouchOutside = YES;
        _dimBackgroundWhenShow = YES;
        _window = [STModalWindow sharedModalWindow];
    }
    return self;
}

- (void)addModalContentView:(UIView *)contentView{
    _contentView = contentView;
}

#pragma mark - setter / getter

- (void)setPosition:(STModelPosition)position{
    if (_position != position){
        _position = position;
        [self updateContentViewPosition];
    }
}

- (UIView *)containerView{
    if (!_containerView){
        CGSize size = [UIScreen mainScreen].bounds.size;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _containerView.backgroundColor = [UIColor clearColor];
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [_containerView addGestureRecognizer:_tap];
    }
    return _containerView;
}

- (st_modal_animation)showAnimation{
    if (!_showAnimation){
        return ^CGFloat(){
            CGFloat d = 0.3;
            _containerView.alpha = 0;
            [UIView animateWithDuration:d
                             animations:^{
                                 _containerView.alpha = 1;
                             }];
            return d;
        };
    }
    return _showAnimation;
}

- (st_modal_animation)hideAnimation{
    if (!_hideAnimation){
        return ^CGFloat(){
            CGFloat d = 0.3;
            [UIView animateWithDuration:d
                             animations:^{
                                 _containerView.alpha = 0;
                             }];
            return d;
        };
    }
    return _hideAnimation;
}

- (BOOL)onShow{
    return _onShowing;
}

#pragma mark - action

- (void)tapped{
    if (_hideWhenTouchOutside && !CGRectContainsPoint(_contentView.frame, [_tap locationInView:_containerView])){
        [self hide:_animatedHideWhenTouchOutside];
    }
}

#pragma mark - for show / hide

- (void)updateContentViewPosition{
    if (!_onShowing){
        return;
    }
    switch (_position) {
        case STModelPositionCenter:
        {
            _contentView.center = CGPointMake(CGRectGetMidX(_containerView.bounds), CGRectGetMidY(_containerView.bounds));
            break;
        }
        case STModelPositionCenterTop:
        {
            _contentView.center = CGPointMake(CGRectGetMidX(_containerView.bounds), CGRectGetMidY(_contentView.bounds));
            break;
        }
        case STModelPositionCenterBottom:
        {
            _contentView.center = CGPointMake(CGRectGetMidX(_containerView.bounds), CGRectGetHeight(_containerView.bounds)-CGRectGetMidY(_contentView.bounds));
            break;
        }
        default:
            break;
    }
}

- (void)prepareUIForShow{
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.containerView addSubview:_contentView?:[UIView new]];
    [self updateContentViewPosition];
    [_window addView:_containerView];
    [_window setDimBackgroundColor:self.dimBackgroundColor];
}

- (void)showContentView:(UIView *)contentView animated:(BOOL)animated{
    [self addModalContentView:contentView];
    [self show:animated];
}

- (void)show:(BOOL)animated{
    if (_onShowing){
        [_window addView:_containerView];
        return;
    }
    _onShowing = YES;
    [self prepareUIForShow];
    _window.dimBackground = self.dimBackgroundWhenShow;
    [_window showWithAnimated:animated duration:animated?self.showAnimation():0 finished:self.didShowHandler];
}

- (void)hide:(BOOL)animated{
    _onShowing = NO;
    [_window removeViewAndHide:_containerView animated:animated duration:animated?self.hideAnimation():0 finished:self.didHideHandler];
}

@end
