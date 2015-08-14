//
//  STActionSheet.m
//  STModalDemo
//
//  Created by zhenlintie on 15/6/6.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "STActionSheet.h"
#import "STModal.h"
#import "STModalUtil.h"

#define kSTSheetRadius             13
#define kSTSheetSidePaddingV       8
#define kSTSheetSidePaddingH       8
#define kSTSheetContentPadding     8
#define kSTSheetButtonHeight       44
#define kSTSheetLineColor          STModalRGBA(78, 78, 80, 1)
#define kSTSheetBackColor          STModalRGBA(150, 164, 168, 1)
#define kSTSheetTitleColor         STModalRGBA(242, 249, 255, 1)

/**
 * 按钮容器
 */
@interface STASContainerView : UIView
@property (strong, nonatomic) UIView *containerView;
@end

@implementation STASContainerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.layer.cornerRadius = kSTSheetRadius;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = kSTSheetLineColor.CGColor;
//        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
//        self.layer.shadowOffset = CGSizeZero;
//        self.layer.shadowOpacity = 0.3;
//        self.layer.shadowRadius = kSTSheetRadius*2;
        
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.layer.cornerRadius = kSTSheetRadius;
        _containerView.layer.masksToBounds = YES;
        _containerView.backgroundColor = kSTSheetBackColor;
        [self addSubview:_containerView];
    }
    return self;
}

- (void)addSubview:(UIView *)view{
    if (![view isEqual:_containerView] && ![view isKindOfClass:[UIToolbar class]]){
        [_containerView addSubview:view];
        return;
    }
    [super addSubview:view];
}

- (void)layoutSubviews{
    _containerView.frame = self.bounds;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end



@interface STASButton : UIButton
@property (strong, nonatomic) STActionItem *item;
@property (assign, nonatomic) CGFloat iconWidth;
@property (assign, nonatomic) CGFloat iconPadding;
@end

@implementation STASButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setBackgroundImage:st_imageWithColor(STModalRGBA(120, 134, 138, 0.7)) forState:UIControlStateHighlighted];
        self.adjustsImageWhenHighlighted = NO;
        self.adjustsImageWhenDisabled = NO;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setItem:(STActionItem *)item{
    _item = item;
    [self reloadData];
}

