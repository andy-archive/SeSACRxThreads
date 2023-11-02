//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit

import SnapKit
import RxSwift

final class BirthdayViewController: UIViewController {
    
    private let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    private let nextButton = PointButton(title: "가입하기")
    
    private let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    private let year = BehaviorSubject(value: 2020)
    private let month = BehaviorSubject(value: 10)
    private let day = BehaviorSubject(value: 30)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    private func bind() {
        birthDayPicker.rx.date
            .bind(to: birthday)
            .disposed(by: disposeBag)
        
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
        
        year
            .map { "\($0)년" }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.yearLabel.text = value
            }
            .disposed(by: disposeBag)
        
        month
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.monthLabel.text = "\(value)월"
            }
            .disposed(by: disposeBag)
        
        day
            .map { "\($0)일"}
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @objc private func nextButtonClicked() {
        print("가입 완료")
    }
    
    private func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
