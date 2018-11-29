//
//  QRCViewController.swift
//  QRCodeScanSwiftDemo
//
//  Created by youmy on 2018/11/29.
//  Copyright © 2018 youmy. All rights reserved.
//

import UIKit

protocol QRCViewControllerDelegate:NSObjectProtocol {
    func didFinishedSacn(controller:QRCViewController, result:String)
}

class QRCViewController: UIViewController {

    @IBOutlet weak var containerHconstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scanLineTopConstrint: NSLayoutConstraint!
    
    @IBOutlet weak var desLb: UILabel!
    
    var delegate:QRCViewControllerDelegate?
    
    var scanView:ScanView?
    
    var isBarCode:Bool = false
    
    var qrcodeType:QRCodeType = QRCode
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scanView = ScanView(frame: UIScreen.main.bounds)
        scanView?.delegate = self
        view.insertSubview(scanView!, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isBarCode {
            qrcodeType = BarCode
            containerHconstraint.constant = (UIScreen.main.bounds.width - 83*2)/2.0
            desLb.text = "将条形码放置在框内，即开始扫描"
        }else{
            qrcodeType = QRCode
            containerHconstraint.constant = UIScreen.main.bounds.width - 83*2
            desLb.text = "将二维码放置在框内，即开始扫描"
        }
        
        scan()
    }

    func scan(){
        startAnimation()
        scanView?.qrcode = qrcodeType
        scanView?.startScan()
    }
    
    /// 冲击波动画
    func startAnimation(){
        scanLineTopConstrint.constant = -scanLineTopConstrint.constant
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.5) {
            self.scanLineTopConstrint.constant = self.containerHconstraint.constant
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        }
    }
}

extension QRCViewController: ScanViewDelegate {
    func typeDidChange(_ scanView: ScanView, rect: CGRect) {
        containerHconstraint.constant = rect.height
    }
    
    func didFinishScan(_ scanView: ScanView, result: String) {

        scanView.delegate = nil
        
        delegate?.didFinishedSacn(controller: self, result: result)
        
        navigationController?.popViewController(animated: true)
    }
}
