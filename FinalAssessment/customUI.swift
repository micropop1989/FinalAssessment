//
//  customUI.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 26/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import Foundation
import UIKit



class CustomUI {
    
    func showActivityIndicatory(uiView: UIView, container : UIView, loadingView : UIView, activityIndicator : UIActivityIndicatorView) {
        //container  = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 0.3)
        //container.isHidden = false
        
        
        // loadingView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        // activityIndicator = UIActivityIndicatorView()
        // activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func dismissActivityIndicatory(container : UIView, activityIndicator : UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        container.removeFromSuperview()
    }
    
    
    private var gradientLayer: CAGradientLayer?
    
    func setGradientBackgroundColor(view: UIView, firstColor: UIColor, secondColor: UIColor) {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = view.bounds
        gradientLayer?.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer?.opacity = 0.7
        view.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    func setLoginLabel(lable : UILabel) {
        lable.textColor = UIColor.orange
        lable.shadowColor = UIColor.white
        lable.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    func setButtonDesign(button : UIButton, color : UIColor) {
        button.layer.cornerRadius = 15.0;
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 3.0
        button.backgroundColor = UIColor.clear
        button.tintColor = color
    }
    
    func createBoxView(boxView : UIView, contentView : UIView) {
        boxView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        boxView.layer.cornerRadius = 3.0
        boxView.layer.masksToBounds = false
        
        boxView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        boxView.layer.shadowOffset = CGSize(width: 1, height: 1)
        boxView.layer.shadowOpacity = 0.8
    }
    

}

extension UIColor {
    
    @nonobjc static let midNightBlue = UIColor(red:25.0/255, green:25.0/255, blue:112.0/255, alpha:1.0)
    
    
    @nonobjc static let dodgerBlue = UIColor(red:30.0/255, green:144.0/255, blue:255.0/255, alpha:1.0)
    
}

