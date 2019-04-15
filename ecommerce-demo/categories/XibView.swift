//
//  XibView.swift
//  Template
//
//  Created by Jason Koo on 10/7/17.
//  Copyright © 2017 jalakoo. All rights reserved.
//
//  BRIEF: Container view for using custom nibs inside other nibs or storyboards
//
//  Original credit to Adrien Cognee:
//  https://medium.com/zenchef-tech-and-product/how-to-visualize-reusable-xibs-in-storyboards-using-ibdesignable-c0488c7f525d

import UIKit

@IBDesignable
class XibView: UIView {

    // By matching the contentView with the variable 'name' and hooked up
    //   in Interface Builder, a UIViewController can be initizalized with
    //   the same nibname and be able to use that .xib file.
    @IBOutlet weak var view: UIView?
    @IBInspectable var nibName: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        guard let nibView = loadViewFromNib() else { return }
        nibView.frame = bounds
        nibView.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(nibView)
        view = nibView
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        view?.prepareForInterfaceBuilder()
    }
}
