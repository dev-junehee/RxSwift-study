//
//  OperatorViewController.swift
//  RxSwift-study
//
//  Created by junehee on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class OperatorViewController: UIViewController {
    
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // setJust()
        // setOf()
        // setFrom()
        setTake()
    }
    
    private func setJust() {
        // 1. Just
        /// Observable Type Ptorocol의 Type Method
        /// 하나의 Element Parameter를 받아 Observable 객체를 리턴
        /// 하나의 값만 Emit
        let itemsA = [3.3, 4.0, 5.0, 1.2, 3.2, 4.9]
        
        let tableData = Observable.just(itemsA)
        
        tableData
            .subscribe { value in
                print("just -", value)
            } onError: { error in
                print("just -", error)
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        /**
         
             just - [3.3, 4.0, 5.0, 1.2, 3.2, 4.9]
             just completed
             just disposed
         
         */
    }
    
    
    // 2. Of
    /// Observable Type Ptorocol의 Type Method
    /// 여러 개의 Element Parameters를 받아 Observable 객체를 리턴
    /// 2개 이상의 값을 Emit
    private func setOf() {
        let itemsA = [3.3, 4.0, 5.0, 1.2, 3.2, 4.9]
        let itemsB = [2.3, 2.0, 1.3]
        
        let tableData = Observable.of(itemsA, itemsB)
        
        tableData
            .subscribe { value in
                print("of -", value)
            } onError: { error in
                print("of -", error)
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        /**
         
             of - [3.3, 4.0, 5.0, 1.2, 3.2, 4.9]
             of - [2.3, 2.0, 1.3]
             of completed
             of disposed
         
         */
    }
    
    
    // 3. From
    /// Array Parameters를 받고, 배열의 각 Element를 Observable로 리턴
    /// 배열의 각 요소를 Emit
    private func setFrom() {
        let itemsA = [3.3, 4.0, 5.0, 1.2, 3.2, 4.9]
        
        let tableData = Observable.from(itemsA)
        
        tableData
            .subscribe { value in
                print("from -", value)
            } onError: { error in
                print("from -", error)
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
        
        /**
         
             from - 3.3
             from - 4.0
             from - 5.0
             from - 1.2
             from - 3.2
             from - 4.9
             from completed
             from disposed
             
         */
    }
    
    
    // 4. Take
    /// 방출된 아이템 중 처음부터 n개까지의 아이템을 내보낸다
    private func setTake() {
        Observable.repeatElement("반복될 무언가")        // 단독으로 사용하면 Mac, Xcode 종료될 수 있음!
            .take(5)                                 // take 메서드를 통해 원하는만큼 출력
            .subscribe { value in
                print("repeat -", value)
            } onError: { error in
                print("repeat -", error)
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        
        /**
         
             repeat - 반복될 무언가
             repeat - 반복될 무언가
             repeat - 반복될 무언가
             repeat - 반복될 무언가
             repeat - 반복될 무언가
             repeat completed
             repeat disposed
                 
         */
    }
    
}
