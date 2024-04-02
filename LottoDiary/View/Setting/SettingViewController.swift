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
        let settingTableView = SettingTableView()
        view.addSubview(settingTableView)
        settingTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(180)
        }
        
        settingTableView.didSelectItemAtIndex = { [weak self] index in
            // 각 항목 선택 시 처리
            switch index {
            case 0:
                self?.openAppSettings()
            case 1:
                self?.openPrivacyPolicy()
            case 2:
                self?.sendEmail()
            default:
                break
            }
        }
    }
    
    private func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            AlertManager.shared.showOKayAlert(on: self, title: "네트워크 오류", message: "잘못된 접근이에요. 네트워크를 다시 확인해주세요.")
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    func openPrivacyPolicy() {
        let urlString = "https://purple-edge-98a.notion.site/2d131ab9e7254e20a25bf268864465fd?pvs=4"
        guard let url = URL(string: urlString) else {
            AlertManager.shared.showOKayAlert(on: self, title: "네트워크 오류", message: "잘못된 접근이에요. 네트워크를 다시 확인해주세요. 문제가 계속되면 지원팀에 연락해주세요.")
            return
        }
        let vc = WebViewController(urlString: url.absoluteString, navigationTitle: "개인정보 처리방침")
        navigationController?.pushViewController(vc, animated: true)
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
