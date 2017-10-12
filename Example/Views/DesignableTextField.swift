//
//  DesignableTextField.swift
//
//
//  Created by Gunter Hager on 24/05/2017.
//  Copyright © 2017 puck immobilien app services GmbH. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

@IBDesignable
class DesignableTextField: UITextField {
    
    @IBInspectable var activeLineColor: UIColor?
    @IBInspectable var lineColor: UIColor? {
        didSet {
            bottomLine?.backgroundColor = lineColor?.cgColor
        }
    }

    @IBInspectable var labelColor: UIColor? {
        didSet {
            titleLabel?.textColor = labelColor
        }
    }
    
    private var bottomLine: CALayer?
    private var titleLabel: UILabel?
    
    private var titleLabelVisible: Bool = false
    private var disposableBag = CompositeDisposable()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        borderStyle = UITextBorderStyle.none
        
        if bottomLine == nil {
            bottomLine = CALayer()
            layer.addSublayer(bottomLine!)
        }
        bottomLine?.backgroundColor = lineColor?.cgColor
        
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel?.font = UIFont.systemFont(ofSize: 12)
            titleLabel?.text = placeholder
            addSubview(titleLabel!)
            updateLabelVisibility()
        }
        titleLabel?.textColor = labelColor
        
        setPlaceholderText(placeholder ?? "")
        
        disposableBag.dispose()
        disposableBag = CompositeDisposable()
        disposableBag += reactive.controlEvents(.editingChanged).observeValues { [weak self] field in
            self?.updateLabelVisibility()
        }
        disposableBag += reactive.controlEvents(.editingDidBegin).observeValues { [weak self] field in
            self?.bottomLine?.backgroundColor = self?.activeLineColor?.cgColor
        }
        disposableBag += reactive.controlEvents(.editingDidEnd).observeValues { [weak self] field in
            self?.bottomLine?.backgroundColor = self?.lineColor?.cgColor
        }
    }
    
    override var text: String? {
        didSet {
            self.updateLabelVisibility()
        }
    }
    
    func setPlaceholderText(_ text: String) {
        if let color = labelColor {
            attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: color])
        } else {
            placeholder = text
        }
        titleLabel?.text = text
    }
    
    private func updateLabelVisibility() {
        if text?.count == 0 {
            titleLabel?.fadeOut()
            titleLabelVisible = false
        } else {
            if titleLabelVisible == false {
                titleLabel?.fadeIn()
                titleLabelVisible = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine?.frame = CGRect(x: 0, y: frame.height - 8, width: frame.width, height: 1)
        titleLabel?.frame = CGRect(x: 0, y: -20, width: frame.width, height: 20)
    }
    
}
