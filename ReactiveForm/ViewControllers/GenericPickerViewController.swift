//
//  GenericPickerViewController.swift
//  
//
//  Created by Michael Heinzl on 07.08.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveSwift

public class GenericPickerViewController: ModalViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet public weak var picker: UIPickerView!
    
    public var viewModel: GenericPickerViewModelProtocol!
    
    public var didPickValue: ((GenericPickerViewModelProtocol) -> Void)?
    
    // MARK: UIViewController
    
    override public func viewDidLoad() {
        super.viewDidLoad()
                
        picker.delegate = self
        picker.dataSource = self
        
        let selectedIndex = viewModel.items.index { (item) -> Bool in
            guard let propertyValue = viewModel.selectedItem.value else { return false }
            return item.title == propertyValue.title
        }
        
        if let selectedIndex = selectedIndex {
            picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
        
        setupUI()
        
    }
    
    private func setupUI() {
        titleLabel.text = viewModel.title
        cancelButton.setTitle(viewModel.cancelButtonTitle, for: .normal)
        submitButton.setTitle(viewModel.submitButtonTitle, for: .normal)
    }
    
    // MARK: DataSource
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.items.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.items[row].title
    }
    
    // MARK: Actions
    
    @IBAction public func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction public func submit() {
        viewModel.selectedItem.value = viewModel.items[picker.selectedRow(inComponent: 0)]
        didPickValue?(viewModel)
        dismiss(animated: true, completion: nil)
    }
}
