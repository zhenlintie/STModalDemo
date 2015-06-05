//
//  STAlertView.h
//  STModalDemo
//
//  Created by zhenlintie on 15/6/5.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAlertView : UIView

/**
 * 初始化一个视图
 */
- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                      message:(NSString *)message
                 buttonTitles:(NSArray *)buttonTitles;

/**
 * 显示/隐藏
 */
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

/**
 * 事件回调
 */
@property (strong, nonatomic) void (^actionHandler)(NSInteger index);
/**
 * 显示隐藏后回调
 */
@property (strong, nonatomic) void (^didShowHandler)();
@property (strong, nonatomic) void (^didHideHandler)();

@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *message;
@property (copy, nonatomic, readonly) UIImage *image;
@property (copy, nonatomic, readonly) NSArray *buttonTitles;

@property (assign, nonatomic, readonly) BOOL onShow;

// 点击外部，是否隐藏，默认NO
@property (assign, nonatomic) BOOL hideWhenTapOutside;

@end

@interface STAlertView (Show)

+ (instancetype)showTitle:(NSString *)title
                    image:(UIImage *)image
                  message:(NSString *)message
             buttonTitles:(NSArray *)buttonTitles
                  handler:(void(^)(NSInteger index))handler;

+ (instancetype)showTitle:(NSString *)title message:(NSString *)message hideDelay:(CGFloat)delay;
+ (instancetype)showTitle:(NSString *)title message:(NSString *)message;

@end
