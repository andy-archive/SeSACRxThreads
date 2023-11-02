//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class PhoneViewController: UIViewController {
    
    private let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    private let nextButton = PointButton(title: "다음")
    
    private let viewModel = PhoneViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    private func bind() {
        viewModel.buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.buttonColor
            .bind(to: nextButton.rx.backgroundColor, phoneTextField.rx.tintColor)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.buttonColor
            .map { $0.cgColor }
            .bind(to: phoneTextField.layer.rx.borderColor)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.phoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .subscribe { value in
                let formatted = value.formated(by: "###-####-####")
                self.viewModel.phoneNumber.onNext(formatted)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    @objc private func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    
    private func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