- (void)reloadData{
    if (_item.icon){
        [self setImage:_item.icon forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [self setAttributedTitle:_item.attributedTitle forState:UIControlStateNormal];
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    if (_item.icon){
        return CGRectMake(_iconPadding*(1.3), 0, _iconWidth, kSTSheetButtonHeight);
    }
    return CGRectZero;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (_item.icon){
        return CGRectMake(_iconWidth+(1.3+0.4)*_iconPadding, 0, CGRectGetWidth(contentRect)-_iconWidth-(3)*_iconPadding, kSTSheetButtonHeight);
    }
    return self.bounds;
}

@end


/**
 * 类似UIActionSheet
 */
@interface STActionSheet ()

@property (strong, nonatomic) STModal *modal;

@property (strong, nonatomic) STASContainerView *topContainerView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) STASContainerView *cancelContainerView;
@property (strong, nonatomic) STASButton *cancelButton;
@property (strong, nonatomic) NSMutableArray *otherButtons;
@property (strong, nonatomic) NSMutableArray *lines;

@end

@implementation STActionSheet{
    BOOL _didLayouted;
    
    CGSize _screenSize;
    CGFloat _otherButtonsHeight;
    CGFloat _maxTopContainerHeight;
    CGFloat _contentWidth;
    CGSize _buttonSize;
}

- (instancetype)initWithTitle:(NSString *)title
                   cancelItem:(STActionItem *)cancelItem
                        items:(NSArray *)items{
    if (self = [self initWithFrame:CGRectZero]){
        _title = title?[title copy]:nil;
        _cancelItem = cancelItem?[STActionItem itemWithAttributedTitle:cancelItem.attributedTitle icon:cancelItem.icon]:nil;
        _items = items?[NSArray arrayWithArray:items]:nil;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                    attribute:(NSDictionary *)attribute
{
    if (self = [self initWithFrame:CGRectZero]){
        _title = title?[title copy]:nil;
        _cancelItem = cancelTitle?[STActionItem itemWithTitle:cancelTitle attribute:attribute]:nil;
        if (otherButtonTitles.count > 0){
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:otherButtonTitles.count];
            for (NSString *otherTitle in otherButtonTitles){
                [items addObject:[STActionItem itemWithTitle:otherTitle attribute:attribute]];
            }
            _items = [NSArray arrayWithArray:items];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectZero]){
        [self loadData];
        [self loadUI];
    }
    return self;
}

- (void)loadData{
    _hideWhenTouchOutside = YES;
    _didLayouted = NO;
    _lines = [NSMutableArray new];
    
    self.modal = [STModal modalWithContentView:self];
    _modal.positionMode = STModelPositionCenterBottom;
    _modal.dimBackgroundWhenShow = YES;
    _modal.dimBackgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [_modal setShowAnimation:[self showAnimation]];
    [_modal setHideAnimation:[self hideAnimation]];
    
    _screenSize = [UIScreen mainScreen].bounds.size;
    _contentWidth = _screenSize.width-2*kSTSheetSidePaddingH;
    _buttonSize = CGSizeMake(_contentWidth, kSTSheetButtonHeight);
}

- (void)loadUI{
    _topContainerView = [STASContainerView new];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [_topContainerView addSubview:_scrollView];
    
    _cancelContainerView = [[STASContainerView alloc] initWithFrame:CGRectMake(0, 0, _buttonSize.width, _buttonSize.height)];
    _cancelButton = [[STASButton alloc] initWithFrame:_cancelContainerView.bounds];
    [_cancelContainerView addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_topContainerView];
}

#pragma mark - getter

- (st_modal_animation)showAnimation{
    return ^CGFloat(){
        self.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(self.frame));
        CGFloat d = 0.35;
        [UIView animateWithDuration:d
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                         }];
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
                             self.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(self.frame)+5);
                         }
                         completion:^(BOOL finished) {
                         }];
        return d;
    };
}

#pragma mark - prepare for show

- (void)reset{
    [_topContainerView removeFromSuperview];
    [_cancelContainerView removeFromSuperview];
    [_otherButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_lines makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_lines removeAllObjects];
    [_otherButtons removeAllObjects];
    [_titleLabel removeFromSuperview];
}

- (void)prepareForShow{
    if (_didLayouted){
        return;
    }
    [self reset];
    
    CGFloat maxActionSheetHeight = _screenSize.height-kSTSheetSidePaddingV;
    CGFloat bottomPadding = kSTSheetSidePaddingV;
    CGFloat maxContentHeight = maxActionSheetHeight-bottomPadding;;
    
    CGFloat cancelHeight = _cancelItem?(kSTSheetButtonHeight):0;
    _maxTopContainerHeight = maxContentHeight-cancelHeight-(_cancelItem?kSTSheetSidePaddingV:0);
    _otherButtonsHeight = kSTSheetButtonHeight*_items.count;
    [self addCancelButton];
    [self addOtherButtons];
    [self addTitle];
    
    CGFloat titleBottom = _title?CGRectGetHeight(_titleLabel.frame)+2*kSTSheetContentPadding:0;
    CGFloat scrollHeight = MIN(_otherButtonsHeight, _maxTopContainerHeight-titleBottom);
    
    CGFloat contentPadding = (((scrollHeight+titleBottom)&&_cancelItem>0)?kSTSheetContentPadding:0);
    CGFloat totalHeight = MIN(maxActionSheetHeight, scrollHeight+titleBottom+cancelHeight+contentPadding+bottomPadding);
    
    self.frame = CGRectMake(kSTSheetSidePaddingH, _screenSize.height-totalHeight-kSTSheetSidePaddingH, _contentWidth,totalHeight);
    _topContainerView.frame = CGRectMake(0, 0, _contentWidth, scrollHeight+titleBottom);
    _scrollView.frame = CGRectMake(0, titleBottom, _contentWidth, scrollHeight);
    _scrollView.contentSize = CGSizeMake(_contentWidth, _otherButtonsHeight);
    _cancelContainerView.frame = CGRectMake(0, CGRectGetMaxY(_topContainerView.frame)+contentPadding, _buttonSize.width, _buttonSize.height);
    
    _didLayouted = YES;
}

