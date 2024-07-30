//
//  TableViewController.swift
//  RxSwift-study
//
//  Created by junehee on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TableViewController: UIViewController {
    
    private let tableView = UITableView()
    private let label = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        label.backgroundColor = .cyan
        label.textAlignment = .center
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setTableView()
    }
    
    private func setTableView() {
        let items = Observable.just(["1번", "2번", "3번", "4번", "5번"])
        
        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
}
