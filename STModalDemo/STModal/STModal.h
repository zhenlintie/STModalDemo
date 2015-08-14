//
//  STModal.h
//  STModalDemo
//
//  Created by zhenlintie on 15/6/5.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @discussion 主视图显示位置
 */
typedef NS_ENUM(NSUInteger, STModelPositionMode) {
    STModelPositionCenter,
    STModelPositionCenterTop,
    STModelPositionCenterBottom,
    STModelPositionCustom
};

/**
 * @discussion 执行的动画块
 * @return 动画所需时间
 */
typedef CGFloat (^st_modal_animation)();

/**
 * @discussion 回调
 */
typedef void (^st_modal_block)();

/**
 * @discussion 弹出视图控制器
 */
@interface STModal : NSObject

+ (instancetype)modal;
+ (instancetype)modalWithContentView:(UIView *)contentView;

/**
 * @discussion 所显示的主视图
 */
@property (strong, nonatomic, readonly) UIView *contentView;

/**
 * @discussion contentView位置，默认STModelPositionCenter
 */
@property (assign, nonatomic) STModelPositionMode positionMode;

/**
 * @discussion 自定义位置，只有当position为STModelPositionCustom时生效
 */
@property (assign, nonatomic) CGPoint position;

/**
 * @discussion 点击contentView外的区域是否执行hide，默认为NO
 */
@property (assign, nonatomic) BOOL hideWhenTouchOutside;

/**
 * @discussion 当touchOutDismiss为YES时，是否发生动画，默认是YES
 */
@property (assign, nonatomic) BOOL animatedHideWhenTouchOutside;

/**
 * @discussion 背景是否加蒙版，默认为YES
 */
@property (assign, nonatomic) BOOL dimBackgroundWhenShow;

/**
 * @discussion 自定义背景蒙版颜色，默认为nil
 */
@property (strong, nonatomic) UIColor *dimBackgroundColor;


//// 当不设置执行动画时，且animated为YES，会默认执行一个过渡动画
/** 
 * @discussion 显示时的动画
 */
@property (strong, nonatomic) st_modal_animation showAnimation;

/**
 * @discussion 隐藏时的动画
 */
@property (strong, nonatomic) st_modal_animation hideAnimation;

/**
 * @discussion 显示后/隐藏后回调
 */
@property (strong, nonatomic) st_modal_block didShowHandler;
@property (strong, nonatomic) st_modal_block didHideHandler;

/**
 * @discussion 显示
 */
- (void)show:(BOOL)animated;

/**
 * @discussion 显示指定的contentView，若之前已设置，则替换掉。
 */
- (void)showContentView:(UIView *)contentView animated:(BOOL)animated;

/**
 * @discussion 是否已经显示
 */
@property (assign, readonly, nonatomic) BOOL onShow;

/** 
 * @discussion 隐藏
 */
- (void)hide:(BOOL)animated;

@end
