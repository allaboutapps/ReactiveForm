//
//  Toast.swift
//  SmartSpender
//
//  Created by Gunter Hager on 06/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit

enum ToastLevel: String {
    case information = "ℹ️"
    case warning = "⚠️"
    case error = "❌"
    
    var color: UIColor {
        switch self {
        case .information: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .warning: return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case .error: return #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
}

class Toast {
    
    static let shared = Toast()
    
    func show(_ message: String, textColor: UIColor = .white, backgroundColor: UIColor = ToastLevel.information.color, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else { return }
            let toastHeight = CGFloat(44)
            var frame = window.bounds
            frame.origin.y = -toastHeight
            frame.size.height = toastHeight
            
            let view = UIView(frame: frame)
            view.backgroundColor = backgroundColor
            
            let label = UILabel(frame: .zero)
            label.text = message
            label.textColor = textColor
            label.font = UIFont.systemFont(ofSize: 14)
            label.numberOfLines = 3
            
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8).isActive = true
            label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            window.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [],
                           animations: {
                            view.frame.origin.y = UIApplication.shared.statusBarFrame.height
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.5, delay: 3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [],
                                           animations: {
                                            view.frame.origin.y = -toastHeight
                            },
                                           completion: { _ in
                                            view.removeFromSuperview()
                                            completion?()
                            })
            })
        }
    }
    
    func show(_ message: String, level: ToastLevel = .information, completion: (() -> Void)? = nil) {
        print("\(level.rawValue.localizedUppercase) \(message)")
        show(message, backgroundColor: level.color, completion: completion)
    }
    
}
