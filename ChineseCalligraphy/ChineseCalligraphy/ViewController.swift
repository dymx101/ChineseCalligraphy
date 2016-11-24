//
//  ViewController.swift
//  ChineseCalligraphy
//
//  Created by Dong, Yiming (Agoda) on 11/24/2559 BE.
//  Copyright © 2559 Dong, Yiming (Agoda). All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        self.view = CalligraphyView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

