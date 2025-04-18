//
//  DrawbleView.swift
//  IndoorMapTestIOS
//
//  Created by Humancare on 2022/06/16.
//
import Foundation
import UIKit

class DraggableImageView: UIImageView {
    private var displayLink : CADisplayLink? = nil //화면 갱신 주기를 담당하는 하드웨어 타이머
    var needsUpdate = false
    
    //아이폰 계열은 디바이스에서 화면 갱신 주기는 1/60초 = 0.016
    func startDisplayLink(){
        displayCount = 0
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink!.add(to: .main, forMode: .default)
    }
    
    private lazy var tiledLayer: MyTiledLayer = {
            let layer = MyTiledLayer()
            layer.owner = self
            return layer
        }()
    
    
    private lazy var customLayer: MyCustomLayer = {
        let layer = MyCustomLayer(owner: self)
        return layer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        // (a) 계층에 붙였는지?
        if tiledLayer.superlayer == nil {
            layer.addSublayer(tiledLayer)
        }

        // (b) 크기 0×0이면 안 그려진다 → 항상 갱신
        tiledLayer.frame = bounds
    }
    func overlayNeedsUpdate() {
        let zoom   = CGFloat(getScale())               // 1.0, 2.5, …
//        let maxCS  = UIScreen.main.scale * zoom
//        print("maxCS = \(maxCS), zoom: \(zoom), scale = \(UIScreen.main.scale)")
//        customLayer.currentZoom = zoom                 // (아래 draw용)
//        customLayer.contentsScale = maxCS              // 해상도 ↑
//        customLayer.setNeedsDisplay()
        
        tiledLayer.currentZoom = zoom
        tiledLayer.contentsScale = UIScreen.main.scale
        tiledLayer.setNeedsDisplay()
        
        let imageSize = self.image!.size
        let imageViewSize = self.bounds.size
        let convertPoint = convertPoint2(fromImagePoint: CGPoint(x:1935.9262196531795, y:1828.9923294797686), imageSize: imageSize, viewSize: imageViewSize)
        let layerPoint = self.layer.convert(convertPoint, to: tiledLayer)
        print("convertPoint = \(convertPoint)")
        print("layerPoint = \(layerPoint)")
//        tiledLayer.displayIfNeeded()
    }