- (void)addCancelButton{
    if (!_cancelItem){
        return;
    }
    [self addSubview:_cancelContainerView];
    _cancelButton.item = _cancelItem;
}

- (void)addOtherButtons{
    if (_items.count == 0){
        return;
    }
    if (!_otherButtons){
        _otherButtons = [NSMutableArray new];
    }
    [self addSubview:_topContainerView];
    
    CGFloat iconWidth = kSTSheetButtonHeight-2*kSTSheetContentPadding;
    CGFloat maxWidth = MIN([self maxOtherButtonsTitleWidth],_contentWidth-iconWidth-3*kSTSheetContentPadding);
    CGFloat top = 0;
    for (int i = 0; i < _items.count; i++){
        STASButton *button = [[STASButton alloc] initWithFrame:CGRectMake(0, top, _buttonSize.width, _buttonSize.height)];
        button.tag = i;
        button.item = _items[i];
        button.iconWidth = iconWidth;
        button.exclusiveTouch = YES;
        button.iconPadding = (_contentWidth-maxWidth-button.iconWidth)/3.0;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        [_otherButtons addObject:button];
        [self addLine:CGRectMake(0, top, _buttonSize.width, 0.5) toView:self.scrollView];
        
        top += _buttonSize.height;
    }
}

- (void)addLine:(CGRect)frame toView:(UIView *)view{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [kSTSheetLineColor colorWithAlphaComponent:0.25];
    [view addSubview:line];
    [_lines addObject:line];
}

- (void)addTitle{
    if (!_title){
        return;
    }
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kSTSheetContentPadding, 0, 0)];
        _titleLabel.textColor = [kSTSheetTitleColor colorWithAlphaComponent:0.75];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 20;
    }
    [self addSubview:_topContainerView];
    [_topContainerView addSubview:_titleLabel];
    _titleLabel.text = _title;
    CGFloat titleWidth = _contentWidth-2*kSTSheetContentPadding;
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(titleWidth, 10000)];
    _titleLabel.frame = CGRectMake(kSTSheetContentPadding, kSTSheetContentPadding, titleWidth, size.height);
}

- (CGFloat)maxOtherButtonsTitleWidth{
    __block CGFloat width = 0;
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAttributedString *title = [(STActionItem *)obj attributedTitle];
        CGSize size = [title boundingRectWithSize:CGSizeMake(_contentWidth-kSTSheetContentPadding*2, kSTSheetButtonHeight) options:NSStringDrawingTruncatesLastVisibleLine context:nil].size;
        if (size.width > width){
            width = size.width;
        }
    }];
    return width;
}

#pragma mark - show / hide

- (void)show:(BOOL)animated{
    [self prepareForShow];
    _modal.hideWhenTouchOutside = self.hideWhenTouchOutside;
    _modal.didShowHandler = self.didShowHandler;
    _modal.didHideHandler = self.didHideHandler;
    [_modal show:YES];
}

- (void)hide:(BOOL)animated{
    [_modal hide:YES];
}

#pragma mark - action

- (void)buttonClicked:(UIButton *)button{
    if (_actionHandler){
        _actionHandler(_items[button.tag], button.tag);
    }
    [self hide:YES];
}

- (void)cancelClicked:(UIButton *)button{
    if (_didCancelHandler){
        _didCancelHandler(_cancelItem);
    }
    [self hide:YES];
}

@end



@implementation STActionSheet (Show)

+ (instancetype)showTitle:(NSString *)title
                    items:(NSArray *)items
                   cancel:(STActionItem *)cancelItem{
    return [self showTitle:title items:items cancel:cancelItem actionHandler:nil cancelHandler:nil];
}

+ (instancetype)showItems:(NSArray *)items actionHandler:(st_sheet_action_handler)actionHandler{
    return [self showTitle:nil items:items actionHandler:actionHandler];
}

