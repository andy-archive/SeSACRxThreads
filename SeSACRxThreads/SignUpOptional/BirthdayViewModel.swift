//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by Taekwon Lee on 2023/11/02.
//

import Foundation

import RxSwift

class BirthdayViewModel {
    
    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    let year = BehaviorSubject(value: 2020)
    let month = BehaviorSubject(value: 10)
    let day = BehaviorSubject(value: 30)
    
    let disposeBag = DisposeBag()
    
    init() {
        birthday
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                guard let year = component.year,
                      let month = component.month,
                      let day = component.day
                else { return }
                
                owner.year.onNext(year)
                owner.month.onNext(month)
                owner.day.onNext(day)
            }
            .disposed(by: disposeBag)
    }
}
