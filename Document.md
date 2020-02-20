---
title: 极致简洁的约束组件
categories: iOS
tages: [iOS,Xcode,NSLayoutConstraint,Layout,ConstraintsKit]
---
众所周知Apple提供的约束接口非常不好用，我们开发的时候基本都是用的第三方开源约束组件(比如Masonry，然后这套组建源码比较多，估计没几个人去完整的看完它的源码)，用起来也不是非常简洁。

虽然iOS9开始Apple已经意识到了这一点做了相应的更新但是他们的接口还是使用比较不方便。当然swift最新的约束写法是要好很多，基本赶上Masonry了，然而我们现在大多项目还是不能完全使用swift，所以objc的约束我们还是要继续用，由于我比较懒，就算swift最新的约束写法也不能满足我，于是我就开始思考有什么办法可以让我们写约束的时候可以非常简单最好一行代码能解决呢。

因为我们大多数App已经从iOS9开始支持了，于是就基于iOS9的UIViewLayoutConstraintCreation封装了一套简单的约束解决方案，所有代码加起来不到200行，非常简单高效只有一个函数不到50行的代码非常容易理解、想加功能接口非常简单。这套组建你只用花几分钟就可以看完源码了，大多数代码都是接口。实现日常编码中大多数约束都能通过一行代码实现。走过路过千万不要错过，200行代码你看了不吃亏看了不上当。

首先上核心代码，就下面这一个宏函数，理解这个函数就差不多理解了整个方案，其它代码几乎都是调用这个函数（可以先不看他，看完后面的展开函数后回来看也一样）

```Objective-C
#define wy_layout_item(value, func, safeArea, propertyName) \
    NSLayoutConstraint *layout = nil;\
    if ([value isKindOfClass:UIView.class] || [value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSLayoutAnchor.class]) {\
        UILayoutGuide *(^wykit_getGuide)(UIView *view) = ^(UIView *view) {\
            if (@available(iOS 11.0, *)) {\
                if (safeArea) block_return view.safeAreaLayoutGuide;\
            }\
            block_return (UILayoutGuide *)view;\
        };\
        \
        UILayoutGuide *guide = wykit_getGuide(self.view.superview);\
        NSLayoutAnchor *xAnchor = [self.view value##Anchor];\
        NSLayoutAnchor *anchor = ([xAnchor isKindOfClass:NSLayoutDimension.class]) ? nil : [guide value##Anchor];\
        CGFloat constant = 0;\
        if ([value isKindOfClass:UIView.class]) {\
            anchor = [wykit_getGuide(value) value##Anchor];\
        } else if ([value isKindOfClass:NSNumber.class]) {\
            constant = [value floatValue];\
        } else if ([value isKindOfClass:NSLayoutAnchor.class]) {\
            anchor = value;\
        }\
        \
        if ([xAnchor isKindOfClass:NSLayoutDimension.class]) {\
            if ([anchor isKindOfClass:NSLayoutDimension.class]) {\
                layout = [(NSLayoutDimension *)xAnchor func##Anchor:(NSLayoutDimension *)anchor constant:constant];\
            } else {\
                layout = [(NSLayoutDimension *)xAnchor func##Constant:constant];\
            }\
        } else {\
            layout = [xAnchor func##Anchor:anchor constant:constant];\
        }\
        layout.active = YES;\
    }\
    self.lastKeyPath = WYPropertyToText(value);\
    [self setValue:layout forKey:self.lastKeyPath];\
    self.lastConstraint = layout;\
```

可以看到里面value支持三种数据类型UIView、NSNumber、NSLayoutAnchor，且支持设置safeArea外加版本判断，还支持lessThan、greaterThan。参考函数式编程和链式调用下面我们实现top equal约束设置接口例子。

```Objective-C
- (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_top {
       return ^id(id top){
           wy_layout_item(top, constraintEqualTo, NO, );
           block_return self;
       };
  }
```

这样我们设置top约束就可以很简单的三种使用方式 

view.wy_top(@0);						//与父识图顶部对其

view.wy_top(otherView);				//与otherView顶部对其

view.wy_top(otherView.bottomAnchor)	//与otherView底部对其

下面附上这个wy_top函数的宏展开源码，可以看看具体实现（比那个宏函数直观一点）

