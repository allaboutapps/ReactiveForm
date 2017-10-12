//
//  DesignableGradientView.swift
//  
//
//  Created by Gunter Hager on 15.05.17.
//  Copyright © 2017 all about apps. All rights reserved.
//

import UIKit

class DesignableGradientView: DesignableView {

    @IBInspectable var topColor: UIColor? {
        didSet {
            setupGradient()
        }
    }
    
    @IBInspectable var bottomColor: UIColor? {
        didSet {
            setupGradient()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradient()
    }
    
    func setupGradient() {
        if let topColor = topColor, let bottomColor = bottomColor, let gradientLayer = layer as? CAGradientLayer {
            gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        }
    }

}
