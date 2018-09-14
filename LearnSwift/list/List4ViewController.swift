//
//  List4ViewController.swift
//  LearnSwift
//
//  Created by liushungxi on 2018/9/14.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
class List4ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        for (index,item) in items.enumerated() {
            if component == index{
                if isCircularly{
                    return item.count * 1000
                }else{
                    return item.count
                }
            }
        }
        return 0
    }
    
    let items = [["a1","a2","a3","a4"],["a1","a2"],["a1","a2","a3"]]
    let pickerBox = UIView()
    let picker = UIPickerView()
    let canclButton = UIButton(type: UIButtonType.custom)
    let sureButton = UIButton(type: UIButtonType.custom)
    // 是否循环滚动
    let isCircularly = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canclButton.setTitle("取消", for: .normal)
        canclButton.setTitleColor(UIColor.black, for: .normal)
        canclButton.addTarget(self, action: #selector(clickCancle), for: .touchUpInside)
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitleColor(UIColor.black, for: .normal)
        sureButton.addTarget(self, action: #selector(clickSure), for: .touchUpInside)
        
        view.addSubview(pickerBox)
        pickerBox.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(260)
        }

        pickerBox.addSubview(canclButton)
        pickerBox.addSubview(sureButton)
        canclButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(40)
            make.left.equalTo(12)
        }
        sureButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(40)
            make.right.equalTo(-12)
        }
        
        pickerBox.addSubview(picker)
        picker.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        picker.dataSource = self
        picker.delegate = self
        //让pickerView默认选中中间项
        for index in 0..<items.count {
            picker.selectRow(items[index].count*500, inComponent: index, animated: false)
        }
        time = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timer), userInfo: nil, repeats: true)
        time.fire()
    }
    @objc func timer() {
        for index in 0..<items.count {
            var temp = picker.selectedRow(inComponent: index)
            temp -= 1
            picker.selectRow(temp, inComponent: index, animated: true)
        }
    }
    @objc func clickCancle() {
        time.fireDate = Date.distantPast
    }
    var time:Timer!
    @objc func clickSure(){
        time.fireDate = Date.distantFuture
        for index in 0..<items.count {
            if isCircularly{
                print((picker.selectedRow(inComponent: index))%items[index].count)
            }else{
                print(picker.selectedRow(inComponent: index))
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isCircularly{
            return items[component][row % items[component].count]
        }else{
            return items[component][row]
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
