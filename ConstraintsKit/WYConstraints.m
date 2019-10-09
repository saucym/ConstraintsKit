//
//  WYConstraints.m
//  WYKit
//
//  Created by saucymqin on 2018/1/30.
//  Copyright © 2018年 413132340@qq.com. All rights reserved.
//

#import "WYConstraints.h"
#import <objc/runtime.h>

#define block_return return
#define WYPropertyToText(x) @#x

typedef NS_OPTIONS(NSUInteger, WYConstraintsProperty) {
    WYConstraintsProperty_none       = 0,
    WYConstraintsProperty_top        = 1 << 0,
    WYConstraintsProperty_left       = 1 << 1,
    WYConstraintsProperty_bottom     = 1 << 2,
    WYConstraintsProperty_right      = 1 << 3,
    WYConstraintsProperty_width      = 1 << 4,
    WYConstraintsProperty_height     = 1 << 5,
    WYConstraintsProperty_centerX    = 1 << 6,
    WYConstraintsProperty_centerY    = 1 << 7,
};

@interface WYConstraints ()

@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) NSLayoutConstraint *lastConstraint;
@property (nonatomic, strong) NSString *lastKeyPath;
@property (nonatomic, assign) WYConstraintsProperty options;
@property (nonatomic, readonly) NSHashTable<NSLayoutConstraint *> *allConstraint;

@end

@implementation WYConstraints

- (instancetype)init {
    NSAssert(NO, @"Call initWithView instead");
    return nil;
}

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        _options = WYConstraintsProperty_none;
        self.view = view;
        _allConstraint = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:1];
    }
    
    return self;
}

- (WYConstraints * (^)(CGFloat))offset {
    return ^id(CGFloat offset){
        self.lastConstraint.constant = offset;
        block_return self;
    };
}

- (WYConstraints * (^)(CGFloat))multiplier {
    return ^id(CGFloat multiplier){
        NSLayoutConstraint *last = self.lastConstraint;
        if (last) {
            NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:last.firstItem attribute:last.firstAttribute relatedBy:last.relation toItem:last.secondItem attribute:last.secondAttribute multiplier:multiplier constant:last.constant];
            last.active = NO;
            layout.active = YES;
            [self setValue:layout forKey:self.lastKeyPath];
            self.lastConstraint = layout;
        }
        block_return self;
    };
}

- (WYConstraints * (^)(UILayoutPriority))priority {
    return ^id(UILayoutPriority priority){
        NSLayoutConstraint *last = self.lastConstraint;
        if (priority == 1000 || last.priority == 1000) {
            //设置最高优先级需要生成新的约束，不然会异常，详情见官方priority注释
            NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:last.firstItem attribute:last.firstAttribute relatedBy:last.relation toItem:last.secondItem attribute:last.secondAttribute multiplier:last.multiplier constant:last.constant];
            layout.priority = priority;
            last.active = NO;
            layout.active = YES;
            [self setValue:layout forKey:self.lastKeyPath];
            self.lastConstraint = layout;
        } else {
            last.priority = priority;
        }
        block_return self;
    };
}

UILayoutGuide *wykit_getGuide(UIView *view, BOOL safeArea) {
#if TARGET_OS_IPHONE
    if (@available(iOS 11.0, *)) {
        if (safeArea) return view.safeAreaLayoutGuide;
    }
#endif
    return (UILayoutGuide *)view;
}

