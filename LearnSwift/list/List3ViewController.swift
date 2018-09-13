//
//  List3ViewController.swift
//  LearnSwift
//
//  Created by liushungxi on 2018/9/13.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit

class List3ViewController: UIViewController{

    var width: CGFloat!
    var images: Array<UIImage>!
    var collectionView:UICollectionView!
    var maskView: UIView!
    var cellRect: CGRect!
    var changeRect: CGRect!
    //MARK: --life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        waterfallCollectionView()
    }
    private func waterfallCollectionView() {
        width = (view.bounds.size.width - 20)/3
        let layout = WaterCollectionViewLayout()
        layout.queueNum = 2
        images = []
        for _ in 1..<5 {
            let image1 = #imageLiteral(resourceName: "a02")
            let image2 = #imageLiteral(resourceName: "a01")
            let image3 = #imageLiteral(resourceName: "a03")
            let image4 = #imageLiteral(resourceName: "a04")
            let image5 = #imageLiteral(resourceName: "a05")
            images.append(image1)
            images.append(image2)
            images.append(image3)
            images.append(image4)
            images.append(image5)
        }
        layout.setSize = {
            return self.images
        }
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "newCell")
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    @objc func showPic(btn:UIButton){
        UIView.animate(withDuration: 1, animations: {
            btn.frame = self.cellRect
        }) { (finish) in
            btn.removeFromSuperview()
            self.maskView.removeFromSuperview()
            self.maskView = nil
            self.cellRect = nil
        }
    }
}

extension List3ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK: --UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath as IndexPath)
        let imageView = UIImageView(frame: cell.bounds)
        imageView.image = images[indexPath.row]
        let bgView = UIView(frame:cell.bounds)
        bgView.addSubview(imageView)
        cell.backgroundView = bgView
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        maskView = UIView.init(frame: view.bounds)
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.5
        view.addSubview(maskView)
        
        //cell在veiw的位置
        cellRect = cell!.convert(cell!.bounds, to: view)
        let btn = WaterButton.init(frame: cellRect)
        let img = images[indexPath.row]
        btn.wImage = img
        btn.addTarget(self, action: #selector(showPic(btn:)), for: UIControlEvents.touchUpInside)
        view.addSubview(btn)
        //图片长宽的比例与屏幕长宽的比例的对比
        var changeH:CGFloat
        var changeW:CGFloat
        if img.size.width/img.size.height >= view.frame.size.width/view.frame.size.height{
            //对比图片实际宽与屏幕宽
            if img.size.width>view.frame.size.width {
                changeH = img.size.height*view.frame.size.width/img.size.width
                changeRect = CGRect(x: 0, y: (view.frame.size.height-changeH)/2, width:view.frame.size.width, height: changeH)
            }else{
                changeRect = CGRect(x: (view.frame.size.width-img.size.width)/2, y: (view.frame.size.height-img.size.height)/2, width: img.size.width,height: img.size.height)
            }
        }else{
            if img.size.height>view.frame.size.height {
                changeW = img.size.width*view.frame.size.height/img.size.height
                changeRect = CGRect(x: (view.frame.size.width-changeW)/2, y: 0, width: changeW, height: view.frame.size.height)
            }else{
                changeRect = CGRect(x: (view.frame.size.width-img.size.width)/2, y: (view.frame.size.height-img.size.height)/2, width: img.size.width,height: img.size.height)
            }
        }
        
        UIView.animate(withDuration: 1, animations: {
            btn.frame = self.changeRect
        })
        
    }

}
class WaterCollectionViewLayout: UICollectionViewLayout {
    
    //来控制cell的大小
    var setSize:()->(Array<UIImage>) = { return []}
    var queueNum: Int = 2 //列数，默认为两列
    var hs: Array<CGFloat>!
    private var totalNum: Int!
    private var layoutAttributes: Array<UICollectionViewLayoutAttributes>!
    override func prepare() {
        super.prepare()
        hs = []
        for _ in 0..<queueNum {
            hs.append(5)
        }
        totalNum = collectionView?.numberOfItems(inSection: 0)
        layoutAttributes = []
        var indexpath: NSIndexPath!
        for index in 0..<totalNum {
            indexpath = NSIndexPath(row: index, section: 0)
            let attributes = layoutAttributesForItem(at: indexpath as IndexPath)
            layoutAttributes.append(attributes!)
        }
    }
    private let gap:CGFloat = 5//间隔，缝隙大小
    private var width:CGFloat!
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        width = (collectionView!.bounds.size.width-gap*(CGFloat(queueNum)-1))/CGFloat(queueNum)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let sizes = setSize()
        attributes.size = CGSize(width: width, height: sizes[indexPath.row].size.height*width/sizes[indexPath.row].size.width)
        var nub:CGFloat = 0
        var h:CGFloat = 0
        (nub,h) = minH(hhs: hs)
        attributes.center = CGPoint(x:(nub+0.5)*(gap+width), y:h+(width/attributes.size.width*attributes.size.height+gap)/2)
        hs[Int(nub)] = h+width/attributes.size.width*attributes.size.height+gap
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    //    override func collectionViewContentSize() -> CGSize {
    //        return CGSize(width: (collectionView?.bounds.width)!, height: maxH(hhs: hs))
    //    }
    //swift3.0废弃了上面这个方法，所以我们改成重写collectionViewContentSize属性
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: (collectionView?.bounds.width)!, height: maxH(hhs: hs))
        }
        set {
            self.collectionViewContentSize = newValue
        }
    }
    
    private func minH(hhs:Array<CGFloat>)->(CGFloat,CGFloat){
        var num = 0
        var min = hhs[0]
        for i in 1..<hhs.count{
            if min>hhs[i] {
                min = hhs[i]
                num = i
            }
        }
        return (CGFloat(num),min)
    }
    func maxH(hhs:Array<CGFloat>)->CGFloat{
        var max = hhs[0]
        for i in 1..<hhs.count{
            if max<hhs[i] {
                max = hhs[i]
            }
        }
        return max
    }
}
class WaterButton: UIButton {
    
    var wImage:UIImage!{
        didSet{
            wImageView.image = wImage
        }
    }
    private var wImageView:UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        wImageView = UIImageView(frame:bounds)
        addSubview(wImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wImageView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
