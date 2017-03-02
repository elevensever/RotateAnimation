//
//  ViewController.swift
//  RotateAnimation
//
//  Created by elevenjian on 2017/3/2.
//  Copyright © 2017年 elevenjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var numSlider: UISlider!
    
    lazy var rotateView:RotateView = {
        
        return RotateView(frame:CGRect(x: 0, y: 0, width: 300, height: 300))
        
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置slider最大值和最小值
        numSlider.minimumValue = 1
        numSlider.maximumValue = 12
        
        view.addSubview(rotateView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changeCount(_ sender: Any) {
        guard sender as! NSObject == numSlider else{ return }
        label.text = String(Int(numSlider.value))
        rotateView.count = Int(numSlider.value)
        rotateView.updateNum(count: Int(numSlider.value))
        

    }
       
}