+ (instancetype)showTitle:(NSString *)title items:(NSArray *)items actionHandler:(st_sheet_action_handler)actionHandler{
    return [self showTitle:title items:items cancel:nil actionHandler:actionHandler cancelHandler:nil];
}

+ (instancetype)showTitle:(NSString *)title
                    items:(NSArray *)items
                   cancel:(STActionItem *)cancelItem
            actionHandler:(st_sheet_action_handler)actionHandler
            cancelHandler:(void(^)(STActionItem *cancelItem))canceledHandler{
    STActionSheet *actionSheet = [[STActionSheet alloc] initWithTitle:title
                                                           cancelItem:cancelItem
                                                                items:items];
    [actionSheet setActionHandler:actionHandler];
    [actionSheet setDidCancelHandler:canceledHandler];
    [actionSheet show:YES];
    return actionSheet;
}

+ (instancetype)showTitle:(NSString *)title
        otherButtonTitles:(NSArray *)otherButtonTitles
                   cancel:(NSString *)cancelTitle
                attribute:(NSDictionary *)attribute{
    return [self showTitle:title otherButtonTitles:otherButtonTitles cancel:cancelTitle  attribute:attribute actionHandler:nil cancelHandler:nil];
}

+ (instancetype)showTitle:(NSString *)title
        otherButtonTitles:(NSArray *)otherButtonTitles
                   cancel:(NSString *)cancelTitle
                attribute:(NSDictionary *)attribute
            actionHandler:(st_sheet_action_handler)actionHandler
            cancelHandler:(void(^)(STActionItem *cancelItem))canceledHandler{
    STActionSheet *actionSheet = [[STActionSheet alloc] initWithTitle:title
                                                          cancelTitle:cancelTitle
                                                    otherButtonTitles:otherButtonTitles
                                                            attribute:attribute];
    [actionSheet setActionHandler:actionHandler];
    [actionSheet setDidCancelHandler:canceledHandler];
    [actionSheet show:YES];
    return actionSheet;
}

@end


#pragma mark ##########################

@implementation STActionItem{
    NSAttributedString *_customAttributedTitle;
}

/**
 * 快速生成
 */
+ (instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithTitle:title icon:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title icon:(UIImage *)icon{
    return [[self alloc] initWithTitle:title icon:icon];
}

+ (instancetype)itemWithAttributedTitle:(NSAttributedString *)attributedTitle{
    return [self itemWithAttributedTitle:attributedTitle icon:nil];
}

+ (instancetype)itemWithAttributedTitle:(NSAttributedString *)attributedTitle icon:(UIImage *)icon{
    return [[self alloc] initWithAttributedTitle:attributedTitle icon:icon];
}

+ (instancetype)itemWithTitle:(NSString *)title attribute:(NSDictionary *)attribute;{
    if (attribute){
        return [self itemWithAttributedTitle:[[NSAttributedString alloc] initWithString:title
                                                                             attributes:attribute]];
    }
    return [self itemWithTitle:title];
}

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon{
    if (self = [super init]){
        _title = title;
        _icon = icon;
    }
    return self;
}

- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle icon:(UIImage *)icon{
    if (self = [super init]){
        _customAttributedTitle = attributedTitle;
        _icon = icon;
    }
    return self;
}

- (NSAttributedString *)attributedTitle{
    if (_customAttributedTitle){
        return _customAttributedTitle;
    }
    else if (_title){
        return [[NSAttributedString alloc] initWithString:_title
                                               attributes:[self defaultAttribute]];
    }
    return nil;
}

- (NSDictionary *)defaultAttribute{
    return @{NSFontAttributeName:[UIFont systemFontOfSize:17],
             NSForegroundColorAttributeName:kSTSheetTitleColor};
}

@end

@implementation STActionItem (Common)

+ (instancetype)desdructiveItem:(NSString *)title{
    return [self desdructiveItem:title icon:nil];
}

+ (instancetype)desdructiveItem:(NSString *)title icon:(UIImage *)icon{
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:title
                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
                                                 NSForegroundColorAttributeName:STModalRGBA(230, 10, 10, 1)}];
    return [self itemWithAttributedTitle:attTitle icon:icon];
}

@end
