//
//  WebViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/11/24.
//

import SnapKit
import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadURL()
        setupNavigationBar()
    }
    
    func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func loadURL() {
        guard let url = URL(string: "https://www.dhlottery.co.kr/") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "로또 구매하기"
        
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
