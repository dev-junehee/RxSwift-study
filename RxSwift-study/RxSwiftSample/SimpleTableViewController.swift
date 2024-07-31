//
//  SimpleTableViewController.swift
//  RxSwift-study
//
//  Created by junehee on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleTableViewController: UIViewController, UITableViewDelegate {
    
    private lazy var tableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
                cell.accessoryType = .detailButton  // 셀 액세서리 타입 변경
            }
            .disposed(by: disposeBag)
        
        tableView.rx   // 셀
            .modelSelected(String.self)
            .subscribe(with: self) { owner, value in
                owner.showAlertForCell(value)
            }
            .disposed(by: disposeBag)
        
        tableView.rx   // 액세서리 버튼
            .itemAccessoryButtonTapped
            .subscribe(with: self) { owner, indexPath in
                owner.showAlertForAccessory(indexPath)
            }
            .disposed(by: disposeBag)
    }
    
    private func showAlertForCell(_ value: String) {
        let alert = UIAlertController(
            title: "셀 클릭!",
            message: value,
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlertForAccessory(_ value: IndexPath) {
        let alert = UIAlertController(
            title: "액세서리 버튼 클릭!",
            message: "\(value.section)번째 섹션, \(value.row)번째 셀을 선택했어용",
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
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
}
