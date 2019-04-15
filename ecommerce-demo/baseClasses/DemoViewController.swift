//
//  DemoViewController.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/11/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DemoViewController: UIViewController {

    var shouldDisplayNavBar: Bool = false
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    convenience init(title: String,
                     imageName: String,
                     tag: Int) {
        self.init()
        self.tabBarItem = UITabBarItem(title: title, image: UIImage(named:imageName), tag: tag)
        self.title = title
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let name = String(describing: type(of: self))
        TrackingManager.shared.trackView(title: "\(name)", data: nil)
        super.viewDidAppear(animated)
    }
    
}
