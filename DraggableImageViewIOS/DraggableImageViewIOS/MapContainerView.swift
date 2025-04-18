//
//  MapContainerView.swift
//  DraggableImageViewIOS
//
//  Created by 양윤정 on 4/17/25.
//

import Foundation
import UIKit

class MapContainerView: UIView {

    // MARK: ① Subview 구성 -----------------------------------------------------

    let scrollView   = UIScrollView()
    let imageView    = UIImageView()
    private let overlayView = PointOverlayView()

    // 그릴 포인트
    var mapPoints: [MapPoint] = [] {
        didSet { overlayView.refresh(points: mapPoints,
                                     imageView: imageView,
                                     scrollView: scrollView) }
    }

    // MARK: ② 초기 설정 -------------------------------------------------------

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        // scrollView 설정
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 6.0
        scrollView.zoomScale = 0.1
        scrollView.delegate = self
        addSubview(scrollView)

        // 이미지 뷰 설정
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)

        // ★ 오버레이는 scrollView 밖(= 줌 영향 없음)
        overlayView.isUserInteractionEnabled = false
        overlayView.backgroundColor = .clear
        addSubview(overlayView)
    }

    // MARK: ③ 레이아웃 --------------------------------------------------------

    override func layoutSubviews() {
        super.layoutSubviews()

        scrollView.frame  = bounds
        overlayView.frame = bounds

        // imageView는 컨텐츠 사이즈 결정 후 frame 설정
        if let img = imageView.image {
            imageView.frame = CGRect(origin: .zero, size: img.size)
            scrollView.contentSize = img.size
        }

        // 처음 진입 시 한 번 좌표 변환
        overlayView.refresh(points: mapPoints,
                            imageView: imageView,
                            scrollView: scrollView)
    }
}

// MARK: ④ UIScrollViewDelegate 구현 ------------------------------------------

extension MapContainerView: UIScrollViewDelegate {

    // 줌 대상은 이미지뷰만!
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("viewForZooming")
        return imageView
    }

    // 스크롤·줌 변화 때마다 오버레이 좌표 갱신
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("scrollViewDidZoom")
        overlayView.refresh(points: mapPoints,
                            imageView: imageView,
                            scrollView: scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll")
//        overlayView.refresh(points: mapPoints,
//                            imageView: imageView,
//                            scrollView: scrollView)
    }
}
