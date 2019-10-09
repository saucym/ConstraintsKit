//
//  ViewController.swift
//  Example-macOS
//
//  Created by saucymqin on 2019/10/9.
//  Copyright © 2019 413132340@qq.com. All rights reserved.
//

import Cocoa
import ConstraintsKit

extension NSView {
    public var backgroundColor: NSColor? {
        get {
            guard let color = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let subView = NSView()
        view.addSubview(subView)
        subView.backgroundColor = .red
        subView.frame = NSRect(x: 15, y: 20, width: 200, height: 120)
//        view.wy_edge(.init(top: 20, left: 15, bottom: 100, right: 15))
        view.wy_left(20)
    }
}

