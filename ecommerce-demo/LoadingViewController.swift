//
//  ViewController.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/9/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

class LoadingViewController: DemoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logic.run(rootViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

