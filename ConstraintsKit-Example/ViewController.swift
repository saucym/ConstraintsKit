//
//  ViewController.swift
//  ConstraintsKit-Example
//
//  Created by saucymqin on 2018/10/18.
//  Copyright © 2018 413132340@qq.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Swift-Demo";
        self.view.backgroundColor = .white
        let aView = UIView()
        aView.backgroundColor = .red
        self.view.addSubview(aView)
        aView.wy_left(self.view).offset(100).wy_right(-10).wy_top_safeArea(10).wy_bottom(-100)
        /* 如果不喜欢上面的写法可以用下面的这种  效果一样
         aView.wy_makeConstraints { (make) in
             make?.wy_left(100)
             make?.wy_right(-10)
             make?.wy_top_safeArea(self.view).offset(10)
             make?.wy_bottom(-100)
         }
         */
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Objc-Demo", style: .plain, target: self, action: #selector(pushObjcDemo))
    }
    
    @objc func pushObjcDemo() {
        self.navigationController?.pushViewController(ObjcViewController(), animated: true)
    }
}

