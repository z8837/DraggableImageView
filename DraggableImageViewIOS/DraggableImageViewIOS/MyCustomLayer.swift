//
//  MyCustomLayer.swift
//  DraggableImageViewIOS
//
//  Created by 양윤정 on 4/17/25.
//

import Foundation
import UIKit

// ① 커스텀 CALayer
final class MyCustomLayer: CALayer {
    
    weak var owner: DraggableImageView?

    convenience init(owner: DraggableImageView) {
        self.init()
        self.owner = owner
        needsDisplayOnBoundsChange = true
    }
    var currentZoom: CGFloat = 1      // DraggableImageView가 채워 줌
    // MARK: - 기본 이니셜라이저
   override init() {
       super.init()
       commonInit()
   }

   // Interface Builder용
   required init?(coder: NSCoder) {
       super.init(coder: coder)
       commonInit()
   }

   // ⚠️ 반드시 구현!  (레이어 복사/애니메이션 프레젠테이션 레이어 생성 시 사용)
   override init(layer: Any) {
       super.init(layer: layer)

       // 원본이 MyCustomLayer라면 커스텀 값 복사
       if let src = layer as? MyCustomLayer {
           self.owner       = src.owner
           self.currentZoom = src.currentZoom
       }
       commonInit()
   }

   // 공통 설정
   private func commonInit() {
       isOpaque        = false
       backgroundColor = UIColor.clear.cgColor
       contentsScale   = UIScreen.main.scale
       needsDisplayOnBoundsChange = true
   }
    
    
    
    

    let points = [
        MapPoint(x: 150, y: 250),
        MapPoint(x: 160, y: 260),
        MapPoint(x: 170, y: 270),
        MapPoint(x: 180, y: 280),
        MapPoint(x: 190, y: 290),
        MapPoint(x: 200, y: 300),
        MapPoint(x: 210, y: 310),
    ]
    // ② 여기서 CoreGraphics 드로잉
    override func draw(in ctx: CGContext) {
        guard let view = owner else { return }

        // 1) 이미지뷰 현재 배율
        let zoom = currentZoom    // ex. 1.0, 2.3, 5.6 …

//        // 2) 캔버스 역‑스케일 → “화면 픽셀 단위”로 그리게 됨
        ctx.saveGState()
        ctx.scaleBy(x: 1/zoom, y: 1/zoom)

        // 3) 안티앨리어싱 옵션
        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)
        ctx.interpolationQuality = .high

        // 4) 고정 픽셀 크기·선폭
        let dotRadiusPx : CGFloat = 5           // 화면에서 항상 5 px
        let lineWidthPx: CGFloat = 1            // 1 px 테두리

        // 5) 선명도를 위한 0.5 px 정렬 헬퍼
        func align(_ v: CGFloat) -> CGFloat { round(v) + 0.5 }

        // 6) 예시 포인트 1개 (여러 개면 loop)
        for (i,point) in points.enumerated(){
            let imagePt = CGPoint(x: point.x, y: point.y)           // “이미지 좌표”
            
//            let viewPt = CGPoint(x: imagePt.x * zoom, y: imagePt.y * zoom)
            let viewPt  = view.layer.convert(imagePt, to: self)   // 레이어 좌표

            // 6‑1) 원
            ctx.setFillColor(UIColor.systemRed.cgColor)
            ctx.setLineWidth(lineWidthPx)
            ctx.fillEllipse(in: CGRect(x: align(viewPt.x) - dotRadiusPx,
                                       y: align(viewPt.y) - dotRadiusPx,
                                       width: dotRadiusPx * 2,
                                       height: dotRadiusPx * 2))

            // 6‑2) 텍스트
            let text      = "Waypoint \(i)" as NSString
            let font      = UIFont.boldSystemFont(ofSize: 14)   // pt == px*2 레티나
            let attrs: [NSAttributedString.Key: Any] = [
                .font            : font,
                .foregroundColor : UIColor.white,
                .strokeColor     : UIColor.black,
                .strokeWidth     : -3                            // 음수 = 채움+외곽
            ]

            UIGraphicsPushContext(ctx)                         // UIKit 텍스트 사용
            let size = text.size(withAttributes: attrs)
            let txtOrg = CGPoint(x: align(viewPt.x) - size.width/2,
                                 y: align(viewPt.y) - dotRadiusPx - 4 - size.height)
            text.draw(at: txtOrg, withAttributes: attrs)
        }
        
        UIGraphicsPopContext()

        ctx.restoreGState()               // 상태 복귀
    }
}

// ③ 이미지뷰 서브클래스
final class DraggableImageView2: UIImageView {

    private let customLayer = MyCustomLayer()

    override func layoutSubviews() {
        super.layoutSubviews()

        // (a) 계층에 붙였는지?
        if customLayer.superlayer == nil {
            layer.addSublayer(customLayer)
        }

        // (b) 크기 0×0이면 안 그려진다 → 항상 갱신
        customLayer.frame = bounds
    }    
}
