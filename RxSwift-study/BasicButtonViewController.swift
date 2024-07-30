//
//  ViewController.swift
//  RxSwift-study
//
//  Created by junehee on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BasicButtonViewController: UIViewController {
    
    private let button = UIButton()
    private let label = UILabel()
    private let secondLabel = UILabel()

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /**
     Observable Stream (Observable Sequence)
     - Infinite Observable : 무한한 시퀀스. 계속해서 이벤트를 전달하는 것들. 대체적으로 UI와 관련되어 있다.
     - Finite Observable : 유한한 시퀀스. 이벤트의 종료 시점이 존재하는 것들. (Next, Completed, Error)
     */
    
    
    // MARK: Infinite Observable (무한한 시퀀스)
    // UI와 관련되어 있는 것들
    private func infiniteObservable() {
        // 1. subscribe(onNext: onError: onCompleted: onDisposed)
        button.rx.tap
            .subscribe { _ in
                // 버튼을 클릭했을 때 (next 호출)
                self.label.text = "버튼을 클릭했어요"
                print("Next")
            } onError: { error in
                // 오류가 발생했을 때 (디코딩 실패, 상태코드 오류, 네트워크 유실 ...)
                print("Error", error)
            } onCompleted: {
                // 이벤트가 완료된 시점
                print("Completed")
            } onDisposed: {
                // 시퀀스가 종료되는 시점
                print("Disposed")
            }
            .disposed(by: disposeBag)

        
        // 2. 생략
        /// Tap과 같은 UI Gesture에서는 Error가 발생하는 일, 이벤트가 끝나는 일이 없다.
        /// 사용자가 1번, 100번, 1000번을 눌러도 매번 이벤트가 발생해야 한다 = 이벤트가 종료될 일이 없음!
        /// 따라서 Error, Completed 구문이 필요없게 된다.
        button.rx.tap
            .subscribe { _ in
                // 버튼을 클릭했을 때 (next 호출)
                self.label.text = "버튼을 클릭했어요"
                print("Next")
            } onDisposed: {
                // 시퀀스가 종료되는 시점
                print("Disposed")
            }
            .disposed(by: disposeBag)

        
        // 3. 메모리 누수 (memory leak) - (1)
        /// 클로져 구문에서 발생하는 메모리 누수를 방지
        /// Swift 문법으로 해결하는 부분
        button.rx.tap
            .subscribe { [weak self] _ in
                // 버튼을 클릭했을 때 (next 호출)
                self?.label.text = "버튼을 클릭했어요"
                print("Next")
            } onDisposed: {
                // 시퀀스가 종료되는 시점
                print("Disposed")
            }
            .disposed(by: disposeBag)

        
        // 4. 메모리 누수 (memory leak) - (2)
        /// [weak self]를 통해 메모리 누수를 관리하던 코드를 RxSwift 구문으로 처리할 수 있다.
        /// RxSwift의 withUnretained() 메서드로 해결
        /// 클로저 구문에서 [weak self] 코드와 self? 옵셔널을 작성하지 않아도 약한 참조가 된다.
        button.rx.tap
            .withUnretained(self)
            .subscribe { _ in
                // 버튼을 클릭했을 때 (next 호출)
                self.label.text = "버튼을 클릭했어요"
                print("Next")
            } onDisposed: {
                // 시퀀스가 종료되는 시점
                print("Disposed")
            }
            .disposed(by: disposeBag)
        
        
        // 5. 메모리 누수 (memory leak) - (3)
        /// RxSwift에서 메모리 누수 방지를 위해 widthUnretained() 메서드를 반복적으로 작성하게 된다.
        /// 반복되는 코드를 줄이기 위해 subscribe() 메서드 내에서 매개변수를 통해 처리될 수 있도록 할 수 있다.
        /// subscribe(with: ~ )
        button.rx.tap
            .subscribe(with: self) { owner, _ in
                // 버튼을 클릭했을 때 (next 호출)
                owner.label.text = "버튼을 클릭했어요"
                print("Next")
            } onDisposed: { _ in
                // 시퀀스가 종료되는 시점
                print("Disposed")
            }
            .disposed(by: disposeBag)

        
        // 여기부터는 UIKit!
        
        // 6. Thread - (1)
        /// subscribe 메서드는 스레드가 보장되지 않기 때문에 background에서도 계속 동작될 가능성이 있다.
        /// 만약 네트워크 통신이 섞이거나 스레드가 복잡하게 얽히면 보라색 오류가 발생할 수 있다.
        /// 따라서 DispatchQueue.main을 통해 메인 스레드에서 동작할 수 있도록 처리해주어야 함!
        button.rx.tap
            .subscribe(with: self) { owner, _ in
                // 버튼을 클릭했을 때 (next 호출)
                DispatchQueue.main.async {
                    owner.label.text = "버튼을 클릭했어요"
                    print("Next")
                }
            } onDisposed: { _ in
                // 시퀀스가 종료되는 시점
                print("Disposed")
            }
            .disposed(by: disposeBag)

        
        // 7. Thread - (2)
        /// 매번 DispatchQueue.main(...) 코드를 반복적으로 사용하게 되는 부분 발생
        /// 역시 RxSwift에서 처리될 수 있도록 제공되는 메서드를 사용할 수 있다.
        /// observer(on: )
        button.rx.tap
            .observe(on: MainScheduler.instance)    /// 이후에 진행되는 코드는 Main Thread에서 할게! 라는 의미
            .subscribe(with: self) { owner, _ in
                // 버튼을 클릭했을 때 (next 호출)
                owner.label.text = "버튼을 클릭했어요"
                print("Next")
            } onDisposed: { _ in
                // 시퀀스가 종료되는 시점
                print("Disposed")
            }
            .disposed(by: disposeBag)
        
        
        // 8. bind
        /// observe 메서드를 통해 Main Thread로 동작시켜주는 코드 또한 반복적으로 작성될 수 있다. (Infinite Observable는 UI 관련, UI는 Main Thread에서 처리)
        /// 따라서 이 부분도 하나의 메서드에서 동작할 수 있도록 래핑을 해주고 싶어진다.
        /// 그리고 Tap Guesture는 애초에 Error를 발생시키지 않기 때문에, 불필요한 부분을 받지 않는 더 좋은 방법을 찾게됨!
        /// bind(with: onNext )
        button.rx.tap
            .bind(with: self) { owner, _ in
                owner.label.text = "버튼을 클릭했어요"
            }
            .disposed(by: disposeBag)
        
        
        // 9. bind to
        /// 특정뷰에 데이터를 다이렉트로 할당하고 싶을 때 사용할 수 있다.
        button.rx.tap
            .map { "버튼을 클릭했어요" }       // Observable<String>
            .bind(to: label.rx.text)      // 데이터를 넣기를 원하는 뷰
            .disposed(by: disposeBag)
        
        button.rx.tap
            .map { "버튼을 클릭했어요" }
            .bind(to: label.rx.text, secondLabel.rx.text)   // 여러 개의 뷰를 선택할 수도 있다.
            .disposed(by: disposeBag)
    }

}

