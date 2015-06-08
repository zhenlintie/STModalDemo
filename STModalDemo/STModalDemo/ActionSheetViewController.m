//
//  ActionSheetViewController.m
//  STModalDemo
//
//  Created by zhenlintie on 15/6/7.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "ActionSheetViewController.h"
#import "STActionSheet.h"

@interface ActionSheetViewController ()

@end

@implementation ActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)wxShare:(id)sender {
    NSArray *items = @[[STActionItem itemWithTitle:@"好友" icon:[UIImage imageNamed:@"share_friend"]],
                       [STActionItem itemWithTitle:@"朋友圈" icon:[UIImage imageNamed:@"share_wechat"]]];
    STActionSheet *actionSheet = [[STActionSheet alloc] initWithTitle:@"分享到微信"
                                                          cancelItem:[STActionItem itemWithTitle:@"取消"]
                                                                items:items];
    [actionSheet show:YES];
}
- (IBAction)deleteClicked:(id)sender {
    
    [STActionSheet showTitle:@"确定删除？\n删除后将无法恢复数据"
                       items:@[[STActionItem desdructiveItem:@"删除"]]
                      cancel:[STActionItem itemWithTitle:@"取消"]
               actionHandler:^(STActionItem *item, NSInteger index) {
                   NSLog(@"删除了...");
               }
               cancelHandler:^(STActionItem *cancelItem) {
                   NSLog(@"取消了");
               }];
}
- (IBAction)persons:(id)sender {
    NSDictionary *att = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                          NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0.8 blue:0.95 alpha:0.9]};
    STActionSheet *actionSheet = [[STActionSheet alloc] initWithTitle:@"传奇海贼哥尔·D·罗杰在临死前曾留下关于其毕生的财富“One Piece”的消息，由此引得群雄并起，众海盗们为了这笔传说中的巨额财富展开争夺，各种势力、政权不断交替，整个世界进入了动荡混乱的“大海贼时代”。\n生长在东海某小村庄的路飞受到海贼香克斯的精神指引，决定成为一名出色的海盗。为了达成这个目标，并找到万众瞩目的One Piece，路飞踏上艰苦的旅程。一路上他遇到了无数磨难，也结识了索隆、娜美、乌索普、香吉、罗宾等一众性格各异的好友。他们携手一同展开充满传奇色彩的大冒险。\n\n主要人物："
                                                          cancelTitle:nil
                                                    otherButtonTitles:@[@"蒙奇•D•路飞",
                                                                        @"罗罗诺亚•索隆",
                                                                        @"娜美",
                                                                        @"乌索普",
                                                                        @"山治",
                                                                        @"托尼托尼•乔巴",
                                                                        @"妮可·罗宾",
                                                                        @"弗兰奇",
                                                                        @"布鲁克",
                                                                        @"哥尔·D·罗杰",
                                                                        @"西尔巴兹·雷利",
                                                                        @"爱德华·纽盖特（白胡子）",
                                                                        @"香克斯（红发）",
                                                                        @"马歇尔·D·蒂奇（黑胡子）",
                                                                        @"乔拉可尔·米霍克（鹰眼）"]
                                                            attribute:att];
    actionSheet.hideWhenTouchOutside = YES;
    [actionSheet show:YES];
}

- (IBAction)createBuilding:(id)sender {
    [STActionSheet showTitle:nil
           otherButtonTitles:@[@"楼主",@"1楼",@"2楼",@"3楼",@"4楼",@"5楼",@"6楼",@"7楼",]
                      cancel:nil
                   attribute:nil];
}

@end
