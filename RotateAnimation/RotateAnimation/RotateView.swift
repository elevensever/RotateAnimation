//
//  RotateView.swift
//  RotateAnimation
//
//  Created by elevenjian on 2017/2/24.
//  Copyright © 2017年 elevenjian. All rights reserved.
//

import UIKit


let SCREEN_WIDTH = UIScreen.main.bounds.width//屏幕宽

let SCREEN_HEIGHT = UIScreen.main.bounds.height//屏幕高

let CENTER = CGPoint(x:SCREEN_WIDTH/2, y:SCREEN_HEIGHT/2)//屏幕中心点

let RADIUS = SCREEN_WIDTH/2

let IMAGE_LENGTH:CGFloat = 40//图片边长


class RotateView: UIView {
    
    let image = UIImage(named: "Image")
    
    var count = 1 // 图片数量
    
    var images:[MoveImage] = []// 图片对象数组
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
  
    //MARK:图片拖动时的回调
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        guard let moveImage = touches.first?.view as? MoveImage else{return}
        
        let touch = touches.first
        //当拖动超过边界时返回
        //        let prePointInSelf = touch?.previousLocationInView(self)
        //        guard  CGRectContainsRect(bounds, moveImage.frame) || curPointInSelf?.distanceBetweenTwoPoints(CENTER)<prePointInSelf?.distanceBetweenTwoPoints(CENTER) else{ return}
        
        //根据拖拽进行视图位移
        let curPoint = touch?.location(in: moveImage)
        let prePoint = touch?.previousLocation(in: moveImage)
        let offX = curPoint!.x - (prePoint?.x)!
        let offY = (curPoint?.y)! - (prePoint?.y)!
        for image in images{
            image.transform = image.transform.translatedBy(x: offX, y: offY)
            
        }

    }
    
    
    //MARK:初始化时，默认右边一张图片
    func defaultView() {
        frame = CGRect(x: 0, y: CENTER.y-RADIUS, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        backgroundColor = UIColor.lightGray
        let moveImage = MoveImage(image: image)
        
        moveImage.frame = CGRect(x: 0, y: 0, width: IMAGE_LENGTH, height: IMAGE_LENGTH)
        moveImage.center = CGPoint(x: RADIUS*1.5, y: RADIUS)
        images.append(moveImage)
        addSubview(moveImage)

    }
    
    //MARK:图片数目变化
    func updateNum(count:Int){
        
        for item in subviews {
            
            item.removeFromSuperview()
            
        }
        
        images = []
        
        for i in 0..<count {
            let moveImage = MoveImage(image: image)
            moveImage.frame = CGRect(x: 0, y: 0, width: IMAGE_LENGTH, height: IMAGE_LENGTH)
            moveImage.center = CGPoint(x: RADIUS*1.5, y: RADIUS)
            let angle = CGFloat(i)/CGFloat(count) * CGFloat(M_PI) * 2.0
            let trans = moveImage.rotateAroundPoint(transform: CGAffineTransform.identity, x: RADIUS, y: RADIUS, angle: angle)
            moveImage.transform = trans
            images.append(moveImage)
            addSubview(moveImage)

        }
    }
    
    // MARK:重写方法，实现MoveImage超出父视图时事件的传递
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in subviews{
            
            if view.frame.contains(point){
                return true
            }
        }
        return false
    }
    
    
}



class MoveImage:UIImageView{
    
   
    
    override init(image: UIImage?) {
        super.init(image: image)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.touchesMoved(touches, with: event)

    }
    
    
}


extension MoveImage{
    
    //MARK: 以(centerX,centerY)为中心的UIView绕(x,y)顺时针旋转angle弧度
    func rotateAroundPoint(transform:CGAffineTransform,x:CGFloat,y:CGFloat,angle:CGFloat) -> CGAffineTransform {
        
        let dx = x - center.x
        let dy = y - center.y
        //center平移到(x,y)
        var trans = CGAffineTransform.init(translationX: dx, y: dy)
        //旋转
        trans = trans.rotated(by: angle)
        //center还原
        trans = trans.translatedBy(x: -dx, y: -dy)
        return trans
        
    }
   
}

extension CGPoint{
    //MARK: 计算两点之间距离
    func distanceBetweenTwoPoints(point:CGPoint) -> CGFloat {
        
         return sqrt((point.x - x)*(point.x - x) + (point.y - y)*(point.y - y))
        
    }
}
