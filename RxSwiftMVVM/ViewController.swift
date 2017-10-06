//
//  ViewController.swift
//  RxSwiftMVVM
//
//  Created by Dalton Claybrook on 10/6/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var emailsLabel: UILabel!
    @IBOutlet private var getCommentsButton: UIButton!
    @IBOutlet private var loadingView: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindButtonToViewModel()
        observeLoading()
        observeEmailString()
    }
    
    // MARK: Private
    
    private func bindButtonToViewModel() {
        self.getCommentsButton
            .rx
            .tap
            .asObservable()
            .bind(to: self.viewModel.tapObserver)
            .disposed(by: disposeBag)
    }
    
    private func observeLoading() {
        self.viewModel
            .isLoadingObservable
            .bind(to: self.loadingView.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
    
    private func observeEmailString() {
        self.viewModel
            .emailStringObservable
            .bind(to: self.emailsLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
