//
//  ValidationCell.swift
//  
//
//  Created by Gunter Hager on 19/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource
import ReactiveSwift

public class ValidationCell: FormFieldCell, AutoRegisterCell {
    private var titleLabel: UILabel!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        customInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        customInit()
    }
    
    private func customInit() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .white
        titleLabel = UILabel()
        titleLabel.textColor = .red
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    var onReload: (() -> Void)? = nil
    
    public func configure(field: FormField<ValidationState>) {
        super.configure(field: field)
        guard field.type == .validation else { return }
        var lastText: String?
        disposable += field.content.producer.startWithValues { [weak self] state in
            guard let `self` = self,
                let state = state else { return }
            var text = field.validationErrorText
            switch state {
            case let .info(message):
                text = message ?? text
            case let .warning(message):
                text = message ?? text
            case let .error(message):
                text = message ?? text
            default:
                break
            }
            self.titleLabel.text = text
            // if the error text changes, the height of the label (and thus the cell) might change -> reload cell
            if lastText != self.titleLabel.text && lastText != nil {
                self.onReload?()
            }
            lastText = self.titleLabel.text
        }
    }
    
}

public extension ValidationCell {
    
    static var descriptor: CellDescriptor<FormField<ValidationState>, ValidationCell> {
        return CellDescriptor("ValidationCell", bundle: Bundle(for: ValidationCell.self))
            .configure { (field, cell, _) in
                cell.configure(field: field)
        }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}
