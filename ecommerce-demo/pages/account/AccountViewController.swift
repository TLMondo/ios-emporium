//
//  AccountViewController.swift
//  ecommerce-demo
//
//  Created by Tealium User on 10/19/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

class AccountViewController: DemoViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logout(){
        triggerEmptyBlock(named:"logout")
    }

}
