//
//  UIView+WYConstraints.swift
//  WYConstraints
//
//  Created by saucymqin on 2018/5/29.
//  Copyright © 2018年 413132340@qq.com. All rights reserved.
//

import Foundation

public protocol WYConstraintsValueSwiftProtocol {
    var constraintsValue: WYConstraintsValueProtocol { get }
}

extension NSLayoutXAxisAnchor: WYConstraintsValueSwiftProtocol {
    public var constraintsValue: WYConstraintsValueProtocol {
        return self
    }
}

extension NSLayoutYAxisAnchor: WYConstraintsValueSwiftProtocol {
    public var constraintsValue: WYConstraintsValueProtocol {
        return self
    }
}

extension NSLayoutDimension: WYConstraintsValueSwiftProtocol {
    public var constraintsValue: WYConstraintsValueProtocol {
        return self
    }
}

extension NSNumber: WYConstraintsValueSwiftProtocol {
    public var constraintsValue: WYConstraintsValueProtocol {
        return self
    }
}

extension UIView: WYConstraintsValueSwiftProtocol {
    public var constraintsValue: WYConstraintsValueProtocol {
        return self
    }
}

extension Float: WYConstraintsValueSwiftProtocol {
    public var constraintsValue: WYConstraintsValueProtocol {
        return NSNumber(value: self)
    }
}

extension Int: WYConstraintsValueSwiftProtocol {
    public var constraintsValue: WYConstraintsValueProtocol {
        return NSNumber(value: self)
    }
}

extension Double: WYConstraintsValueSwiftProtocol {
    public var constraintsValue: WYConstraintsValueProtocol {
        return NSNumber(value: self)
    }
}

extension CGFloat: WYConstraintsValueSwiftProtocol {
    public var constraintsValue: WYConstraintsValueProtocol {
        return NSNumber(value: native)
    }
}

public protocol WYConstraintsSwiftProtocol {} // 兼容Swift 这里面全是函数转发 Swift中使用更优雅
public extension WYConstraintsSwiftProtocol where Self: WYConstraintsMethodProtocol {
    @discardableResult func wy_top(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_top()(value.constraintsValue)
    }

    @discardableResult func wy_top_safeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_top_safeArea()(value.constraintsValue)
    }

    @discardableResult func wy_top_less(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_top_less()(value.constraintsValue)
    }

    @discardableResult func wy_top_lessSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_top_lessSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_top_greater(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_top_greater()(value.constraintsValue)
    }

    @discardableResult func wy_top_greaterSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_top_greaterSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_left(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_left()(value.constraintsValue)
    }

    @discardableResult func wy_left_safeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_left_safeArea()(value.constraintsValue)
    }

    @discardableResult func wy_left_less(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_left_less()(value.constraintsValue)
    }

    @discardableResult func wy_left_lessSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_left_lessSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_left_greater(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_left_greater()(value.constraintsValue)
    }

    @discardableResult func wy_left_greaterSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_left_greaterSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_bottom(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_bottom()(value.constraintsValue)
    }

    @discardableResult func wy_bottom_safeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_bottom_safeArea()(value.constraintsValue)
    }

    @discardableResult func wy_bottom_less(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_bottom_less()(value.constraintsValue)
    }

    @discardableResult func wy_bottom_lessSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_bottom_lessSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_bottom_greater(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_bottom_greater()(value.constraintsValue)
    }

    @discardableResult func wy_bottom_greaterSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_bottom_greaterSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_right(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_right()(value.constraintsValue)
    }

    @discardableResult func wy_right_safeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_right_safeArea()(value.constraintsValue)
    }

    @discardableResult func wy_right_less(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_right_less()(value.constraintsValue)
    }

    @discardableResult func wy_right_lessSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_right_lessSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_right_greater(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_right_greater()(value.constraintsValue)
    }

    @discardableResult func wy_right_greaterSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_right_greaterSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_width(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_width()(value.constraintsValue)
    }

    @discardableResult func wy_width_safeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_width_safeArea()(value.constraintsValue)
    }

    @discardableResult func wy_width_less(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_width_less()(value.constraintsValue)
    }

    @discardableResult func wy_width_lessSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_width_lessSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_width_greater(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_width_greater()(value.constraintsValue)
    }

    @discardableResult func wy_width_greaterSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_width_greaterSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_height(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_height()(value.constraintsValue)
    }

    @discardableResult func wy_height_safeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_height_safeArea()(value.constraintsValue)
    }

    @discardableResult func wy_height_less(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_height_less()(value.constraintsValue)
    }

    @discardableResult func wy_height_lessSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_height_lessSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_height_greater(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_height_greater()(value.constraintsValue)
    }

    @discardableResult func wy_height_greaterSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_height_greaterSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_centerX(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerX()(value.constraintsValue)
    }

    @discardableResult func wy_centerX_safeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerX_safeArea()(value.constraintsValue)
    }

    @discardableResult func wy_centerX_less(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerX_less()(value.constraintsValue)
    }

    @discardableResult func wy_centerX_lessSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerX_lessSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_centerX_greater(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerX_greater()(value.constraintsValue)
    }

    @discardableResult func wy_centerX_greaterSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerX_greaterSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_centerY(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerY()(value.constraintsValue)
    }

    @discardableResult func wy_centerY_safeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerY_safeArea()(value.constraintsValue)
    }

    @discardableResult func wy_centerY_less(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerY_less()(value.constraintsValue)
    }

    @discardableResult func wy_centerY_lessSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerY_lessSafeArea()(value.constraintsValue)
    }

    @discardableResult func wy_centerY_greater(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerY_greater()(value.constraintsValue)
    }

    @discardableResult func wy_centerY_greaterSafeArea(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __wy_centerY_greaterSafeArea()(value.constraintsValue)
    }
}

public extension WYConstraintsSwiftProtocol where Self: WYConstraints {
    @discardableResult func equalTo(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __equalTo()(value.constraintsValue)
    }

    @discardableResult func safeAreaEqualTo(_ value: WYConstraintsValueSwiftProtocol) -> WYConstraints {
        return __safeAreaEqualTo()(value.constraintsValue)
    }

    @discardableResult func offset(_ value: Float) -> WYConstraints {
        return __offset()(CGFloat(value))
    }

    @discardableResult func multiplier(_ value: Float) -> WYConstraints {
        return __multiplier()(CGFloat(value))
    }

    @discardableResult func priority(_ value: UILayoutPriority) -> WYConstraints {
        return __priority()(value)
    }
}

public extension WYConstraintsSwiftProtocol where Self: UIView {
    @discardableResult func wy_edge(_ value: UIEdgeInsets) -> WYConstraints {
        return __wy_edge()(value)
    }

    @discardableResult func wy_edgeSafeArea(_ value: UIEdgeInsets) -> WYConstraints {
        return __wy_edgeSafeArea()(value)
    }

    @discardableResult func wy_size(_ value: CGSize) -> WYConstraints {
        return __wy_size()(value)
    }
}

extension WYConstraints: WYConstraintsSwiftProtocol {}
extension UIView: WYConstraintsSwiftProtocol {}
