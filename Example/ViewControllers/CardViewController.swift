//
//  CardViewController.swift
//  
//
//  Created by Gunter Hager on 05/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class CardViewController: UIViewController {
    
    @IBOutlet weak var primaryButton: DesignableButton!
    @IBOutlet weak var secondaryButton: DesignableButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cardBottomConstraint: NSLayoutConstraint!

    var viewModel: CardViewModel?
    
    
    @IBAction func primaryAction(_ sender: Any) {
        viewModel?.primaryAction(viewController: self)
    }
    
    @IBAction func secondaryAction(_ sender: Any) {
        viewModel?.secondaryAction(viewController: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        
        viewModel?.dataSource.reloadData(tableView, animated: false)
        viewModel?.viewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = viewModel?.tintColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.viewDidAppear()
    }
    
    private func setupUI() {
        
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        primaryButton.reactive.isHidden <~ viewModel.primaryActionSettings.map { $0 == nil }
        primaryButton.reactive.title(for: .normal) <~ viewModel.primaryActionSettings.map { $0?.title.localizedUppercase ?? "" }
        primaryButton.reactive.isEnabled <~ viewModel.primaryActionIsEnabled
        
        secondaryButton.reactive.isHidden <~ viewModel.secondaryActionSettings.map { $0 == nil }
        secondaryButton.reactive.title(for: .normal) <~ viewModel.secondaryActionSettings.map { $0?.title ?? "" }
        secondaryButton.reactive.isEnabled <~ viewModel.secondaryActionIsEnabled
        
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        
        Keyboard.shared.heightInfo.producer.startWithValues { [weak self] heightInfo in
            guard let `self` = self else { return }
            let minBottom: CGFloat = {
                if self.primaryButton.isHidden {
                    return 22 + 36
                } else if self.secondaryButton.isHidden {
                    return 36
                } else {
                    return 0
                }
            }()
            self.cardBottomConstraint.constant = (heightInfo.keyboardHeight < minBottom) ? minBottom : heightInfo.keyboardHeight + 8
            UIView.animate(withDuration: heightInfo.animationDuration, delay: 0.0, options: heightInfo.animationOptions, animations: { [weak self] in
                self?.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    static func create(with viewModel: CardViewModel) -> CardViewController {
        let controller: CardViewController = UIStoryboard(.main).instantiateViewController()
        controller.viewModel = viewModel
        controller.view.tintColor = viewModel.tintColor
        return controller
    }
    
}
