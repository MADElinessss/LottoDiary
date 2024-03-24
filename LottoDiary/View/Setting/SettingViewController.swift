//
//  SettingViewController.swift
//  LottoDiary
//
//  Created by Madeline on 3/7/24.
//

import MessageUI
import SnapKit
import UIKit

class SettingViewController: BaseViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(title: "설정", leftBarButton: nil, rightBarButton: nil)
        configure()
    }
    
    func configure() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(200)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 15
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles = ["알림 설정", "개인정보 처리방침", "문의하기"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            let vc = WebViewController(urlString: "https://purple-edge-98a.notion.site/2d131ab9e7254e20a25bf268864465fd?pvs=4", navigationTitle: "개인정보 처리방침")
            
            navigationController?.pushViewController(vc, animated: true)
        } else {
            sendEmail()
        }
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["jyseen@naver.com"]) // 받는 사람의 이메일 주소
            mail.setSubject("문의하기") // 이메일 제목
            mail.setMessageBody("<p>여기에 메시지를 작성하세요.</p>", isHTML: true) // 이메일 본문, HTML 포맷 사용 가능
            
            present(mail, animated: true)
        } else {
            // 사용자가 메일 계정을 설정하지 않았다면 여기서 알림을 표시
            print("Mail services are not available")
        }
    }
    
    // 메일 컴포즈 뷰 컨트롤러 델리게이트 메서드 구현
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
