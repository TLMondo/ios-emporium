//
//  SettingsViewController.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/11/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import IBAnimatable
import DTTextField

class SettingsViewController: DemoViewController {

    
    @IBOutlet weak var pageDescription: UITextView!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var accountField: DTTextField!
    @IBOutlet weak var profileField: DTTextField!
    @IBOutlet weak var envField : DTTextField!
    @IBOutlet weak var datasourceField: DTTextField!
    @IBOutlet weak var traceField: DTTextField!
    @IBOutlet weak var saveButton: AnimatableButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save() {
        triggerEmptyBlock(named: "save")
    }

    @IBAction func openCustomData(_ sender: Any) {
        triggerEmptyBlock(named: "openCustomData")
    }
    
    @IBAction func switchChanged() {
        triggerEmptyBlock(named: "updateUI")
    }
}

extension SettingsViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        triggerEmptyBlock(named: "updateUI")
    }
    
}
