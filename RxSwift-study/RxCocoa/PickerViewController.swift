//
//  PickerViewController.swift
//  RxSwift-study
//
//  Created by junehee on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PickerViewController: UIViewController {
    
    private let pickerView = UIPickerView()
    private let label = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(pickerView)
        view.addSubview(label)
        
        pickerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.height.equalTo(140)
        }
        pickerView.backgroundColor = .systemGroupedBackground
        
        label.snp.makeConstraints { make in
            make.bottom.equalTo(pickerView.snp.top).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        label.textAlignment = .center
        
        setPickerView()
    }
    
    private func setPickerView() {
        // Observable: 이벤트를 전달하는 역할
        // just(): element를 파라미터로 받아 Observable 객체를 반환 (하나의 값만 Emit)
        let items = Observable.just(["영화", "드라마", "시리즈", "애니메이션", "다큐멘터리", "기타"])
        
        /**
             
            Observable.just(items)
                .subscribe { value in
                    print(value)
                } onError: { error in
                    print(error)
                } onCompleted: {
                    print("completed")
                } onDisposed: {
                    print("Disposed")
                }
                .disposed(by: disposeBag)
             
         */
                
        items
            .bind(to: pickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        pickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
}
