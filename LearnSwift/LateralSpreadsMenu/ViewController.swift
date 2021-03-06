//
//  ViewController.swift
//  LearnSwift
//
//  Created by liushungxi on 2018/9/11.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //主页面
    var mainVc = mainViewController()
    //侧滑菜单页面
    var menuVc:menuViewController?
    //菜单页面状态
    var currentState = MenuState.Collapsed{
        didSet{
            //当菜单中展开时,给主页添加阴影
            let shouoldShowShandow = currentState != .Collapsed
            showShandowForMainVc(shouldShowShandow: shouoldShowShandow)
        }
    }
    let menuViewOffset:CGFloat = UIScreen.main.bounds.width-200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        //添加主页
        addMyChidVc(mainVc, box: view)
        //侧滑手势
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanAction(_:)))
        mainVc.view.addGestureRecognizer(panRecognizer)
        //单击收起手势
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapAction(_:)))
        mainVc.view.addGestureRecognizer(tapRecognizer)
    }
    //侧滑手势
    @objc func handlePanAction(_ sender:UIPanGestureRecognizer){
        switch sender.state {
            //开始滑动
        case .began:
            //判断滑动方向
            let dragFromLeftToRight = sender.velocity(in: view).x > 0
            //mainVc显示bong向右滑动时显示菜单栏
            if currentState == .Collapsed && dragFromLeftToRight{
                currentState = .Expanding
                addMenuVc()
            }
            //滑动ing,mainvc的坐标跟随手指移动
        case .changed:
            let postionX = sender.view!.frame.origin.x + sender.translation(in: view).x
            //页面在最左变了就不移动
            sender.view!.frame.origin.x = postionX < 0 ? 0 : postionX
            sender.setTranslation(.zero, in: view)
            //滑动结束
        case .ended:
            //判断滑动是否>50,判断是展开还是收缩menuVc
            let hasMovedhanHalfway = sender.view!.frame.origin.x > 100
            animMainView(shouldExpand: hasMovedhanHalfway)
        default:
            break
        }
    }
    @objc func handleTapAction(_ sender:UITapGestureRecognizer){
        //如果菜单是展开的点击主页部分则会收起
        if currentState == .Expanded{
            animMainView(shouldExpand: false)
        }
    }
    func addMenuVc(){
        if menuVc == nil{
            menuVc = menuViewController()
            view.insertSubview(menuVc!.view, at: 0)
            addChildViewController(menuVc!)
            menuVc!.didMove(toParentViewController: self)
        }
    }
    
    func animMainView(shouldExpand:Bool){
        if shouldExpand{
            currentState = .Expanded
            animateMainViewXPosition(targetPosition: mainVc.view.frame.width - menuViewOffset)
        }else{
            animateMainViewXPosition(targetPosition: 0) { (finished) in
                self.currentState = .Collapsed
                self.menuVc?.view.removeFromSuperview()
                self.menuVc = nil
            }
        }
    }
    func animateMainViewXPosition(targetPosition: CGFloat,
                                  completion: ((Bool) -> Void)! = nil) {
        //usingSpringWithDamping：1.0表示没有弹簧震动动画
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        self.mainVc.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func showShandowForMainVc(shouldShowShandow:Bool){
        if shouldShowShandow{
            mainVc.view.layer.shadowOpacity = 0.9
        }else{
            mainVc.view.layer.shadowOpacity = 0.0
        }
    }
    // 菜单状态枚举
    enum MenuState {
        case Collapsed  // 未显示(收起)
        case Expanding   // 展开中
        case Expanded   // 展开
    }
    
}
extension UIViewController{
    func addMyChidVc(_ vc:UIViewController, box:UIView) {
        vc.willMove(toParentViewController: self)
        box.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
}
