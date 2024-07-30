//
//  TextFieldButtonViewController.swift
//  RxSwift-study
//
//  Created by junehee on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TextFieldButtonViewController: UIViewController {
    
    private let nameTextField = UITextField()
    private let emailTextField = UITextField()
    private let button = UIButton()
    private let label = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(button)
        view.addSubview(label)
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        nameTextField.backgroundColor = .cyan
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        emailTextField.backgroundColor = .yellow
        
        button.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        button.backgroundColor = .systemPink
        button.setTitle("버튼", for: .normal)
        
        
        label.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        label.backgroundColor = .systemGroupedBackground
        
        setSign()
    }
    
    private func setSign() {
        Observable.combineLatest(nameTextField.rx.text.orEmpty, emailTextField.rx.text.orEmpty) { value1, value2 in
            return "이름은 \(value1)이고, 이메일은 \(value2)입니다."
        }
        .bind(to: label.rx.text)
        .disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: emailTextField.rx.isHidden, button.rx.isHidden)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .subscribe { _ in
                // self.showAlert()
                print("Alert를 띄워요")
            }
            .disposed(by: disposeBag)
    }
    
}
