//
//  WYConstraints.h
//  WYKit
//
//  Created by saucymqin on 2018/1/30.
//  Copyright © 2018年 413132340@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WYConstraintsValueProtocol<NSObject> //目前参数支持三个类型 UIView、NSLayoutAnchor、NSNumber
@end

@class WYConstraints;
@protocol WYConstraintsMethodProtocol<NSObject>

#define WYConstraintsViewMethodWithItem(x) \
        - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x NS_REFINED_FOR_SWIFT;\
        - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_safeArea NS_REFINED_FOR_SWIFT;\
        - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_less NS_REFINED_FOR_SWIFT;\
        - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_lessSafeArea NS_REFINED_FOR_SWIFT;\
        - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_greater NS_REFINED_FOR_SWIFT;\
        - (WYConstraints * (^)(id<WYConstraintsValueProtocol>))wy_##x##_greaterSafeArea NS_REFINED_FOR_SWIFT;

WYConstraintsViewMethodWithItem(top)
WYConstraintsViewMethodWithItem(left)
WYConstraintsViewMethodWithItem(bottom)
WYConstraintsViewMethodWithItem(right)
WYConstraintsViewMethodWithItem(width)
WYConstraintsViewMethodWithItem(height)
WYConstraintsViewMethodWithItem(centerX)
WYConstraintsViewMethodWithItem(centerY)

@end

NS_CLASS_AVAILABLE_IOS(9_0)
@interface WYConstraints : NSObject<WYConstraintsMethodProtocol>

//直接设置刚刚些的那个约束 这里提供快捷方法
- (WYConstraints * (^)(CGFloat))offset NS_REFINED_FOR_SWIFT;
- (WYConstraints * (^)(CGFloat))multiplier NS_REFINED_FOR_SWIFT;
- (WYConstraints * (^)(UILayoutPriority))priority NS_REFINED_FOR_SWIFT;

//只保存最后一次设置那个
@property (nonatomic, readonly, weak, nullable) NSLayoutConstraint *topConstraint;
@property (nonatomic, readonly, weak, nullable) NSLayoutConstraint *leftConstraint;
@property (nonatomic, readonly, weak, nullable) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, readonly, weak, nullable) NSLayoutConstraint *rightConstraint;
@property (nonatomic, readonly, weak, nullable) NSLayoutConstraint *widthConstraint;
@property (nonatomic, readonly, weak, nullable) NSLayoutConstraint *heightConstraint;
@property (nonatomic, readonly, weak, nullable) NSLayoutConstraint *centerXConstraint;
@property (nonatomic, readonly, weak, nullable) NSLayoutConstraint *centerYConstraint;

@property (nonatomic, readonly) WYConstraints *top;
@property (nonatomic, readonly) WYConstraints *left;
@property (nonatomic, readonly) WYConstraints *bottom;
@property (nonatomic, readonly) WYConstraints *right;
@property (nonatomic, readonly) WYConstraints *width;
@property (nonatomic, readonly) WYConstraints *height;
@property (nonatomic, readonly) WYConstraints *centerX;
@property (nonatomic, readonly) WYConstraints *centerY;

- (WYConstraints * (^)(id<WYConstraintsValueProtocol>))equalTo NS_REFINED_FOR_SWIFT;
- (WYConstraints * (^)(id<WYConstraintsValueProtocol>))safeAreaEqualTo NS_REFINED_FOR_SWIFT;
#define equalTo(...)            equalTo(WYKitBoxValue((__VA_ARGS__)))
#define safeAreaEqualTo(...)    safeAreaEqualTo(WYKitBoxValue((__VA_ARGS__)))

- (WYConstraints *)wy_makeConstraints:(void (^)(WYConstraints *make))block; /**< 设置好约束后可以定制一些偏移值 */
- (WYConstraints *)invalidAll; /**< 使所有用该组件添加的约束都失效 */

@end

@interface NSLayoutAnchor (WYConstraints)<WYConstraintsValueProtocol>
@end

@interface NSNumber (WYConstraints)<WYConstraintsValueProtocol>
@end

@interface UIView (WYConstraints)<WYConstraintsValueProtocol, WYConstraintsMethodProtocol>

@property (nonatomic,readonly) NSLayoutYAxisAnchor *topAnchorSafeArea;   /**< 会自动判断是iOS11以上就使用safeArea属性，否则就使用普通属性 */
@property (nonatomic,readonly) NSLayoutXAxisAnchor *leftAnchorSafeArea;
@property (nonatomic,readonly) NSLayoutYAxisAnchor *bottomAnchorSafeArea;
@property (nonatomic,readonly) NSLayoutXAxisAnchor *rightAnchorSafeArea;

@property (nonatomic, readonly) WYConstraints *wy; /**< 约束入口，懒加载的 如果没有设置过就会自动生成 */
- (WYConstraints * (^)(UIEdgeInsets))wy_edge NS_REFINED_FOR_SWIFT;  /**< 直接根据边缘设置约束 */
- (WYConstraints * (^)(UIEdgeInsets))wy_edgeSafeArea NS_REFINED_FOR_SWIFT;
- (WYConstraints * (^)(CGSize))wy_size NS_REFINED_FOR_SWIFT;
- (WYConstraints *)wy_makeConstraints:(void (^)(WYConstraints *make))block;
- (WYConstraints *)wy_invalidAll; /**< 使所有用该组件添加的约束都失效 */

