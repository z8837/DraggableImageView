import UIKit
import CoreText
// 256×256px 타일, 페이드 없음
final class MyTiledLayer: CATiledLayer {

    weak var owner: DraggableImageView?
    var currentZoom: CGFloat = 1.0
    
    override class func fadeDuration() -> CFTimeInterval {
        return 0  // 페이드 애니메이션 제거 (즉시 렌더링)
    }

    // 레이어 초기 설정
    override init() {
        super.init()
        contentsScale = UIScreen.main.scale
        tileSize = CGSize(width: 1024, height: 1024)
        levelsOfDetail = 2              // 축소 4단계
        levelsOfDetailBias = 4          // 확대 4단계
        for i in 0...2{
            for num in 25...31{
                let y:CGFloat = CGFloat(num) * 10
                let x:CGFloat = CGFloat((num-10) + i*10) * 10
                points.append(MapPoint(x: x, y: y))
            }
        }
        points.append(MapPoint(x: 322, y: 304))
    }
    var points = [MapPoint]()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func align(_ v: CGFloat) -> CGFloat { round(v) + 0.5 }
    private var num = 0
    override func draw(in ctx: CGContext) {
//        print("draw함수 : \(num)")
        num+=1
        
        
        guard let view = owner else { return }
        let tileRect = ctx.boundingBoxOfClipPath
        
//        let zoom = currentZoom
        let zoom = currentZoom

        let dotRadiusPx: CGFloat = 5 / zoom
        let lineWidthPx: CGFloat = 1

       
        
        ctx.saveGState()
//        ctx.setAllowsAntialiasing(true)
//        ctx.setShouldAntialias(true)
//        ctx.interpolationQuality = .high
        ctx.translateBy(x: 0, y: bounds.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        let currentAngle = view.getCurrentRotationAngle()
        let fontSize: CGFloat = 14 / zoom
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica-Bold", size: fontSize)!,
            .foregroundColor: UIColor.black,
            .strokeWidth : -3,
            .strokeColor : UIColor.red
        ]
        for (i, point) in points.enumerated() {
            let imagePt = CGPoint(x: point.x, y: point.y)
            let viewPt = CGPoint(x: align(imagePt.x), y: bounds.height - align(imagePt.y))
            
            if !tileRect.contains(imagePt){
//                continue
            }
            // ① 원 그리기
            ctx.setFillColor(UIColor.systemRed.cgColor)
            ctx.setLineWidth(lineWidthPx)
            let circleRect = CGRect(x: viewPt.x - dotRadiusPx,
                                    y: viewPt.y - dotRadiusPx,
                                    width: dotRadiusPx * 2,
                                    height: dotRadiusPx * 2)
            ctx.fillEllipse(in: circleRect)
            
            ctx.saveGState()
            ctx.translateBy(x: round(viewPt.x), y: round(viewPt.y))
            let angle = view.getCurrentRotationAngle() * 180 / .pi
            ctx.rotate(by: currentAngle)
//            ctx.rotate(by: view.angle * .pi / 180)
            // ② CoreText 텍스트 그리기
            let text = "Waypoint \(i)" as CFString
            
//            let attrStr = CFAttributedStringCreate(nil, text, [
//                kCTFontAttributeName: CTFontCreateWithName("Helvetica-Bold" as CFString, fontSize, nil),
//                kCTForegroundColorAttributeName: UIColor.black.cgColor
//            ] as CFDictionary)
            
            
            let attrStr = NSAttributedString(string: text as String, attributes: attributes)
            
            let line = CTLineCreateWithAttributedString(attrStr)
            let bounds = CTLineGetBoundsWithOptions(line, .useOpticalBounds)
            let textPos = CGPoint(x: viewPt.x - bounds.width / 2,
                                  y: viewPt.y - dotRadiusPx - 4 - bounds.height)
            
            ctx.textPosition = CGPoint(x: -bounds.width / 2, y: -dotRadiusPx - 4 - bounds.height)
            
            CTLineDraw(line, ctx)
            ctx.restoreGState()
        }
        
        ctx.restoreGState()
    }
    
    func renderTextImage(text: String, fontSize: CGFloat) -> UIImage {
        let font = UIFont(name: "Helvetica-Bold", size: fontSize)!
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black,
            .strokeWidth: -2.0  // 음수: fill + stroke
        ]

        let size = (text as NSString).size(withAttributes: attributes)
        let padding: CGFloat = 4
        let imageSize = CGSize(width: ceil(size.width + padding * 2), height: ceil(size.height + padding * 2))

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setAllowsAntialiasing(true)
        context.setShouldAntialias(true)
        context.interpolationQuality = .high

        let drawPoint = CGPoint(x: padding, y: padding)
        (text as NSString).draw(at: drawPoint, withAttributes: attributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }
}
