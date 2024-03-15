//
//  QRCodeViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/12/24.
//

import AVFoundation
import UIKit
import Vision
import WebKit

final class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice!)
        } catch {
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
    }
    
    private func metaObjectTypes() -> [AVMetadataObject.ObjectType] {
        return [.qr
        ]
    }
}

extension QRCodeViewController {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print("1")
        if let metadataObject = metadataObjects.first {
            guard let data = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            print("🚨", data.stringValue)
            /*
             data 형식
             <AVMetadataMachineReadableCodeObject: 0x2807c5240, type="org.iso.QRCode", bounds={ 0.3,0.4 0.2x0.3 }>corners { 0.3,0.6 0.3,0.4 0.5,0.4 0.5,0.7 }, time 278607246217916, stringValue "https://www.instagram.com/madeline_s3?utm_source=qr"
             */
            if let url = data.stringValue {
                captureSession.stopRunning()
                let vc = QRCodeWebViewController()
                vc.url = data.stringValue ?? "https://www.dhlottery.co.kr/"
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

final class QRCodeWebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(44)
        }
        
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        
        navigationItem.title = "로또 결과 확인"
        
        let backButton = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backTapped() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
