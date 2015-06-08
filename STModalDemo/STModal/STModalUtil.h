//
//  Header.h
//  STModalDemo
//
//  Created by zhenlintie on 15/6/7.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//


#define STModalRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

static inline UIImage *st_imageWithColor(UIColor *color){
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}