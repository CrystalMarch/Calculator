//
//  ViewController.swift
//  Calculator
//
//  Created by 朱慧平 on 2017/4/13.
//  Copyright © 2017年 朱慧平. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let caculator = CaculatorView()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        caculator.show()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

