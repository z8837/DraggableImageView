//
//  ViewController.swift
//  IndoorMapTestIOS
//
//  Created by Humancare on 2022/06/14.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MapContainerView!
    //    @IBOutlet weak var canvasView: CanvasView!
//    @IBOutlet weak var draggableImageView: DraggableImageView!
    @IBOutlet weak var scrollView: MapImageScrollView!
    @IBAction func clickedButton(_ sender: UIButton) {
        print("clicked")
        scrollView.draggableImageView?.stopTimer()
        scrollView.draggableImageView!.transCenter(scale: 6)
//        scrollView.zoomAndResetRotation()
//        scrollView.setScale(center: nil, scale: 1.5)
    }
    @IBAction func clickedButton2(_ sender: Any) {
        scrollView.draggableImageView?.stopTimer()
        scrollView.draggableImageView!.setAngleZero()
//        scrollView.draggableImageView!.zoomDuration = 0.3
//        scrollView.draggableImageView?.stopTimer()
//        scrollView.draggableImageView!.transCenter()
//        scrollView.canvasView?.num += 1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mapView.imageView.image = UIImage(named: "B1")   // 예시
//        mapView.frame = view.bounds
//        view.addSubview(mapView)
//
//        // 예시 포인트 3개
//        mapView.mapPoints = [
//            MapPoint(x: 150, y: 250),
//            MapPoint(x: 400, y: 600),
//            MapPoint(x: 900, y: 1200),
//            MapPoint(x: 410, y: 610),
//            MapPoint(x: 420, y: 620),
//            MapPoint(x: 430, y: 630),
//            MapPoint(x: 440, y: 640),
//            MapPoint(x: 450, y: 650),
//            MapPoint(x: 460, y: 660),
//            MapPoint(x: 470, y: 670),
//            MapPoint(x: 480, y: 680),
//            MapPoint(x: 490, y: 690),
//            MapPoint(x: 500, y: 700),
//            MapPoint(x: 510, y: 710),
//            MapPoint(x: 520, y: 720),
//        ]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.initFUnc(view: view)
        
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickScrollView))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.delegate = self
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
    }
    @objc func clickScrollView(_ gesture: UITapGestureRecognizer) {
//        print("gesture = \(gesture.location(in: scrollView.draggableImageView))")
        let gestureLocation = gesture.location(in: scrollView)
        let xOffset = 948.0
        let yOffset = 576.0
        let xRatio = 0.633
        let yRatio = 0.633
        let pointX = 4164.0
        let pointY = 558.0
        let coordX=(pointX + xOffset) * xRatio
        let offsetAndRatioY = (pointY+yOffset) * yRatio
        let coordY=(2375.0 - offsetAndRatioY)
        var coordPoint = scrollView.draggableImageView!.convertPoint(fromImagePoint: CGPoint(x: coordX, y: coordY))
        let currentScale = scrollView.draggableImageView!.getScale()
        
        coordPoint.x *= currentScale
        coordPoint.y *= currentScale
        print("coordPoint2 = \(coordPoint)") //이게 TiledLayer에 그려줄 위치
        coordPoint = rotatePosition(originPosition: coordPoint)
        print("coordPoint3 = \(coordPoint)")
    
        let diffX = (scrollView.frame.width - scrollView.frame.width * currentScale)/2
        let diffY = (scrollView.frame.height - scrollView.frame.height * currentScale)/2
        let x1 = diffX * cos(scrollView.draggableImageView!.angle * CGFloat.pi/180.0)
        let y1 = diffX * sin(scrollView.draggableImageView!.angle * CGFloat.pi/180.0)
        let x2 = diffY * sin(scrollView.draggableImageView!.angle * CGFloat.pi/180.0)
        let y2 = diffY * cos(scrollView.draggableImageView!.angle * CGFloat.pi/180.0)
        
        let scrollViewX = coordPoint.x + scrollView.draggableImageView!.transform.tx + x1 - x2
        let scrollViewY = coordPoint.y + scrollView.draggableImageView!.transform.ty + y1 + y2
        
        
        print("point = \(scrollViewX),\(scrollViewY) , gesture = \(gestureLocation)")
        let gestureRangeX = gestureLocation.x - 20 ... gestureLocation.x + 20
        let gestureRangeY = gestureLocation.y - 20 ... gestureLocation.y + 20
        if gestureRangeX ~= scrollViewX && gestureRangeY ~= scrollViewY{
            print("click!!!")
        }
        
    
        
//        print("coordPoint = \(coordPoint)")
    }
    private func rotatePosition(originPosition:CGPoint, reverse:Bool = false) -> CGPoint{
        let originX = originPosition.x
        let originY = originPosition.y
        let mx = originX - scrollView.frame.width / 2
        let my = originY - scrollView.frame.height / 2
        let ang :CGFloat = {
            if(reverse) {return scrollView.draggableImageView!.angle}
            else {return -scrollView.draggableImageView!.angle}
        }()
        let dRadian = ang * ( CGFloat.pi/180)
        let destX = (mx * cos(dRadian)) + (my * sin(dRadian))
        let destY = (mx * sin(dRadian) * -1) + (my * cos(dRadian))
        return CGPoint(x: (destX + scrollView.frame.width / 2), y: (destY + scrollView.frame.height / 2))
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}


extension UIImageView {
    
    func convertPoint(fromImagePoint imagePoint: CGPoint) -> CGPoint {
        guard let imageSize = image?.size else { return CGPoint.zero }

        var viewPoint = imagePoint
        let viewSize = bounds.size
        
//        print("imageSize = \(imageSize), viewSize = \(viewSize)")
        
        let ratioX = viewSize.width / imageSize.width
        let ratioY = viewSize.height / imageSize.height
        
        switch contentMode {
        case .scaleAspectFit: fallthrough
        case .scaleAspectFill:
            var scale : CGFloat = 0
            
            if contentMode == .scaleAspectFit {
                scale = min(ratioX, ratioY)
            }
            else {
                scale = max(ratioX, ratioY)
            }
            
            viewPoint.x *= scale
            viewPoint.y *= scale
            
            viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2.0
            viewPoint.y += (viewSize.height - imageSize.height * scale) / 2.0
        
        case .scaleToFill: fallthrough
        case .redraw:
            viewPoint.x *= ratioX
            viewPoint.y *= ratioY
        case .center:
            viewPoint.x += viewSize.width / 2.0  - imageSize.width  / 2.0
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
        case .top:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0
        case .bottom:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0
            viewPoint.y += viewSize.height - imageSize.height
        case .left:
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
        case .right:
            viewPoint.x += viewSize.width - imageSize.width
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
        case .topRight:
            viewPoint.x += viewSize.width - imageSize.width
        case .bottomLeft:
            viewPoint.y += viewSize.height - imageSize.height
        case .bottomRight:
            viewPoint.x += viewSize.width  - imageSize.width
            viewPoint.y += viewSize.height - imageSize.height
        case.topLeft: fallthrough
        default:
            break
        }
        
         return viewPoint
    }
    
    

}