//约束设置函数通用化，只需要看懂这一个函数就可以了
#define wy_layout_item(value, func, safeArea, propertyName) \
    if ([value isKindOfClass:UIView.class] || [value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSLayoutAnchor.class]) {\
        if (self.view.translatesAutoresizingMaskIntoConstraints) {\
            self.view.translatesAutoresizingMaskIntoConstraints = NO;\
        }\
        UILayoutGuide *guide = wykit_getGuide(self.view.superview, safeArea);\
        NSLayoutAnchor *xAnchor = [self.view value##Anchor];\
        NSLayoutAnchor *anchor = ([xAnchor isKindOfClass:NSLayoutDimension.class]) ? nil : [guide value##Anchor];\
        CGFloat constant = 0;\
        if ([value isKindOfClass:UIView.class]) {\
            anchor = [wykit_getGuide(value, safeArea) value##Anchor];\
        } else if ([value isKindOfClass:NSNumber.class]) {\
            constant = [value floatValue];\
        } else if ([value isKindOfClass:NSLayoutAnchor.class]) {\
            anchor = value;\
        }\
        \
        NSLayoutConstraint *layout = nil;\
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
        self.lastKeyPath = WYPropertyToText(value##Constraint);\
        [self setValue:layout forKey:self.lastKeyPath];\
        [self.allConstraint addObject:layout];\
        self.lastConstraint = layout;\
    } else {\
        NSAssert(false, @"WYConstraints value error: %@", (id)value);\
    }

//接口实现函数通用化
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
    }\
    - (WYConstraints *)x {\
        self.options |= WYConstraintsProperty_##x;\
        return self;\
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

- (WYConstraints *)wy_makeConstraints:(void (^)(WYConstraints *make))block {
    if (block) block(self);
    return self;
}

- (WYConstraints * (^)(id<WYConstraintsValueProtocol>))safeAreaEqualTo {
    return ^id(id value) {
        if (self.options & WYConstraintsProperty_top) {
            self.wy_top_safeArea(value);
        }
        if (self.options & WYConstraintsProperty_left) {
            self.wy_left_safeArea(value);
        }
        if (self.options & WYConstraintsProperty_bottom) {
            self.wy_bottom_safeArea(value);
        }
        if (self.options & WYConstraintsProperty_right) {
            self.wy_right_safeArea(value);
        }
        if (self.options & WYConstraintsProperty_width) {
            self.wy_width_safeArea(value);
        }
        if (self.options & WYConstraintsProperty_height) {
            self.wy_height_safeArea(value);
        }
        if (self.options & WYConstraintsProperty_centerX) {
            self.wy_centerX_safeArea(value);
        }
        if (self.options & WYConstraintsProperty_centerY) {
            self.wy_centerY_safeArea(value);
        }
        self.options = WYConstraintsProperty_none;
        block_return self;
    };
}

- (WYConstraints * (^)(id<WYConstraintsValueProtocol>))equalTo {
    return ^id(id value) {
        if (self.options & WYConstraintsProperty_top) {
            self.wy_top(value);
        }
        if (self.options & WYConstraintsProperty_left) {
            self.wy_left(value);
        }
        if (self.options & WYConstraintsProperty_bottom) {
            self.wy_bottom(value);
        }
        if (self.options & WYConstraintsProperty_right) {
            self.wy_right(value);
        }
        if (self.options & WYConstraintsProperty_width) {
            self.wy_width(value);
        }
        if (self.options & WYConstraintsProperty_height) {
            self.wy_height(value);
        }
        if (self.options & WYConstraintsProperty_centerX) {
            self.wy_centerX(value);
        }
        if (self.options & WYConstraintsProperty_centerY) {
            self.wy_centerY(value);
        }
        self.options = WYConstraintsProperty_none;
        block_return self;
    };
}

- (WYConstraints *)invalidAll {
    for (NSLayoutConstraint *layout in  self.allConstraint) {
        layout.active = NO;
    }
    
    [self.allConstraint removeAllObjects];
    return self;
}

@end


@implementation UIView (WYConstraints)

- (WYConstraints *)wy {
    WYConstraints *layout = objc_getAssociatedObject(self, @selector(wy));
    if (!layout) {
        layout = [[WYConstraints alloc] initWithView:self];
        objc_setAssociatedObject(self, @selector(wy), layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return layout;
}

- (WYConstraints * (^)(UIEdgeInsets))wy_edge {
    return ^id(UIEdgeInsets edge){
        block_return self.wy_top(edge.top).wy_left(edge.left).wy_bottom(edge.bottom).wy_right(edge.right);
    };
}

- (WYConstraints * (^)(UIEdgeInsets))wy_edgeSafeArea {
    return ^id(UIEdgeInsets edge){
        block_return self.wy_top_safeArea(edge.top).wy_left_safeArea(edge.left).wy_bottom_safeArea(edge.bottom).wy_right_safeArea(edge.right);
    };
}

- (WYConstraints * (^)(CGSize))wy_size {
    return ^id(CGSize size){
        block_return self.wy_width(size.width).wy_height(size.height);
    };
}

- (WYConstraints *)wy_makeConstraints:(void (^)(WYConstraints *make))block {
    return [self.wy wy_makeConstraints:block];
}

- (WYConstraints *)wy_invalidAll {
    return [self.wy invalidAll];
}

#if TARGET_OS_IPHONE

- (NSLayoutYAxisAnchor *)topAnchorSafeArea {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuide.topAnchor;
    } else {
        return self.topAnchor;
    }
}

- (NSLayoutXAxisAnchor *)leftAnchorSafeArea {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuide.leftAnchor;
    } else {
        return self.leftAnchor;
    }
}

- (NSLayoutYAxisAnchor *)bottomAnchorSafeArea {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuide.bottomAnchor;
    } else {
        return self.bottomAnchor;
    }
}

- (NSLayoutXAxisAnchor *)rightAnchorSafeArea {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuide.rightAnchor;
    } else {
        return self.rightAnchor;
    }
}

#endif

//接口实现函数通用化
#define WYConstraintsViewMethodAchieveWithItem(x)\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x {\
        return [self.wy wy_##x];\
    }\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_safeArea {\
        return [self.wy wy_##x##_safeArea];\
    }\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_less {\
        return [self.wy wy_##x##_less];\
    }\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_lessSafeArea {\
        return [self.wy wy_##x##_lessSafeArea];\
    }\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_greater {\
        return [self.wy wy_##x##_greater];\
    }\
    - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_greaterSafeArea {\
        return [self.wy wy_##x##_greaterSafeArea];\
    }

//打包实现接口函数
WYConstraintsViewMethodAchieveWithItem(top)
WYConstraintsViewMethodAchieveWithItem(left)
WYConstraintsViewMethodAchieveWithItem(bottom)
WYConstraintsViewMethodAchieveWithItem(right)
WYConstraintsViewMethodAchieveWithItem(width)
WYConstraintsViewMethodAchieveWithItem(height)
WYConstraintsViewMethodAchieveWithItem(centerX)
WYConstraintsViewMethodAchieveWithItem(centerY)

@end
