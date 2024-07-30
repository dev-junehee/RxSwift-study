//
//  SwitchViewController.swift
//  RxSwift-study
//
//  Created by junehee on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SwitchViewController: UIViewController {
    
    private let switchView = UISwitch()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(switchView)
        
        switchView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        setSwitchView()
    }
    
    private func setSwitchView() {
        // Observable: 이벤트를 전달하는 역할
        // of(): 두 개 이상의 elements를 파라미터로 받아 Observable 객체를 반환 (2개 이상의 값을 Emit)
        Observable.of(false)
            .bind(to: switchView.rx.isOn)
            .disposed(by: disposeBag)
        
        // Observable.just(false)
        //     .bind(to: switchView.rx.isOn)
        //     .disposed(by: disposeBag)
    }
    
}