```objective-c
- (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_top {
    return ^id(id top){
        NSLayoutConstraint *layout = nil;
        if ([top isKindOfClass:UIView.class] || [top isKindOfClass:NSNumber.class] || [top isKindOfClass:NSLayoutAnchor.class]) {
            UILayoutGuide *(^wykit_getGuide)(UIView *view) = ^(UIView *view) {
                if (@available(iOS 11.0, *)) {
                    return view.safeAreaLayoutGuide;
                }
                return (UILayoutGuide *)view;
            };
            UILayoutGuide *guide = wykit_getGuide(self.view.superview);
            NSLayoutAnchor *xAnchor = [self.view topAnchor];
            NSLayoutAnchor *anchor = ([xAnchor isKindOfClass:NSLayoutDimension.class]) ? ((void *)0) : [guide topAnchor];
            CGFloat constant = 0;
            if ([top isKindOfClass:UIView.class]) {
                anchor = [wykit_getGuide(top) topAnchor];
            } else if ([top isKindOfClass:NSNumber.class]) {
                constant = [top floatValue];
            } else if ([top isKindOfClass:NSLayoutAnchor.class]) {
                anchor = top;
            } if ([xAnchor isKindOfClass:NSLayoutDimension.class]) {
                if ([anchor isKindOfClass:NSLayoutDimension.class]) {
                    layout = [(NSLayoutDimension *)xAnchor constraintEqualToAnchor:(NSLayoutDimension *)anchor constant:constant];
                } else {
                    layout = [(NSLayoutDimension *)xAnchor constraintEqualToConstant:constant];
                }
            } else {
                layout = [xAnchor constraintEqualToAnchor:anchor constant:constant];
            }
            layout.active = YES;
        }
        self.lastKeyPath = @"top";
        [self setValue:layout forKey:self.lastKeyPath];
        self.lastConstraint = layout;;
        return self;
    };
}
```

就top约束而言还需要实现下面6个接口函数 (因为链式调用所以函数命名尽量简短，不知道各路大神有没有更好的命名方式)

wy_top

wy_top_safeArea

wy_top_less	//这里其实应该是 wy_top_lessThanOrEqualTo 因为会链式调用，所以这里省略了后面部分

wy_top_lessSafeArea

wy_top_greater

wy_top_greaterSafeArea

我们还要实现left、bottom、right、width、height、centerX、centerY，加上top一共八种。

那么一共要实现 6 x 8 = 48个函数转发接口，然而让我一个一个去写是不可能的，所以继续用宏偷懒。如下48个函数搞定

```Objective-C
#define WYConstraintsMethodAchieveWithItem(x) \
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x {\
        return ^id(id x){\
            wy_layout_item(x, constraintEqualTo, NO, );\
            block_return self;\
        };\
    }\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_safeArea {\
        return ^id(id x){\
            wy_layout_item(x, constraintEqualTo, YES, SafeArea);\
            block_return self;\
        };\
    }\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_less {\
        return ^id(id x){\
            wy_layout_item(x, constraintLessThanOrEqualTo, NO, Less);\
            block_return self;\
        };\
    }\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_lessSafeArea {\
        return ^id(id x){\
            wy_layout_item(x, constraintLessThanOrEqualTo, YES, LessSafeArea);\
            block_return self;\
        };\
    }\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_greater {\
        return ^id(id x){\
            wy_layout_item(x, constraintGreaterThanOrEqualTo, NO, Greater);\
            block_return self;\
        };\
    }\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_greaterSafeArea {\
        return ^id(id x){\
            wy_layout_item(x, constraintGreaterThanOrEqualTo, YES, GreaterSafeArea);\
            block_return self;\
        };\
    }

//打包实现接口函数
WYConstraintsMethodAchieveWithItem(top)
WYConstraintsMethodAchieveWithItem(left)
WYConstraintsMethodAchieveWithItem(bottom)
WYConstraintsMethodAchieveWithItem(right)
WYConstraintsMethodAchieveWithItem(width)
WYConstraintsMethodAchieveWithItem(height)
WYConstraintsMethodAchieveWithItem(centerX)
WYConstraintsMethodAchieveWithItem(centerY)
```

后续在用宏把参数替换一下使value可以直接传数字，然后在加上一些方便使用的接口就完工了。

下面可以看一些具体使用的例子

```objective-c
view2.wy_left(view1).wy_right(view1).wy_height(30).wy_top(view1.bottomAnchor).offset(5);

// 如果需要更新上面设置的height可以也可以简单搞定 wy里面可以拿到每一种约束最后设置的那个
view2.wy.heightConstraint.constant = 50;
```

当然感觉这种链式调用太长的还可以使用下面这种等价的使用方式，是不是感觉很熟悉

```objective-c
[view2 wy_makeConstraints:^(WYConstraints *make) {
    make.wy_left(view1);
    make.wy_right(view1);
    make.wy_height(30);
    make.wy_top(view1.bottomAnchor).offset(5);
}];
```

后面用Swift实现一套转发接口兼容Swift（参考源码中的 UIView+WYConstraints.swift），由于不能使用宏，这里复制粘贴了144个函数非常蛋疼，求大神指点更优雅的实现方式。

下面是Swift的两种使用例子

```objective-c
aView.wy_left(100).wy_right(-10).wy_top_safeArea(10).wy_bottom(-100)
    OR
aView.wy_makeConstraints { (make) in
    make?.wy_left(100)
    make?.wy_right(-10)
    make?.wy_top_safeArea(superView).offset(10)
    make?.wy_bottom(-100)
}
```

优点

这个方案实现了几乎所有Masonry实现的功能，兼容系统约束方案，兼容Swift，并且源码非常少非常易于使用和维护以及自定义新功能等。

缺点

只支持iOS9或以上

下面附上[源码和demo地址](https://github.com/saucym/ConstraintsKit.git)

欢迎交流学习以及完善。
