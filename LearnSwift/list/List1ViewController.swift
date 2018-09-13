//
//  List1ViewController.swift
//  LearnSwift
//
//  Created by liushungxi on 2018/9/11.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit

class List1ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func start(_ sender: Any) {
        timer.fireDate = Date.distantPast
    }
    @IBAction func pasue(_ sender: Any) {
        timer.fireDate = Date.distantFuture
    }
    @IBAction func reStare(_ sender: Any) {
        temp = 0
        timeLabel.text = "\(temp)"
        timer.fireDate = Date.distantFuture
    }
    var timer = Timer()
    override func viewDidLoad() {
        timeLabel.text = "0"
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(time), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        timer.fire()
    }
    var temp = 0
    @objc func time() {
        temp += 1
        timeLabel.text = "\(temp)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
