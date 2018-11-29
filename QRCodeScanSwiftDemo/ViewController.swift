//
//  ViewController.swift
//  QRCodeScanSwiftDemo
//
//  Created by youmy on 2018/11/29.
//  Copyright © 2018 youmy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        btn.setTitle("扫描", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(scan(sender:)), for: .touchUpInside)
        view.addSubview(btn)
    }

    @objc func scan(sender:UIButton){
        let vc = QRCViewController()
        vc.isBarCode = true
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: QRCViewControllerDelegate {
    func didFinishedSacn(controller: QRCViewController, result: String) {
        print("--->result:\(result)")
    }
}