    // ④ 외부에서 호출
    func refreshLayerDrawing() {
        print("🔄 setNeedsDisplay() 요청")
        tiledLayer.setNeedsDisplay()             // 다음 run‑loop에 draw 호출
        // 바로 확인하려면 ↓
        // customLayer.displayIfNeeded()          // 즉시 draw(in:) 호출
    }
    
//    var parentView: UIView? = nil
//    var canvasView: NewCanvasView? = nil
    var scrollView: MapImageScrollView? = nil
    var angle : CGFloat = 0.0
    func setUpDisplayLink(){
        displayLink = CADisplayLink(target: self, selector: #selector(updateIfNeeded))
        displayLink?.preferredFramesPerSecond = 30
        displayLink?.add(to: .main, forMode: .default)
    }
    func requestDisplayUpdate() {
        needsUpdate = true
    }
    deinit {
        displayLink?.invalidate()
    }
    private var num = 0
    @objc private func updateIfNeeded() {
//        print("updateIfNeeded : \(num)")
        num+=1
//        guard needsUpdate else { return }
//        needsUpdate = false
//        overlayNeedsUpdate()
       
//        tiledLayer.setNeedsDisplay()
    }
    
    func initFunc(){
//        self.backgroundColor = UIColor(argb: 0x551A43FF)
//        canvasView!.parentImageView = self
//        canvasView!.initFUnc()
        print("initFunc : customLayer 등록")
//        customLayer.contentsScale = UIScreen.main.scale
//        self.layer.addSublayer(customLayer)
//        customLayer.frame = bounds
//        setUpDisplayLink()
    }
    
//    func refreshLayerDrawing() {
//        print("refreshLayerDrawing")
//        customLayer.setNeedsDisplay()
//    }
    
    //
    
    func stopDisplayLink(){
        displayLink?.invalidate()
        displayLink = nil
    }
    var displayCount = 0
    var repeating = 0.016
    var lastTime : CFTimeInterval = 0.0
    @objc func update(){
//        displayCount+=1
        let diff = CACurrentMediaTime() - lastTime
//        print("시간차 = \(diff)")
        lastTime = CACurrentMediaTime()
//        print("display update!! \(displayCount), result = \(inertiaDuration/repeating)")
        let vX = panningAx * (CGFloat(displayCount) * repeating) + panningV0x
        let vY = panningAy * (CGFloat(displayCount) * repeating) + panningV0y
        let sX = panningAx/2 * pow(repeating, 2) + vX * 0.01
        let sY = panningAy/2 * pow(repeating, 2) + vY * 0.01
        self.transform.tx = self.transform.tx + sX
        self.transform.ty = self.transform.ty + sY
        setTxTy()
//        canvasView?.num += 1
        displayCount+=1
        if (CGFloat(displayCount) >= (inertiaDuration/repeating)) {stopDisplayLink()}
        
    }
    private var inertiaTimer: DispatchSourceTimer?  = nil // 관성 타이머
    private var zoomTimer: DispatchSourceTimer?  = nil // 줌 타이머
    private var angleTimer: DispatchSourceTimer?  = nil // 각도 타이머
    
    //duration = 0.25
    private var inertiaCount = 0
    private var zoomCount = 0
    private var angleCount = 0
    var panningV0x :CGFloat = 0.0
    var panningV0y :CGFloat = 0.0
    var panningAx :CGFloat = 0.0
    var panningAy :CGFloat = 0.0
    let inertiaDuration = 0.4
    private let zoomDuration = 0.1
    private var angleDuration = 0.08
    
    private var resultCoordTx : CGFloat = 0.0
    private var resultCoordTy : CGFloat = 0.0
    private var originTx : CGFloat = 0.0
    private var originTy : CGFloat = 0.0
    private var diffScale = 0.0
    private var currentAngle = 0.0
    
    private let repeatingTime = 0.005
    static let TIMER_INERTIA = 1
    static let TIMER_ZOOM = 2
    static let TIMER_ANGLE = 3
//    static let TIMER_INERTIA = 1
    func createTimer(kind :Int) {
//        canvasView!.stopTimer()
        switch(kind){
        case DraggableImageView.TIMER_INERTIA :
            startDisplayLink()
//            inertiaCount = 0
//            inertiaTimer = DispatchSource.makeTimerSource(queue: .main)
//            inertiaTimer?.schedule(deadline: .now(), repeating: repeatingTime)
//            inertiaTimer?.setEventHandler { [self] in
//                let vX = panningAx * (CGFloat(inertiaCount) * repeatingTime) + panningV0x
//                let vY = panningAy * (CGFloat(inertiaCount) * repeatingTime) + panningV0y
//                let sX = panningAx/2 * pow(repeatingTime, 2) + vX * repeatingTime
//                let sY = panningAy/2 * pow(repeatingTime, 2) + vY * repeatingTime
//                self.transform.tx = self.transform.tx + sX
//                self.transform.ty = self.transform.ty + sY
//                setTxTy()
//                canvasView?.num += 1
//                inertiaCount+=1
//                if (CGFloat(inertiaCount) >= (inertiaDuration/repeatingTime)) {stopTimer(kind: kind)}
//            }
//            inertiaTimer?.activate()
        case DraggableImageView.TIMER_ZOOM:
            zoomCount = 0
            zoomTimer = DispatchSource.makeTimerSource(queue: .main)
            zoomTimer?.schedule(deadline: .now(), repeating: repeatingTime)
            let originScale = getScale()
            zoomTimer?.setEventHandler { [self] in
                zoomCount+=1
                let ratio = (CGFloat(zoomCount)/(zoomDuration/repeatingTime))
                let nextScale = originScale + diffScale * ratio
                var currentScale = getScale()
                self.transform = self.transform.scaledBy(x:nextScale/currentScale, y: nextScale/currentScale)
                currentScale = getScale()
                let diffWidth = (scrollView!.frame.width - scrollView!.frame.width * currentScale)/2
                let diffHeight = (scrollView!.frame.height - scrollView!.frame.height * currentScale)/2
                let x1 = diffWidth * cos(self.angle * CGFloat.pi/180.0)
                let y1 = diffWidth * sin(self.angle * CGFloat.pi/180.0)
                let x2 = diffHeight * sin(self.angle * CGFloat.pi/180.0)
                let y2 = diffHeight * cos(self.angle * CGFloat.pi/180.0)
                let diffX = (resultCoordTx - originTx) * ratio - x1 + x2
                let diffY = (resultCoordTy - originTy) * ratio - y1 - y2
                self.transform = CGAffineTransform(a: self.transform.a, b: self.transform.b, c: self.transform.c, d: self.transform.d, tx: originTx + diffX, ty: originTy + diffY)
                setTxTy()
//                canvasView?.num += 1
                if (CGFloat(zoomCount) >= (zoomDuration/repeatingTime)) {stopTimer(kind: kind)}
            }
            zoomTimer?.activate()
        case DraggableImageView.TIMER_ANGLE:
            angleCount = 0
            angleTimer = DispatchSource.makeTimerSource(queue: .main)
            angleTimer?.schedule(deadline: .now(), repeating: repeatingTime)
            angleTimer?.setEventHandler { [self] in
                angleCount+=1
                let currentScale = getScale()
                let originDiffX = (scrollView!.frame.width - scrollView!.frame.width * currentScale)/2
                let originDiffY = (scrollView!.frame.height - scrollView!.frame.height * currentScale)/2
                let originX1 = originDiffX * cos(self.angle * CGFloat.pi/180.0)
                let originY1 = originDiffX * sin(self.angle * CGFloat.pi/180.0)
                let originX2 = originDiffY * sin(self.angle * CGFloat.pi/180.0)
                let originY2 = originDiffY * cos(self.angle * CGFloat.pi/180.0)
                let scrollSize = scrollView!.frame.size
                let point3x = scrollSize.width/2 - self.transform.tx - originX1 + originX2
                let point3y = scrollSize.height/2 - self.transform.ty - originY1 - originY2
                let point2 = rotatePosition(originPosition: CGPoint(x: point3x, y: point3y),reverse: true)
                let gestureX = point2.x/currentScale
                let gestureY = point2.y/currentScale
                
                let center = CGPoint(x: gestureX - self.bounds.midX,
                                          y: gestureY - self.bounds.midY)
                self.transform = self.transform.translatedBy(x: center.x, y: center.y)
                    .rotated(by: -currentAngle / (angleDuration/repeatingTime) * (CGFloat.pi/180))
                    .translatedBy(x: -center.x, y: -center.y)
                setTxTy()
                
                let radians:Double = atan2( Double(self.transform.b), Double(self.transform.a))
                var degrees:CGFloat = radians * (CGFloat(180) / CGFloat.pi )
                if degrees < 0 {degrees += 360}
                self.angle = degrees
//                canvasView?.num += 1
                if (CGFloat(angleCount) >= (angleDuration/repeatingTime)) {stopTimer(kind: kind)}
            }
            angleTimer?.activate()
        default:
            print("default")
        }
        
    }
    func pauseTiemr() {
        inertiaTimer?.suspend()
    }
    func stopTimer(kind: Int = -1) {
        switch(kind){
        case DraggableImageView.TIMER_INERTIA :
            inertiaTimer?.cancel()
            inertiaTimer = nil
        case DraggableImageView.TIMER_ZOOM:
            zoomTimer?.cancel()
            zoomTimer = nil
        case DraggableImageView.TIMER_ANGLE:
            angleTimer?.cancel()
            angleTimer = nil
        default:
            inertiaTimer?.cancel()
            inertiaTimer = nil
            zoomTimer?.cancel()
            zoomTimer = nil
            angleTimer?.cancel()
            angleTimer = nil
        }
        stopDisplayLink()
//        canvasView!.createTimer()
        
    }
    func getScale() -> Double {
        return sqrt(Double(self.transform.a * self.transform.a + self.transform.c * self.transform.c));
    }
    func getCurrentRotationAngle() -> CGFloat{
        return atan2(self.transform.b, self.transform.a)
    }
    func setTxTy(){
        let diffX = (self.frame.width - scrollView!.frame.width)/2
        let diffY = (self.frame.height - scrollView!.frame.height)/2
        if(self.frame.width < scrollView!.frame.width){ //이미지 넓이가 스크롤뷰 넓이보다 작을 경우
            self.transform = CGAffineTransform(a: self.transform.a, b: self.transform.b, c: self.transform.c, d: self.transform.d, tx: 0, ty: self.transform.ty)
        }
        else{
            if(self.transform.tx > diffX){
                self.transform = CGAffineTransform(a: self.transform.a, b: self.transform.b, c: self.transform.c, d: self.transform.d, tx: diffX, ty: self.transform.ty)
            }
            if(self.transform.tx + diffX < 0){
                self.transform = CGAffineTransform(a: self.transform.a, b: self.transform.b, c: self.transform.c, d: self.transform.d, tx: -diffX, ty: self.transform.ty)
            }
        }
        if(self.frame.height < scrollView!.frame.height){ //이미지 높이가 스크롤뷰 높이보다 작을 경우
            self.transform = CGAffineTransform(a: self.transform.a, b: self.transform.b, c: self.transform.c, d: self.transform.d, tx: self.transform.tx, ty: 0)
        }
        else{
            if(self.transform.ty > diffY){
                self.transform = CGAffineTransform(a: self.transform.a, b: self.transform.b, c: self.transform.c, d: self.transform.d, tx: self.transform.tx, ty: diffY)
            }
            if(self.transform.ty + diffY < 0){
                self.transform = CGAffineTransform(a: self.transform.a, b: self.transform.b, c: self.transform.c, d: self.transform.d, tx: self.transform.tx, ty: -diffY)
            }
        }
    }
    
   
    func transCenter(scale:CGFloat){
        let xOffset = 948.0
        let yOffset = 576.0
        let xRatio = 0.633
        let yRatio = 0.633
        let pointX = 4164.0
        let pointY = 558.0
        let coordX=(pointX + xOffset) * xRatio
        let offsetAndRatioY = (pointY+yOffset) * yRatio
        let coordY=(2375.0 - offsetAndRatioY)
        var coordPoint = self.convertPoint(fromImagePoint: CGPoint(x: coordX, y: coordY))
        coordPoint.x *= scale
        coordPoint.y *= scale
        coordPoint = rotatePosition(originPosition: coordPoint)
        print("coordPoint = \(coordPoint)")
        let diffX = (scrollView!.frame.width - scrollView!.frame.width * scale)/2
        let diffY = (scrollView!.frame.height - scrollView!.frame.height * scale)/2
        let x1 = diffX * cos(self.angle * CGFloat.pi/180)
        let y1 = diffX * sin(self.angle * CGFloat.pi/180)
        let x2 = diffY * sin(self.angle * CGFloat.pi/180)
        let y2 = diffY * cos(self.angle * CGFloat.pi/180)
        let tx = -coordPoint.x + scrollView!.frame.width/2 - x1 + x2
        let ty = -coordPoint.y + scrollView!.frame.height/2 - y1 - y2
        let currentScale = getScale()
        let originDiffX = (scrollView!.frame.width - scrollView!.frame.width * currentScale)/2
        let originDiffY = (scrollView!.frame.height - scrollView!.frame.height * currentScale)/2
        let originX1 = originDiffX * cos(self.angle * CGFloat.pi/180)
        let originY1 = originDiffX * sin(self.angle * CGFloat.pi/180)
        let originX2 = originDiffY * sin(self.angle * CGFloat.pi/180)
        let originY2 = originDiffY * cos(self.angle * CGFloat.pi/180)
        originTx = self.transform.tx + originX1 - originX2
        originTy = self.transform.ty + originY1 + originY2
        resultCoordTx = tx + x1 - x2
        resultCoordTy = ty + y1 + y2
        diffScale = scale - getScale()
        createTimer(kind: DraggableImageView.TIMER_ZOOM)
    }
    
    func setAngleZero(){
        let radians:Double = atan2( Double(self.transform.b), Double(self.transform.a))
        let degrees:CGFloat = radians * (CGFloat(180) / CGFloat.pi )
        currentAngle = degrees
        createTimer(kind: DraggableImageView.TIMER_ANGLE)
    }
    
    private func rotatePosition(originPosition:CGPoint, reverse:Bool = false) -> CGPoint{
        let originX = originPosition.x
        let originY = originPosition.y
        let mx = originX - scrollView!.frame.width / 2
        let my = originY - scrollView!.frame.height / 2
        let ang :CGFloat = {
            if(reverse) {return self.angle}
            else {return -self.angle}
        }()
        let dRadian = ang * ( CGFloat.pi/180)
        let destX = (mx * cos(dRadian)) + (my * sin(dRadian))
        let destY = (mx * sin(dRadian) * -1) + (my * cos(dRadian))
        return CGPoint(x: (destX + scrollView!.frame.width / 2), y: (destY + scrollView!.frame.height / 2))
    }
}


extension DraggableImageView {
    
    func convertPoint2(fromImagePoint imagePoint: CGPoint, imageSize:CGSize, viewSize:CGSize) -> CGPoint {
        
        var viewPoint = imagePoint
        
        let ratioX = viewSize.width / imageSize.width
        let ratioY = viewSize.height / imageSize.height
        
        var scale : CGFloat = 0
        scale = min(ratioX, ratioY)
       
        viewPoint.x *= scale
        viewPoint.y *= scale
        
        viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2.0
        viewPoint.y += (viewSize.height - imageSize.height * scale) / 2.0
        
         return viewPoint
    }
}
