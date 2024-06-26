//
//  QRCodeViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/12/24.
//

import AVFoundation
import SafariServices
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
        
        guard captureDevice != nil else {
            self.handle(error: QRCodeError.invalidDeviceInput)
            return
        }
        
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice!)
        } catch {
            self.handle(error: QRCodeError.invalidDeviceInput)
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
    
    func handle(error: QRCodeError) {
        AlertManager.shared.showOKayAlert(on: self, title: "오류 발생", message: error.localizedDescription)
    }
    
    private func metaObjectTypes() -> [AVMetadataObject.ObjectType] {
        return [.qr]
    }
}

extension QRCodeViewController {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print("1")
        if let metadataObject = metadataObjects.first {
            
            // guard let data = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            
            guard let data = metadataObject as? AVMetadataMachineReadableCodeObject else {
                self.handle(error: QRCodeError.invalidQRCode)
                return
            }
            
            if let url = data.stringValue {
                captureSession.stopRunning()
                
                let urlToView = URL(string: url)
                let safariView: SFSafariViewController = SFSafariViewController(url: urlToView!)
                self.present(safariView, animated: true, completion:  nil)
                
                // let vc = QRCodeWebViewController()
                // vc.url = data.stringValue ?? "https://www.dhlottery.co.kr/"
                // navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

//final class QRCodeWebViewController: UIViewController, WKNavigationDelegate {
//    var webView: WKWebView!
//    var url: String = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        print("🐙qr view didload")
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        view.addSubview(webView)
//        webView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).inset(44)
//            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
//        
//        guard let url = URL(string: url) else { return }
//        print("🐙qr url", url)
//        let request = URLRequest(url: url)
//        webView.load(request)
//        
//        navigationItem.title = "로또 결과 확인"
//        
//        let backButton = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backTapped))
//        navigationItem.leftBarButtonItem = backButton
//    }
//    
//    @objc func backTapped() {
//        if webView.canGoBack {
//            webView.goBack()
//        } else {
//            navigationController?.popViewController(animated: true)
//        }
//    }
//}
