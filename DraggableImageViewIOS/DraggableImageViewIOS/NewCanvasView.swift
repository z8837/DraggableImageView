////
////  CanvasView.swift
////  IndoorMapTestIOS
////
////  Created by Humancare on 2022/06/17.
////
//
//import Foundation
//import UIKit
//
//class NewCanvasView: UIView {
//    func initFUnc(){
////        imageReady = true
//        num += 1
//        font = UIFont.boldSystemFont(ofSize: 12)
//        strokeTextAttributes = [
//            .font: font!,
//            .strokeColor : UIColor.white,
//            .foregroundColor : UIColor.black,
//            .strokeWidth : -2.5,
//        ]
//    }
//    var parentImageView : DraggableImageView? = nil
//    func stopTimer() {
////        print("imageViewTimer 동작멈춤")
//        imageViewTimer?.cancel()
//        imageViewTimer = nil
//    }
//    func createTimer() {
//        
//        imageViewTimer = DispatchSource.makeTimerSource(queue: .main)
//        imageViewTimer?.schedule(deadline: .now(), repeating: 0.005)
//        imageViewTimer?.setEventHandler { [self] in
////            print("imageViewTimer 동작중")
//            num+=1
//        }
//        imageViewTimer?.activate()
//    }
//    private var imageViewTimer: DispatchSourceTimer?  = nil // draw 타이머
//    var num = 0{
//        didSet{
//            setNeedsDisplay()
//        }
//    }
//    struct VisibleData {
//        let coordX:CGFloat
//        let coordY:CGFloat
//        let length:Int
//    }
//    var nowClickedFloor = -2
//    var imageReady = false
//    var realImgWidth = 0.0
//    var realImgHeight = 0.0
//    private var font : UIFont? = nil
//    private var strokeTextAttributes: [NSAttributedString.Key : Any]? = nil
//    override func draw(_ rect: CGRect) {
//        if !imageReady {return}
//        guard let context = UIGraphicsGetCurrentContext() else {return}
//        if num > 1000 {num = 0}
//        context.setAllowsAntialiasing(true)
//        
//        //2604, 1176
////        let xOffset = 948.0
////        let yOffset = 576.0
////        let xRatio = 0.633
////        let yRatio = 0.633
////        let pointX = 4164.0
////        let pointY = 558.0
////        let coordX=(pointX + xOffset) * xRatio
////        let offsetAndRatioY = (pointY+yOffset) * yRatio
////        //2375, 1565
////        let coordY=(2375.0 - offsetAndRatioY) - 200
//        
//        print("draw canvas!! \(num)")
//        let currentScale = parentImageView!.getScale()
//        let diffX = (self.frame.width - self.frame.width * currentScale)/2
//        let diffY = (self.frame.height - self.frame.height * currentScale)/2
//        let x1 = diffX * cos(parentImageView!.angle * CGFloat.pi/180)
//        let y1 = diffX * sin(parentImageView!.angle * CGFloat.pi/180)
//        let x2 = diffY * sin(parentImageView!.angle * CGFloat.pi/180)
//        let y2 = diffY * cos(parentImageView!.angle * CGFloat.pi/180)
//        
//        
////        let point = AppDelegate.mapAllPoints[291]!
////        let blueprint = AppDelegate.mapBlueprints[point.blueprint!]!
////        let coord = AppDelegate.newGetCoord(blueprint: blueprint, point: CGPoint(x: point.x, y: point.y), realImgHeight: realImgHeight ,realImgWidth: realImgWidth)
////        let coordX = CGFloat(coord.coordX)
////        let coordY = CGFloat(coord.coordY)
////
////        var coordPoint = parentImageView?.convertPoint(fromImagePoint: CGPoint(x: coordX, y: coordY))
//////        print("coordPoint1 = \(coordPoint!)")
////        //4152.0
////        coordPoint!.x *= currentScale
////        coordPoint!.y *= currentScale
//////        print("coordPoint2 = \(coordPoint!)")
////        coordPoint = rotatePosition(originPosition: coordPoint!)
//////        print("coordPoint3 = \(coordPoint!)")
////
////
////
////        context.setStrokeColor(UIColor.black.cgColor)
////        context.setLineWidth(0.5)
////        context.setFillColor(UIColor.yellow.cgColor)
////        context.addEllipse(in: CGRect(x: coordPoint!.x + parentImageView!.transform.tx - 5 + x1 - x2,
////                                      y:coordPoint!.y + parentImageView!.transform.ty - 5 + y1 + y2,
////                                      width: 10, height: 10))
//////        print("originTx = \(parentImageView!.transform.tx)")
//////        print("coordTx = \(parentImageView!.transform.tx + x1 - x2)")
////        context.drawPath(using: .fillStroke)
////
////        let nameString = NSAttributedString(string: point.name!, attributes:strokeTextAttributes)
////        nameString.draw(at: CGPoint(x: coordPoint!.x + parentImageView!.transform.tx - 5 + x1 - x2 + 10, y: coordPoint!.y + parentImageView!.transform.ty - 5 + y1 + y2 - 5))
//        
//        
//        
//            
//        
//        
//        
//        
//        
//        
//        
//        var visibleList = [VisibleData]()
////
////        var count = AppDelegate.mapFloorPointArray[nowClickedFloor]!.count
////        if let switchPointArray = AppDelegate.mapFloorSwitchPointArray[nowClickedFloor]{
////            count += switchPointArray.count
////        }
//////        print("count = \(count)")
////        outerLoop: for i in 0 ..< count{
////            let newIdx = i - AppDelegate.mapFloorPointArray[nowClickedFloor]!.count
////            let point:Point
////            let pointName:String
////            if(newIdx >= 0){
////                point = AppDelegate.mapFloorSwitchPointArray[nowClickedFloor]![newIdx].point
////                pointName = AppDelegate.mapFloorSwitchPointArray[nowClickedFloor]![newIdx].nearPoint.name!
////            }
////            else{
////                point = AppDelegate.mapFloorPointArray[nowClickedFloor]![i]
////                pointName = point.name!
////            }
////            let blueprint = AppDelegate.mapBlueprints[point.blueprint!]!
////            let coord = AppDelegate.newGetCoord(blueprint: blueprint, point: CGPoint(x: point.x, y: point.y), realImgHeight: realImgHeight ,realImgWidth: realImgWidth)
////            let coordX = CGFloat(coord.coordX)
////            let coordY = CGFloat(coord.coordY)
////            
////            var coordPoint = parentImageView?.convertPoint(fromImagePoint: CGPoint(x: coordX, y: coordY))
////    //        print("coordPoint1 = \(coordPoint!)")
////            //4152.0
////            coordPoint!.x *= currentScale
////            coordPoint!.y *= currentScale
////    //        print("coordPoint2 = \(coordPoint!)")
////            coordPoint = rotatePosition(originPosition: coordPoint!)
////    //        print("coordPoint3 = \(coordPoint!)")
////            let resultX = coordPoint!.x + parentImageView!.transform.tx + x1 - x2
////            let resultY = coordPoint!.y + parentImageView!.transform.ty + y1 + y2
////            
////            
////            for visiblePoint in visibleList{
////                if(((visiblePoint.coordX <= resultX) &&
////                        (visiblePoint.coordX + CGFloat(Double(visiblePoint.length) * 10) >= resultX)) ||
////                    ((resultX <= visiblePoint.coordX) &&
////                        (resultX + CGFloat(Double(pointName.count) * 10) >= visiblePoint.coordX))){
////
////                    if((visiblePoint.coordY - 7 <= resultY) &&
////                        (visiblePoint.coordY + 7 >= resultY)){
//////                        print("안그려주는 포인트 = \(point.name!)")
////                        continue outerLoop
////                    }
////                }
////            }
////            visibleList.append(VisibleData(coordX: resultX, coordY: resultY, length: pointName.count))
////            
////            
////            
////            
////            
////            context.setStrokeColor(UIColor.black.cgColor)
////            context.setLineWidth(0.5)
////            context.setFillColor(UIColor.yellow.cgColor)
////            context.addEllipse(in: CGRect(x: resultX - 5,
////                                          y: resultY - 5,
////                                          width: 10, height: 10))
////    //        print("originTx = \(parentImageView!.transform.tx)")
////    //        print("coordTx = \(parentImageView!.transform.tx + x1 - x2)")
////            context.drawPath(using: .fillStroke)
////            
////            let nameString = NSAttributedString(string: pointName, attributes:strokeTextAttributes)
////            nameString.draw(at: CGPoint(x: coordPoint!.x + parentImageView!.transform.tx - 5 + x1 - x2 + 10, y: coordPoint!.y + parentImageView!.transform.ty - 5 + y1 + y2 - 5))
////            
////            
////        }
////
////
////            var convertedPoint = parentImageView?.convertPoint(fromImagePoint: CGPoint(x: coordX, y: coordY))
////    //        print("coordPoint1 = \(coordPoint!)")
////            //4152.0
////            convertedPoint!.x *= currentScale
////            convertedPoint!.y *= currentScale
////    //        print("coordPoint2 = \(coordPoint!)")
////            convertedPoint = rotatePosition(originPosition: coordPoint!)
////
////
////            let diffX = (self.frame.width - self.frame.width * currentScale)/2
////            let diffY = (self.frame.height - self.frame.height * currentScale)/2
////            let x1 = diffX * cos(parentImageView!.angle * CGFloat.pi/180)
////            let y1 = diffX * sin(parentImageView!.angle * CGFloat.pi/180)
////            let x2 = diffY * sin(parentImageView!.angle * CGFloat.pi/180)
////            let y2 = diffY * cos(parentImageView!.angle * CGFloat.pi/180)
////
////            let x = convertedPoint!.x + parentImageView!.transform.tx - 5 + x1 - x2
////            let y = convertedPoint!.y + parentImageView!.transform.ty - 5 + y1 + y2
////
////
////            var namePointX = x
//////            let diff = realEndX - (x + CGFloat(pointName.count) * 10)
//////            if diff < 0 {namePointX = x + diff}
//////            let convetedNamePointY = imageView.convertPoint(fromImagePoint: CGPoint(x: coordX, y: coordY + CGFloat(point.name_y_offset))).y
////            let namePointY = y
////
////            for visiblePoint in visibleList{
////                if(((visiblePoint.coordX <= namePointX) &&
////                        (visiblePoint.coordX + CGFloat(Double(visiblePoint.length) * 10) >= namePointX)) ||
////                    ((namePointX <= visiblePoint.coordX) &&
////                        (namePointX + CGFloat(Double(pointName.count) * 10) >= visiblePoint.coordX))){
////
////                    if((visiblePoint.coordY - 7 <= namePointY) &&
////                        (visiblePoint.coordY + 7 >= namePointY)){
//////                        print("안그려주는 포인트 = \(point.name!)")
////                        continue outerLoop
////                    }
////                }
////            }
////
////            //안보이는 부분 안그리게
//////            let showingX = convertedPoint.x  * scrollView.zoomScale
//////            let showingY = convertedPoint.y * scrollView.zoomScale
//////            let offset = scrollView.contentOffset
//////            let contentSize = scrollView.contentSize
//////
//////            if((showingX < offset.x - 10) ||
//////                (showingX > offset.x + contentSize.width + 10) ||
//////                (showingY < offset.y - 10) ||
//////                (showingY > offset.y + contentSize.height + 10)){
//////                continue
//////            }
////
////            visibleList.append(VisibleData(coordX: x, coordY: namePointY, length: pointName.count))
////
////
////
////
////            //Draw text////////////
////            let font = UIFont.boldSystemFont(ofSize: 12)
////
////            let strokeTextAttributes: [NSAttributedString.Key : Any] = [
////                .font: font,
////                .strokeColor : UIColor.white,
////                .foregroundColor : UIColor.black,
////                .strokeWidth : -2.5,
////                ]
////
////            let nameString = NSAttributedString(string: pointName, attributes:strokeTextAttributes)
//////            if pathSwitchPointMap[point.id] != nil{
//////                nameString.draw(at: CGPoint(x: namePointX + 10, y: namePointY - 5))
//////                continue}
////
////            //Draw a Circle ////////////////
////            context.setStrokeColor(UIColor.black.cgColor)
////            if newIdx < 0 {
////                context.setFillColor(UIColor(argb: 0xFF2373B3).cgColor)
////            }
////            else{
////                context.setFillColor(UIColor.red.cgColor)
////            }
////
////            context.setLineWidth(0.5)
////
////            context.addEllipse(in: CGRect(x: x, y: y, width: 9, height: 9))
////            context.drawPath(using: .fillStroke)  // or .fillStroke if need filling
////
////
//////            context.fillEllipse(in: CGRect(x: x, y: y, width: circleSize, height: circleSize))
//////            context.fillEllipse(in: CGRect(x: x, y: y, width: circleSize, height: circleSize))
////
////
////
////            //Draw text////////////
//////            print("namePointX = \(namePointX)")
////            nameString.draw(at: CGPoint(x: namePointX + 10, y: namePointY - 5))
////
////
////        }
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//            
//        
//        
//        
//    }
//    
//    
//    private func rotatePosition(originPosition:CGPoint, reverse:Bool = false) -> CGPoint{
//        let originX = originPosition.x
//        let originY = originPosition.y
//        let mx = originX - self.frame.width / 2
//        let my = originY - self.frame.height / 2
//        let ang :CGFloat = {
//            if(reverse) {return parentImageView!.angle}
//            else {return -parentImageView!.angle}
//        }()
//        let dRadian = ang * ( CGFloat.pi/180)
//        let destX = (mx * cos(dRadian)) + (my * sin(dRadian))
//        let destY = (mx * sin(dRadian) * -1) + (my * cos(dRadian))
//        return CGPoint(x: (destX + self.frame.width / 2), y: (destY + self.frame.height / 2))
//    }
//}
//
//
//
