//
//  PointOverlayView.swift
//  DraggableImageViewIOS
//
//  Created by 양윤정 on 4/17/25.
//

import Foundation
import UIKit

/// 이미지 좌표(픽셀) 한 지점을 의미
struct MapPoint {
    let x: CGFloat
    let y: CGFloat
}

final class PointOverlayView: UIView {

    // 화면 좌표로 변환된 결과
    private var screenPoints: [CGPoint] = []

    // 외부에서 업데이트
    func refresh(points: [MapPoint],
                 imageView: UIImageView,
                 scrollView: UIScrollView)
    {
        // ① 이미지 좌표 → 이미지뷰 좌표 → 스크롤뷰 좌표 → 오버레이(self) 좌표
        screenPoints = points.map { mp in
            let pInImageView = CGPoint(x: mp.x, y: mp.y)
            let pInScroll    = imageView.convert(pInImageView, to: scrollView)
            return convert(pInScroll, from: scrollView)
        }
        setNeedsDisplay()
    }

    // ② CoreGraphics로 고정 픽셀 원 그리기
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        let radius: CGFloat = 5          // 항상 5 px
        ctx.setFillColor(UIColor.systemRed.cgColor)
//        ctx.setAllowsAntialiasing(true)
//        ctx.setShouldAntialias(true)
//        ctx.interpolationQuality = .high

        let font          = UIFont.boldSystemFont(ofSize: 14)      // pt 단위
        let textColor     = UIColor.white
        let strokeColor   = UIColor.black
        let strokeWidth   = -3        // 음수 = 내부 채우기 + 외곽선
        let attrs: [NSAttributedString.Key: Any] = [
            .font            : font,
            .foregroundColor : textColor,
            .strokeColor     : strokeColor,
            .strokeWidth     : strokeWidth
        ]
        for (i,p) in screenPoints.enumerated() {
            // 0.5 px 정렬 → 가장 선명
            let cx = round(p.x) + 0.5
            let cy = round(p.y) + 0.5
            ctx.fillEllipse(in: CGRect(x: cx - radius,
                                       y: cy - radius,
                                       width: radius * 2,
                                       height: radius * 2))
            let text      = "Waypoint \(i)" as NSString
            let textSize  = text.size(withAttributes: attrs)
            text.draw(at: CGPoint(x: cx, y: cy), withAttributes: attrs)
        }
        
        
    }
}