@end

#pragma mark - 下面的代码可以让参数更智能(比如直接传数字)，当然也可以不要

//  Given a scalar or struct value, wraps it in NSValue
//  Based on EXPObjectify: https://github.com/specta/expecta
static inline id _WYKitBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(v, UIEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

#define WYKitBoxValue(value) _WYKitBoxValue(@encode(__typeof__((value))), (value))

#pragma mark - 使用下面的宏定义转换后所有参数都可以直接传数字了

#define wy_top(...)                     wy_top(WYKitBoxValue((__VA_ARGS__)))
#define wy_top_safeArea(...)            wy_top_safeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_top_less(...)                wy_top_less(WYKitBoxValue((__VA_ARGS__)))
#define wy_top_lessSafeArea(...)        wy_top_lessSafeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_top_greater(...)             wy_top_greater(WYKitBoxValue((__VA_ARGS__)))
#define wy_top_greaterSafeArea(...)     wy_top_greaterSafeArea(WYKitBoxValue((__VA_ARGS__)))

#define wy_left(...)                    wy_left(WYKitBoxValue((__VA_ARGS__)))
#define wy_left_safeArea(...)           wy_left_safeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_left_less(...)               wy_left_less(WYKitBoxValue((__VA_ARGS__)))
#define wy_left_lessSafeArea(...)       wy_left_lessSafeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_left_greater(...)            wy_left_greater(WYKitBoxValue((__VA_ARGS__)))
#define wy_left_greaterSafeArea(...)    wy_left_greaterSafeArea(WYKitBoxValue((__VA_ARGS__)))

#define wy_bottom(...)                  wy_bottom(WYKitBoxValue((__VA_ARGS__)))
#define wy_bottom_safeArea(...)         wy_bottom_safeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_bottom_less(...)             wy_bottom_less(WYKitBoxValue((__VA_ARGS__)))
#define wy_bottom_lessSafeArea(...)     wy_bottom_lessSafeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_bottom_greater(...)          wy_bottom_greater(WYKitBoxValue((__VA_ARGS__)))
#define wy_bottom_greaterSafeArea(...)  wy_bottom_greaterSafeArea(WYKitBoxValue((__VA_ARGS__)))

#define wy_right(...)                   wy_right(WYKitBoxValue((__VA_ARGS__)))
#define wy_right_safeArea(...)          wy_right_safeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_right_less(...)              wy_right_less(WYKitBoxValue((__VA_ARGS__)))
#define wy_right_lessSafeArea(...)      wy_right_lessSafeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_right_greater(...)           wy_right_greater(WYKitBoxValue((__VA_ARGS__)))
#define wy_right_greaterSafeArea(...)   wy_right_greaterSafeArea(WYKitBoxValue((__VA_ARGS__)))

#define wy_width(...)                   wy_width(WYKitBoxValue((__VA_ARGS__)))
#define wy_width_safeArea(...)          wy_width_safeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_width_less(...)              wy_width_less(WYKitBoxValue((__VA_ARGS__)))
#define wy_width_lessSafeArea(...)      wy_width_lessSafeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_width_greater(...)           wy_width_greater(WYKitBoxValue((__VA_ARGS__)))
#define wy_width_greaterSafeArea(...)   wy_width_greaterSafeArea(WYKitBoxValue((__VA_ARGS__)))

#define wy_height(...)                  wy_height(WYKitBoxValue((__VA_ARGS__)))
#define wy_height_safeArea(...)         wy_height_safeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_height_less(...)             wy_height_less(WYKitBoxValue((__VA_ARGS__)))
#define wy_height_lessSafeArea(...)     wy_height_lessSafeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_height_greater(...)          wy_height_greater(WYKitBoxValue((__VA_ARGS__)))
#define wy_height_greaterSafeArea(...)  wy_height_greaterSafeArea(WYKitBoxValue((__VA_ARGS__)))

#define wy_centerX(...)                 wy_centerX(WYKitBoxValue((__VA_ARGS__)))
#define wy_centerX_safeArea(...)        wy_centerX_safeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_centerX_less(...)            wy_centerX_less(WYKitBoxValue((__VA_ARGS__)))
#define wy_centerX_lessSafeArea(...)    wy_centerX_lessSafeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_centerX_greater(...)         wy_centerX_greater(WYKitBoxValue((__VA_ARGS__)))
#define wy_centerX_greaterSafeArea(...) wy_centerX_greaterSafeArea(WYKitBoxValue((__VA_ARGS__)))

#define wy_centerY(...)                 wy_centerY(WYKitBoxValue((__VA_ARGS__)))
#define wy_centerY_safeArea(...)        wy_centerY_safeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_centerY_less(...)            wy_centerY_less(WYKitBoxValue((__VA_ARGS__)))
#define wy_centerY_lessSafeArea(...)    wy_centerY_lessSafeArea(WYKitBoxValue((__VA_ARGS__)))
#define wy_centerY_greater(...)         wy_centerY_greater(WYKitBoxValue((__VA_ARGS__)))
#define wy_centerY_greaterSafeArea(...) wy_centerY_greaterSafeArea(WYKitBoxValue((__VA_ARGS__)))
 
NS_ASSUME_NONNULL_END
