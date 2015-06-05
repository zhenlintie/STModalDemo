# 自定义弹出视图

## STModal介绍

* 特点

	1. 只需关心需要弹出的视图
	2. 可自定义动画
	3. 当弹出多个视图时，以栈的方式显示

* 用法

```
UIView *contentView = [UIView new];
...

STModal *modal = [STModal modalWithContentView:contentView];
[modal show:YES];

//或者
STModal *modal = [STModal modal];
[modal showContentView:contentView animated:YES];

```
* 截图

![](/STModelDemo/raw/master/screenshot.png)