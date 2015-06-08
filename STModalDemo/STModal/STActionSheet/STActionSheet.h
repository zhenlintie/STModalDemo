//
//  STActionSheet.h
//  STModalDemo
//
//  Created by zhenlintie on 15/6/6.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STActionItem;
typedef void(^st_sheet_action_handler)(STActionItem *item, NSInteger index);

@interface STActionSheet : UIView

/**
 * `cancelTitle`与`otherButtonTitles`的属性，当`attribute`存在，则用`attribute`
 *  否则用默认的
 */
- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                    attribute:(NSDictionary *)attribute;

// 此初始化忽略`itemAttribute`
- (instancetype)initWithTitle:(NSString *)title cancelItem:(STActionItem *)cancelItem items:(NSArray *)items;

/**
 * 显示/隐藏
 */
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

/**
 * 点击外部是否隐藏，默认为YES
 */
@property (nonatomic, assign) BOOL hideWhenTouchOutside;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) STActionItem *cancelItem;
@property (nonatomic, readonly) NSArray *items;

/**
 * 事件回调
 */
@property (strong, nonatomic) st_sheet_action_handler actionHandler;
@property (strong, nonatomic) void(^didCancelHandler)(STActionItem *cancelItem);
@property (strong, nonatomic) void (^didShowHandler)();
@property (strong, nonatomic) void (^didHideHandler)();

@end


@interface STActionSheet (Show)

+ (instancetype)showTitle:(NSString *)title
                    items:(NSArray *)items
                   cancel:(STActionItem *)cancelItem;
+ (instancetype)showItems:(NSArray *)items
            actionHandler:(st_sheet_action_handler)actionHandler;
+ (instancetype)showTitle:(NSString *)title
                    items:(NSArray *)items
            actionHandler:(st_sheet_action_handler)actionHandler;
+ (instancetype)showTitle:(NSString *)title
                    items:(NSArray *)items
                   cancel:(STActionItem *)cancelItem
            actionHandler:(st_sheet_action_handler)actionHandler
            cancelHandler:(void(^)(STActionItem *cancelItem))canceledHandler;

+ (instancetype)showTitle:(NSString *)title
        otherButtonTitles:(NSArray *)otherButtonTitles
                   cancel:(NSString *)cancelTitle
                attribute:(NSDictionary *)attribute;
+ (instancetype)showTitle:(NSString *)title
        otherButtonTitles:(NSArray *)otherButtonTitles
                   cancel:(NSString *)cancelTitle
                attribute:(NSDictionary *)attribute
            actionHandler:(st_sheet_action_handler)actionHandler
            cancelHandler:(void(^)(STActionItem *cancelItem))canceledHandler;

@end


/**
 * STActionSheet的元素
 */
@interface STActionItem : NSObject

/**
 * 快速生成
 */
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithAttributedTitle:(NSAttributedString *)attributedTitle;
+ (instancetype)itemWithTitle:(NSString *)title icon:(UIImage *)icon;
+ (instancetype)itemWithAttributedTitle:(NSAttributedString *)attributedTitle icon:(UIImage *)icon;
+ (instancetype)itemWithTitle:(NSString *)title attribute:(NSDictionary *)attribute;

/**
 * 初始化
 */
- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon;
- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle icon:(UIImage *)icon;

@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) UIImage  *icon;

@property (copy, nonatomic, readonly) NSAttributedString *attributedTitle;

@end

@interface STActionItem (Common)

/**
 * 提醒格式的item
 */
+ (instancetype)desdructiveItem:(NSString *)title;
+ (instancetype)desdructiveItem:(NSString *)title icon:(UIImage *)icon;

@end
