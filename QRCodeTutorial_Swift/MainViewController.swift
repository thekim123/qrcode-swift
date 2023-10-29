//
//  ViewController.swift
//  QRCodeTutorial_Swift
//
//  Created by media on 2023/10/29.
//

import UIKit
import WebKit
import AVFoundation
import QRCodeReader


class MainViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var qrcodeBtn: UIButton!
    
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton = false
            $0.showOverlayView = false
            $0.rectOfInterest = CGRect(x:0.2, y:0.2, width:0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    
    
    //MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL (string: "https://www.naver.com")
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
        
        qrcodeBtn.layer.borderWidth = 3
        qrcodeBtn.layer.borderColor = UIColor.blue.cgColor
        qrcodeBtn.layer.cornerRadius = 30
        qrcodeBtn.addTarget(self, action: #selector(qrcodeReaderLaunch), for: .touchUpInside)
        

        
    }
    
    //MARK: - fileprivate method
    @objc fileprivate func qrcodeReaderLaunch(){
        print("Main View Controller: qrcodeReaderLaunch() called")
        
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = {( result: QRCodeReaderResult? ) in
            print(result)
            
            guard let scannerUrlString = result?.value else { return }
            print("scannedUrlString : \(scannerUrlString)")
            let scannedUrl = URL(string: scannerUrlString)
            self.webView.load(URLRequest(url: scannedUrl!))
        }
        
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    
    //MARK: - QRCode Reader delegate method
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }


}

