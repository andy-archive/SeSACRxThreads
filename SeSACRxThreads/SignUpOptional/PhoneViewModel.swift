//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by Taekwon Lee on 2023/11/02.
//

import Foundation

import RxSwift

class PhoneViewModel {
    
    let buttonEnabled = BehaviorSubject(value: false)
    let buttonColor = BehaviorSubject(value: Constants.Color.Button.Background.invalid)
    let phoneNumber = BehaviorSubject(value: "010")
    
    let disposeBag = DisposeBag()
    
    init() {
        phoneNumber
            .map { $0.count > 12 }
            .subscribe(with: self, onNext: { owner, value in
                let color = value ? Constants.Color.Button.Background.valid : Constants.Color.Button.Background.invalid
                owner.buttonColor.onNext(color)
                owner.buttonEnabled.onNext(value)
            })
            .disposed(by: disposeBag)
    }
}
