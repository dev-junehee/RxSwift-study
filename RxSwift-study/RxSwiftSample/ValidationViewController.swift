//
//  ValidationViewController.swift
//  RxSwift-study
//
//  Created by junehee on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ValidationViewController: UIViewController {
    
    private let nameLabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    private let userTextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        return view
    }()
    private let userValidation = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let passwordLabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    private let passwordTextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        return view
    }()
    private let passwordValidation = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let button = {
        let button = UIButton()
        button.setTitle("버튼", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    // 이름 비밀번호 최소
    private let minUsernameLength = 3
    private let minPasswordLength = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        userValidation.text = "이름은 \(minUsernameLength)자리 이상이어야 합니다."
        passwordValidation.text = "비밀번호는 \(minPasswordLength)자리 이상이어야 합니다."
        
        let userValid = userTextField.rx.text.orEmpty
            .map { $0.count >= self.minUsernameLength }
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= self.minPasswordLength }
        
        let buttonValid = Observable.combineLatest(userValid, passwordValid) { $0 && $1 } // username && password 다 통과하면
            .share(replay: 1)
        
        userValid
            .bind(to: passwordTextField.rx.isEnabled) // 이름 유효성 검사 통과 -> 비밀번호 텍스트 필드 Enabled 처리
            .disposed(by: disposeBag)
        
        userValid
            .bind(to: userValidation.rx.isHidden)   // 이름 유효성 검사 통과 -> 이름 유효성 레이블 숨김 처리
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidation.rx.isHidden)   // 비밀번호 유효성 검사 통과 -> 비밀번호 유효성 레이블 숨김 처리
            .disposed(by: disposeBag)
        
        buttonValid
            .bind(to: button.rx.isEnabled)    // 버튼 유효성 검사 통과 -> 버튼 Enabled 처리
            .disposed(by: disposeBag)
        
        button.rx.tap   // 버튼 탭 -> Alert
            .subscribe(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Button Clicked!",
            message: "모든 유효성이 통과되어 버튼을 누를 수 있게 되었어용",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        let views = [nameLabel, userTextField, userValidation, passwordLabel, passwordTextField, passwordValidation, button]
        views.forEach { view.addSubview($0) }
        
        nameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        userTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        userValidation.snp.makeConstraints { make in
            make.top.equalTo(userTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(userValidation.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        passwordValidation.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(passwordValidation.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
    }
    
}
