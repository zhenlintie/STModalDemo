//
//  STModal.h
//  STModalDemo
//
//  Created by zhenlintie on 15/6/5.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 主视图显示位置
 */
typedef NS_ENUM(NSUInteger, STModelPosition) {
    STModelPositionCenter,
    STModelPositionCenterTop,
    STModelPositionCenterBottom,
};

/**
 * 执行的动画块
 * @return 动画所需时间
 */
typedef CGFloat (^st_modal_animation)();

/**
 * 回调
 */
typedef void (^st_modal_block)();

/**
 * 弹出视图控制器
 */
@interface STModal : NSObject

+ (instancetype)modal;
+ (instancetype)modalWithContentView:(UIView *)contentView;

/**
 * 所显示的主视图
 */
@property (strong, nonatomic, readonly) UIView *contentView;

/**
 * contentView位置，默认STModelPositionCenter
 */
@property (assign, nonatomic) STModelPosition position;

/**
 * 点击contentView外的区域是否执行hide，默认为NO
 */
@property (assign, nonatomic) BOOL hideWhenTouchOutside;

/**
 * 当touchOutDismiss为YES时，是否发生动画，默认是YES
 */
@property (assign, nonatomic) BOOL animatedHideWhenTouchOutside;

/**
 * 背景是否加蒙版，默认为YES
 */
@property (assign, nonatomic) BOOL dimBackgroundWhenShow;

/**
 * 自定义背景蒙版颜色，默认为nil
 */
@property (strong, nonatomic) UIColor *dimBackgroundColor;


/** 当不设置执行动画时，且animated为YES，会默认执行一个过渡动画 */
/** 
 * 显示时的动画
 */
@property (strong, nonatomic) st_modal_animation showAnimation;

/**
 * 隐藏时的动画
 */
@property (strong, nonatomic) st_modal_animation hideAnimation;

/**
 * 显示后/隐藏后回调
 */
@property (strong, nonatomic) st_modal_block didShowHandler;
@property (strong, nonatomic) st_modal_block didHideHandler;

/**
 * 显示
 */
- (void)show:(BOOL)animated;

/**
 * 显示指定的contentView，若之前已设置，则替换掉。
 */
- (void)showContentView:(UIView *)contentView animated:(BOOL)animated;

/**
 * 是否已经显示
 */
@property (assign, readonly, nonatomic) BOOL onShow;

/** 
 * 隐藏
 */
- (void)hide:(BOOL)animated;

@end
