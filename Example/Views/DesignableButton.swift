//
//  DesignableButton.swift
//  
//
//  Created by Gunter Hager on 15.05.17.
//  Copyright © 2016 all about apps. All rights reserved.
//

import UIKit
import SimpleButton

@IBDesignable

class DesignableButton: SimpleButton {
    
    // Note: Explicit types are needed for @IBInspectables to work even though we give a default value
    
    @IBInspectable var backgroundColorNormal: UIColor?
    @IBInspectable var backgroundColorHighlight: UIColor?
    @IBInspectable var backgroundColorDisabled: UIColor?
    @IBInspectable var titleColorNormal: UIColor?
    @IBInspectable var titleColorHighlighted: UIColor?
    @IBInspectable var titleColorDisabled: UIColor?
    
    @IBInspectable var shadow: Bool = false
    @IBInspectable var shadowColor: UIColor?
    @IBInspectable var shadowOffset: CGSize = CGSize.zero
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowOpacity: Float = 0
    
    @IBInspectable var cornerRadiusNormal: CGFloat = 0
    @IBInspectable var cornerRadiusHiglighted: CGFloat = 0
    
    @IBInspectable var borderColor: UIColor?
    @IBInspectable var borderWidth: CGFloat = 0
    
    override func configureButtonStyles() {
        super.configureButtonStyles()
        
        // Colors
        
        if let backgroundColorNormal = backgroundColorNormal {
            setBackgroundColor(backgroundColorNormal, for: .normal)
        }
        if let backgroundColorHighlight = backgroundColorHighlight {
            setBackgroundColor(backgroundColorHighlight, for: .highlighted)
        }
        if let backgroundColorDisabled = backgroundColorDisabled {
            setBackgroundColor(backgroundColorDisabled, for: .disabled)
        }
        if let titleColorNormal = titleColorNormal {
            setTitleColor(titleColorNormal, for: .normal)
        }
        if let titleColorHighlighted = titleColorHighlighted {
            setTitleColor(titleColorHighlighted, for: .highlighted)
        }
        if let titleColorDisabled = titleColorDisabled {
            setTitleColor(titleColorDisabled, for: .disabled)
        }
        
        // Shadow
        
        if shadow {
            if let shadowColor = shadowColor {
                setShadowColor(shadowColor)
            }
            setShadowOffset(shadowOffset)
            setShadowRadius(shadowRadius)
            setShadowOpacity(shadowOpacity)
        }
        
        // Rounded corners
        
        setCornerRadius(cornerRadiusNormal, for: .normal, animated: true)
        setCornerRadius(cornerRadiusHiglighted, for: .highlighted, animated: true)
        
        // Border
        if let borderColor = borderColor {
            setBorderColor(borderColor)
        }
        setBorderWidth(borderWidth)
    }
    
    
}
