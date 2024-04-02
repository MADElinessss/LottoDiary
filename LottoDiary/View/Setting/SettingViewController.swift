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
        
        configureNavigationBar(title: "설정", rightBarButton: nil)
        configure()
    }
    
    func configure() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(180)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 15
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles = ["알림 설정", "개인정보 처리방침", "문의하기"]
        let images = ["bell.circle.fill", "info.circle.fill", "bubble.circle.fill"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        let cellImage = UIImage(systemName: images[indexPath.row])
        cellImage?.withTintColor(.point)
        cell.imageView?.image = cellImage
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
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
            mail.setToRecipients(["jyseen@naver.com"])
            mail.setSubject("문의하기")
            mail.setMessageBody("<p>여기에 메시지를 작성하세요.</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            print("Mail services are not available")
            AlertManager.shared.showOKayAlert(on: self, title: "메일 전송 실패", message: "문의를 보낼 수 없습니다. 아이폰 메일 설정을 확인해주세요.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
