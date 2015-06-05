//
//  ViewController.m
//  STModalDemo
//
//  Created by zhenlintie on 15/6/5.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UILabel *aboutLabel;

@end

@implementation ViewController{
    STModal *_aboutModal;
    STModal *_storyModal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
}

- (void)test1{
    [self addButton:120 tag:0 title:@"关于"];
    [self addButton:180 tag:1 title:@"故事"];
}

- (void)addButton:(CGFloat)top tag:(NSInteger)tag title:(NSString *)title{
    UIButton *tap = [UIButton buttonWithType:UIButtonTypeSystem];
    tap.frame = CGRectMake(120, top, 80, 45);
    tap.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [tap setTitle:title forState:UIControlStateNormal];
    tap.tag = tag;
    tap.backgroundColor = [UIColor lightGrayColor];
    [tap addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tap];
}

- (void)tapped:(UIButton *)button{
    switch (button.tag) {
        case 0:
        {
             [self showAboutModal];
            break;
        }
        case 1:
        {
            [self showStoryModal];
            break;
        }
        default:
            break;
    }
   
}

- (void)showAboutModal{
    if (!_aboutModal){
        _aboutModal = [self createModal:nil];
    }
    if (!_aboutLabel){
        _aboutLabel = [self createLabel];
        _aboutLabel.userInteractionEnabled = YES;
        _aboutLabel.text = @"这是一个自定义的小标签\n\n\n";
        UIButton *showStory = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
        showStory.backgroundColor = [UIColor colorWithRed:0.5 green:0.3 blue:0.3 alpha:0.3];
        [showStory setTitle:@"看故事" forState:UIControlStateNormal];
        showStory.tag = 1;
        [showStory addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        [_aboutLabel addSubview:showStory];
        [_aboutLabel sizeToFit];
    }
    [_aboutModal showContentView:_aboutLabel animated:YES];
}

- (void)showStoryModal{
    if (!_storyModal){
        UILabel *label = [self createLabel];
        label.backgroundColor = [UIColor colorWithRed:0.3 green:0.1 blue:0.5 alpha:0.7];
        label.text = @"老师把小明叫到了教室外。\n老师：“你的作业做的越来越差了，这是怎么回事？”\n小明：“老师，等我找找原因，下午告诉你好吗？”\n老师：“好吧！”\n下午，老师又把小明叫到了教室外。\n老师：“找到原因了吗？”\n小明：“找到了，我爷爷说作业越来越难，他也没办法。”\n老师：“滚出去！”";
        CGSize s = [label sizeThatFits:CGSizeMake(300, 1000)];
        label.frame = CGRectMake(0, 0, s.width, s.height);
        _storyModal = [self createModal:label];
    }
    [_storyModal show:YES];
}

- (UILabel *)createLabel{
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithWhite:1 alpha:0.85];
    return label;
}

- (STModal *)createModal:(UIView *)contentView{
    STModal *modal = [STModal modalWithContentView:contentView];
    modal.hideWhenTouchOutside = YES;
    return modal;
}

@end
