//
//  UITableViewVibrantCell.swift
//  xkcd
//
//  Created by Kevin Cleathero on 2017-09-26.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit
import SideMenu

class UITableViewVibrantCell: UITableViewCell {

    fileprivate var vibrancyView:UIVisualEffectView = UIVisualEffectView()
    fileprivate var vibrancySelectedBackgroundView:UIVisualEffectView = UIVisualEffectView()
    fileprivate var defaultSelectedBackgroundView:UIView?
    
    // For registering with UITableView without subclassing otherwise dequeuing instance of the cell causes an exception
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        vibrancyView.frame = bounds
        vibrancyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        for view in subviews {
            vibrancyView.contentView.addSubview(view)
        }
        addSubview(vibrancyView)
        
        let blurSelectionEffect = UIBlurEffect(style: .light)
        vibrancySelectedBackgroundView.effect = blurSelectionEffect
        defaultSelectedBackgroundView = selectedBackgroundView
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // shouldn't be needed but backgroundColor is set to white on iPad:
        backgroundColor = UIColor.clear
        
        if !UIAccessibilityIsReduceTransparencyEnabled() && SideMenuManager.menuBlurEffectStyle != nil {
            let blurEffect = UIBlurEffect(style: SideMenuManager.menuBlurEffectStyle!)
            vibrancyView.effect = UIVibrancyEffect(blurEffect: blurEffect)
            
            if selectedBackgroundView != nil && selectedBackgroundView != vibrancySelectedBackgroundView {
                vibrancySelectedBackgroundView.contentView.addSubview(selectedBackgroundView!)
                selectedBackgroundView = vibrancySelectedBackgroundView
            }
        } else {
            vibrancyView.effect = nil
            selectedBackgroundView = defaultSelectedBackgroundView
        }
    }
}
