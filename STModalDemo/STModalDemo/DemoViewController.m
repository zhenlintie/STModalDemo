//
//  DemoViewController.m
//  STModalDemo
//
//  Created by zhenlintie on 15/6/5.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "DemoViewController.h"
#import "STAlertView.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)tip:(id)sender {
    STAlertView *alert = [[STAlertView alloc] initWithTitle:@"海贼王"
                                                      image:[UIImage imageNamed:@"onepiece.jpeg"]
                                                    message:@"传奇海贼哥尔·D·罗杰在临死前曾留下关于其毕生的财富“One Piece”的消息，由此引得群雄并起，众海盗们为了这笔传说中的巨额财富展开争夺，各种势力、政权不断交替，整个世界进入了动荡混乱的“大海贼时代”。\n生长在东海某小村庄的路飞受到海贼香克斯的精神指引，决定成为一名出色的海盗。为了达成这个目标，并找到万众瞩目的One Piece，路飞踏上艰苦的旅程。一路上他遇到了无数磨难，也结识了索隆、娜美、乌索普、香吉、罗宾等一众性格各异的好友。他们携手一同展开充满传奇色彩的大冒险。"
                                               buttonTitles:@[@"查看更多",@"不看了",@"查看更多",@"不看了",@"查看更多",@"不看了"]];

    alert.hideWhenTapOutside = YES;
    [alert setDidShowHandler:^{
        NSLog(@"显示了");
    }];
    [alert setDidHideHandler:^{
        NSLog(@"消失了");
    }];
    [alert setActionHandler:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://baike.baidu.com/link?url=puPuzaUO9pAbfCUuJygbsxhrO6ZCXaUeatthEUEcJHRkGskVaciOLfQ1JK_PTtIiZntrID_VtO5TQxtsd1TnrEUJF1UoPGTjXjGk4-swLnWE1GN2J6n0TS81-7bKdQiFpRX1FihvRNcDOCifv7WnldMKoX9MbtmbCvLUw4_ui-BCURimyIOuMXToghtTwA2P"]];
                break;
            }
            default:
                break;
        }
    }];
    [alert show:YES];
}

- (IBAction)notif:(id)sender {
    NSString *title = @"通知";
    NSString *message = @"您的手机已经欠费了，速交！";
////    [STAlertView showTitle:nil message:message];
////    [STAlertView showTitle:title message:message hideDelay:2];
////    [STAlertView showTitle:title message:nil];
    [STAlertView showTitle:title
                     image:nil
                   message:message
              buttonTitles:@[@"这就去",@"就不交"]
                   handler:^(NSInteger index) {
                       
                   }];
    
}

@end
