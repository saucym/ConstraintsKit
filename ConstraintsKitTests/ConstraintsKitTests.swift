//
//  ConstraintsKitTests.swift
//  ConstraintsKitTests
//
//  Created by saucymqin on 2019/12/5.
//  Copyright © 2019 413132340@qq.com. All rights reserved.
//

import XCTest
@testable import ConstraintsKit

class TTView: UIView {
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 34, right: 30)
    }

    private var vDict = [UIView : (frame: () -> CGRect, line: Int)]()

    /// 添加一个新的子view，调整约束，然后跟传入的frame对比
    func test(_ line: Int = #line, frame: @escaping @autoclosure () -> CGRect, make: (UIView, TTView) -> Void) {
        let sub = UIView()
        sub.tag = line
        addSubview(sub)
        make(sub, self)
        layoutIfNeeded()
        XCTAssertEqual(sub.frame, frame(), "line: \(line)")
        vDict[sub] = (frame: frame, line: line)
    }

    func checkFrame() {
        subviews.forEach { (sub) in
            let value = vDict[sub]!
            XCTAssertEqual(sub.frame, value.frame(), "check: \(value.line)")
        }
    }
}

class ConstraintsKitTests: XCTestCase {
    let view = TTView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    var width: CGFloat {
        return view.frame.width
    }

    var height: CGFloat {
        return view.frame.height
    }

    var frame: CGRect {
        return view.frame
    }

    var safeAreaFrame: CGRect {
        return view.frame.inset(by: view.safeAreaInsets)
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOne() {
        // index 0
        view.test(frame: self.frame) { (v, _) in
            v.wy_edge(.zero)
        }

        view.test(frame: CGRect(x: 10, y: 20, width: 100, height: 150)) { (v, _) in
            v.wy_size(CGSize(width: 100, height: 150)).wy_left(10).wy_top(20)
        }

        view.test(frame: self.frame) { (v, _) in
            v.wy_makeConstraints { (make) in
                make.left.right.top.bottom.equalTo(0)
            }
        }

        view.test(frame: self.frame) { (v, _) in
            v.wy.wy_make { (make) in
                make.left.right.top.bottom.equalTo(0)
            }
        }

        view.test(frame: self.frame) { (v, _) in
            v.wy.left.right.top.bottom.equalTo(0)
        }

        view.test(frame: self.frame) { (v, _) in
            v.wy_left(0).wy_right(view).top.equalTo(0).bottom.equalTo(view)
        }

        view.test(frame: self.safeAreaFrame) { (v, _) in
            v.wy_edgeSafeArea(.zero)
        }

        view.test(frame: self.safeAreaFrame) { (v, _) in
            v.wy.left.right.top.bottom.safeAreaEqualTo(0)
        }

        view.test(frame: self.safeAreaFrame) { (v, _) in
            v.wy_left_safeArea(0).wy_right_safeArea(0).wy_top_safeArea(0).wy_bottom_safeArea(0)
        }

        view.test(frame: self.safeAreaFrame) { (v, _) in
            v.wy_left(view.leftAnchorSafeArea).wy_right(view.rightAnchorSafeArea).wy_top_safeArea(0).wy_bottom_safeArea(0)
        }

        view.test(frame: self.safeAreaFrame) { (v, _) in
            v.wy_left_safeArea(0).wy_right_safeArea(0).wy_top(view.topAnchorSafeArea).wy_bottom(view.bottomAnchorSafeArea)
        }

        view.test(frame: CGRect(x: 15, y: 25, width: self.width - 10 - 15, height: self.height - 20 - 25)) { (v, _) in
            v.wy_left(15).wy_right(-10).wy_top(25).wy_bottom(-20)
        }

        view.test(frame: self.frame) { (v, _) in
            v.wy_left(15).priority(.defaultLow).wy_right(-10).priority(.defaultLow).wy_top(25).priority(.defaultLow).wy_bottom(-20).priority(.defaultLow)
            v.wy_edge(.zero)
        }

        view.test(frame: CGRect(x: 15, y: 25, width: self.width - 10 - 15, height: self.height - 20 - 25)) { (v, _) in
            v.wy_left(0).offset(15).wy_right(0).offset(-10).wy_top(0).offset(25).wy_bottom(0).offset(-20)
        }

        view.test(frame: CGRect(x: 0, y: 20, width: self.width, height: self.height - 20)) { (v, _) in
            v.wy_left(0).wy_right(0).wy_top(view.topAnchorSafeArea).wy_bottom(0)
        }

        view.test(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height)) { (v, _) in
            v.wy_left(0).wy_right(0).wy_width(view).wy_height(view)
        }

        view.test(frame: CGRect(x: 0, y: 0, width: self.width * 0.5, height: self.height * 0.4)) { (v, _) in
            v.wy_left(0).wy_top(0).wy_width(view.widthAnchor).multiplier(0.5).wy_height(view.heightAnchor).multiplier(0.4)
        }

        view.test(frame: .zero) { (v, _) in
            v.wy_left(0).wy_right(0).wy_top(view.topAnchorSafeArea).wy_bottom(0).invalidAll()
        }

        view.test(frame: .zero) { (v, _) in
            v.wy_left(0).wy_right(0).wy_top(view.topAnchorSafeArea).wy_bottom(0)
            v.wy_invalidAll()
        }
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        testOne()

        view.frame = CGRect(x: 0, y: 0, width: 4000, height: 5000)
        view.layoutIfNeeded()
        view.checkFrame()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
