//
//  ViewController.m
//  STModalDemo
//
//  Created by zhenlintie on 15/6/5.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "ViewController.h"
#import "STModalUtil.h"
#import "STFrontModal.h"

@interface ViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (strong, nonatomic) UILabel *aboutLabel;

@end

@implementation ViewController{
    STModal *_aboutModal;
    STModal *_storyModal;
    STModal *_customModal;
    UITableView *_settingTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
}

- (void)test1{
    [self addButton:120 tag:0 title:@"关于"];
    [self addButton:180 tag:1 title:@"故事"];
    [self addButton:260 tag:2 title:@"随机位置"];
    [self addButton:320 tag:3 title:@"设置"];
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
        case 0:{
            [self showAboutModal];
            break;
        }
        case 1:{
            [self showStoryModal];
            break;
        }
        case 2:{
            [self showCustomModal];
            break;
        }
        case 3:{
            [self showSetting];
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
//        _aboutLabel.backgroundColor = [UIColor blackColor];
        _aboutLabel.text = @"这是一个自定义的小标签\n\n\n";
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
        btn.backgroundColor = [UIColor colorWithRed:0.5 green:0.3 blue:0.3 alpha:0.3];
        [btn setTitle:@"看故事" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showStoryModal) forControlEvents:UIControlEventTouchUpInside];
        [_aboutLabel addSubview:btn];
        [_aboutLabel sizeToFit];
    }
    [_aboutModal showContentView:_aboutLabel animated:YES];
}

- (void)showStoryModal{
    if (!_storyModal){
        UILabel *label = [self createLabel];
        label.backgroundColor = [UIColor colorWithRed:0.3 green:0.1 blue:0.5 alpha:.1];
        label.textColor = [UIColor colorWithWhite:0 alpha:1];
        label.text = @"老师把小明叫到了教室外。\n老师：“你的作业做的越来越差了，这是怎么回事？”\n小明：“老师，等我找找原因，下午告诉你好吗？”\n老师：“好吧！”\n下午，老师又把小明叫到了教室外。\n老师：“找到原因了吗？”\n小明：“找到了，我爷爷说作业越来越难，他也没办法。”\n老师：“滚出去！”\n\n\n";
        CGSize s = [label sizeThatFits:CGSizeMake(300, 1000)];
        label.frame = CGRectMake(0, 0, s.width, s.height);
        label.userInteractionEnabled = YES;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, s.height-40, 190, 40)];
        [btn setBackgroundImage:st_imageWithColor([UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]) forState:UIControlStateNormal];
        [btn setTitle:@"显示自定义" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showCustomModal) forControlEvents:UIControlEventTouchUpInside];
        [label addSubview:btn];
        
        _storyModal = [self createModal:label];
        _storyModal.dimBackgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
    }
    [_storyModal show:YES];
}

- (void)showCustomModal{
    if (!_customModal){
        UILabel *customLabel = [self createLabel];
        customLabel.text = @"*****************\n自定义的位置\n*****************";
        customLabel.textColor = [UIColor blackColor];
        [customLabel sizeToFit];
        _customModal = [STModal modalWithContentView:customLabel];
        _customModal.positionMode = STModelPositionCustom;
        _customModal.dimBackgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:.1];
        _customModal.hideWhenTouchOutside = YES;
    }
    _customModal.position = CGPointMake(110+random()%100, 300+random()%200);
    [_customModal show:YES];
}

- (void)showSetting{
    if (!_settingTableView){
        _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300) style:UITableViewStylePlain];
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        [_settingTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _settingTableView.backgroundColor = [UIColor whiteColor];
        _settingTableView.rowHeight = 44;
    
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 300-40, 190, 40)];
        [btn setBackgroundImage:st_imageWithColor([UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]) forState:UIControlStateNormal];
        [btn setTitle:@"显示自定义" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showCustomModal) forControlEvents:UIControlEventTouchUpInside];
        [_settingTableView addSubview:btn];
    }
    [STFrontModal showView:_settingTableView animated:YES];
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

#pragma mark - tableview delegate / datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"点击设置";
    cell.accessoryType = random()%4+1;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [STFrontModal hide:YES];
}

@end
