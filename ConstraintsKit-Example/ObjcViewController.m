//
//  ObjcViewController.m
//  ConstraintsKit-Example
//
//  Created by saucymqin on 2018/10/18.
//  Copyright © 2018 413132340@qq.com. All rights reserved.
//

#import "ObjcViewController.h"
#import <ConstraintsKit/ConstraintsKit.h>

@interface ObjcViewController ()

@end

@implementation ObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Objc-Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    view1.userInteractionEnabled = NO;
    [self.view addSubview:view1];
    view1.wy_left(10).wy_right(-10).wy_bottom_safeArea(-50).wy_top_safeArea(10);
    
    UIView *subView1 = [UIView new];
    subView1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    subView1.userInteractionEnabled = NO;
    [view1 addSubview:subView1];
    subView1.wy_edge(UIEdgeInsetsMake(40, 40, -40, -40));
    
    UIView *subView2 = [UIView new];
    subView2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    subView2.userInteractionEnabled = NO;
    [subView1 addSubview:subView2];
    subView2.wy_top(40).wy_left(30).wy_width(100).wy_height(100);
    
    UIView *subView3 = [UIView new];
    subView3.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    subView3.userInteractionEnabled = NO;
    [subView1 addSubview:subView3];
    subView3.wy_top(40).wy_right(-30).wy_width(100).wy_height(100);
    
    UIView *subView4 = [UIView new];
    subView4.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    subView4.userInteractionEnabled = NO;
    [subView1 addSubview:subView4];
    subView4.wy_centerX(subView1).wy_bottom(-20).wy_width(100).wy_height(30);
    
    UIView *subView5 = [UIView new];
    subView5.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    subView5.userInteractionEnabled = NO;
    [subView1 addSubview:subView5];
    subView5.wy_centerX(subView1).wy_width(30).wy_height(10).wy_bottom(subView4.topAnchor).offset(-15);
    
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    view2.userInteractionEnabled = NO;
    [self.view addSubview:view2];
    view2.wy_left(view1).wy_right(view1).wy_height(30).wy_top(view1.bottomAnchor).offset(5);

    // 底部提示按钮
    UILabel *tips = [UILabel new];
    tips.text = @"没有找到文件?";
    tips.textColor = UIColor.grayColor;
    tips.font = [UIFont systemFontOfSize:14];
    UIButton *button = [UIButton new];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"更多帮助" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.darkGrayColor forState:UIControlStateHighlighted];

    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:bgView];
    [bgView addSubview:tips];
    [bgView addSubview:button];
    bgView.wy_left(0).wy_right(0).wy_bottom(0).wy_top(self.view.bottomAnchorSafeArea).offset(-44);

    UILayoutGuide *guide = [UILayoutGuide new];
    [bgView addLayoutGuide:guide];
    tips.wy_left(guide).wy_right(button.leftAnchor).offset(-5).wy_centerY(guide);
    button.wy_right(guide).wy_centerY(guide);
    // TODO: - 扩展UILayoutGuide
    [guide.centerXAnchor constraintEqualToAnchor:bgView.centerXAnchor].active = YES;
    [guide.topAnchor constraintEqualToAnchor:bgView.topAnchor].active = YES;
    [guide.bottomAnchor constraintEqualToAnchor:bgView.bottomAnchorSafeArea].active = YES;
}

@end
