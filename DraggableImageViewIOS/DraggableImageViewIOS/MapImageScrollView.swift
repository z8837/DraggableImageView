//
//  MapImageScrollView.swift
//  IndoorMapTestIOS
//
//  Created by Humancare on 2022/06/28.
//

import Foundation
import UIKit

class MapImageScrollView: UIScrollView, UIGestureRecognizerDelegate {
    var draggableImageView: DraggableImageView? = nil
//    var canvasView: NewCanvasView? = nil
    
    private var panningFlag = false
    private var scaling = false
    var rotating = false
    
    
    private let maxScale = 10.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        canvasView!.createTimer()
        draggableImageView!.stopTimer()
    }
    
    func initFUnc(view:UIView){
        self.delaysContentTouches = false //touchBegan 딜레이 없애기
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale)) //줌
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate)) //회전
        let panningGesture = UIPanGestureRecognizer(target: self, action: #selector(panning)) //이동

        panningGesture.delegate = self
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        self.addGestureRecognizer(panningGesture)
        self.addGestureRecognizer(pinchGesture)
        self.addGestureRecognizer(rotationGesture)
        
        let dragImgView = DraggableImageView()
        dragImgView.contentMode = UIView.ContentMode.scaleAspectFit
        dragImgView.image = UIImage(named: "B1")
        dragImgView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dragImgView)
        dragImgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        dragImgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        dragImgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        dragImgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        dragImgView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dragImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        draggableImageView = dragImgView
        
//        let canvas = NewCanvasView()
//        canvas.backgroundColor = UIColor(argb: 0x00000000)
//        canvas.isUserInteractionEnabled = false
//        canvas.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(canvas)
//        canvas.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        canvas.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//        canvas.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//        canvas.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//        canvasView = canvas
        
//        draggableImageView!.canvasView = canvasView
        draggableImageView!.scrollView = self
        draggableImageView?.initFunc()
       
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { //동시 제스쳐 허용
        return true
    }
    
    @objc func clickScrollView(_ gesture: UITapGestureRecognizer) {
        print("gesture = \(gesture.location(in: draggableImageView))")
    }
    
    @objc func panning(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self)
        let originTransform = draggableImageView!.transform
        let newTransform = CGAffineTransform(a: originTransform.a, b: originTransform.b, c: originTransform.c, d: originTransform.d, tx: originTransform.tx + translation.x, ty: originTransform.ty + translation.y)
        draggableImageView!.transform = newTransform
        draggableImageView!.setTxTy()
        
//        print("panning num = \(canvasView!.num)")
//        canvasView?.num += 1
        if gesture.state == UIGestureRecognizer.State.ended{
            panningFlag = false
            if !scaling && !rotating{
//                print("stopTimer in panning")
//                canvasView!.stopTimer()
            }
            let velocity = gesture.velocity(in: self)
            if abs(velocity.x) > 400 || abs(velocity.y) > 400{
                draggableImageView!.panningV0x = velocity.x * 1.2
                draggableImageView!.panningV0y = velocity.y * 1.2
                draggableImageView!.panningAx = -draggableImageView!.panningV0x/draggableImageView!.inertiaDuration
                draggableImageView!.panningAy = -draggableImageView!.panningV0y/draggableImageView!.inertiaDuration
                draggableImageView!.createTimer(kind: DraggableImageView.TIMER_INERTIA)
            }
        }
        else if gesture.state == UIGestureRecognizer.State.began{
            panningFlag = true
        }
//        else if(!scaling && !rotating){
//            print("panning!!")
//            canvasView?.num += 1}
//        print("scale = \(draggableImageView!.getScale()), size = \(draggableImageView!.frame.size), panned position = \(draggableImageView!.transform.tx),\(draggableImageView!.transform.ty)")
        gesture.setTranslation(CGPoint.zero, in: self)
    }
    
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began{
            scaling = true
        }
        else if gesture.state == UIGestureRecognizer.State.ended{
            scaling = false
            if !panningFlag && !rotating{
//                print("stopTimer in scaling")
//                canvasView!.stopTimer()
            }
        }
        let pinchCenter = CGPoint(x: gesture.location(in: draggableImageView).x - draggableImageView!.bounds.midX,
                                  y: gesture.location(in: draggableImageView).y - draggableImageView!.bounds.midY)
        draggableImageView!.transform = draggableImageView!.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                                        .scaledBy(x: gesture.scale, y: gesture.scale)
                                        .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
        
        let currentScale = draggableImageView!.getScale()
        if(currentScale > maxScale || currentScale < 1){
            if currentScale > maxScale{
                draggableImageView!.transform = draggableImageView!.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                    .scaledBy(x: maxScale/currentScale, y: maxScale/currentScale)
                    .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            }
            else{
                draggableImageView!.transform = draggableImageView!.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                    .scaledBy(x: 1/currentScale, y: 1/currentScale)
                    .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
                
            }
        }
        draggableImageView!.setTxTy()
        gesture.scale = 1
//        canvasView?.num += 1
//        if !rotating{
//            print("scale!!")
//            canvasView?.num += 1
//        }
//        draggableImageView?.overlayNeedsUpdate()
        let currentTime = CACurrentMediaTime()
        let diff =  currentTime - lastTime
        if diff > 0.02{
            lastTime = currentTime
            draggableImageView?.overlayNeedsUpdate()
        }
    }
    
    
    var lastTime : CFTimeInterval = 0.0
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizer.State.began{
            rotating = true
        }
        else if gesture.state == UIGestureRecognizer.State.ended{
            rotating = false
            if !panningFlag && !scaling{
//                print("stopTimer in rotating")
//                canvasView!.stopTimer()
            }
        }
//        draggableImageView!.stopTimer()
        let pinchCenter = CGPoint(x: gesture.location(in: draggableImageView).x - draggableImageView!.bounds.midX,
                                  y: gesture.location(in: draggableImageView).y - draggableImageView!.bounds.midY)
        draggableImageView!.transform = draggableImageView!.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
            .rotated(by: gesture.rotation)
            .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
        draggableImageView!.setTxTy()
        gesture.rotation = 0
        
        let radians:Double = atan2( Double(draggableImageView!.transform.b), Double(draggableImageView!.transform.a))
        var degrees:CGFloat = radians * (CGFloat(180) / CGFloat.pi )
        if degrees < 0 {degrees += 360}
        draggableImageView!.angle = degrees
//        print("rotate!!")
//        canvasView?.num += 1
        let currentTime = CACurrentMediaTime()
        let diff =  currentTime - lastTime
        
        print("diff = \(diff)")
        if diff > 0.02{
            lastTime = currentTime
            draggableImageView?.overlayNeedsUpdate()
        }
    }
    
}
