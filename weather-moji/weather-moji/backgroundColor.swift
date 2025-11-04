import UIKit
import RxSwift
import RxCocoa

// 재사용 가능한 그라데이션 배경 뷰
final class BackgroundColorView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    init(colors: [UIColor],
         startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
         endPoint: CGPoint = CGPoint(x: 0.5, y: 1))
    {
        
        super.init(frame: .zero)
        setupGradient(colors: colors,
                      startPoint: startPoint,
                      endPoint: endPoint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradient(colors: [UIColor],
                               startPoint: CGPoint,
                               endPoint: CGPoint) {
        
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // 뷰 크기가 변경될 때마다 그라데이션이 뷰를 채우게
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

// RxSwift 확장
extension Reactive where Base: BackgroundColorView {
    // hex 문자열 배열을 받아 UIColor로 변환 -> 그라데이션 적용
    var gradientColors: Binder<[String]> {
        return Binder(base) { view, hexArray in
            let uiColors = hexArray.compactMap { UIColor(hexCode: $0) }
            view.gradientLayer.colors = uiColors.map { $0.cgColor}
        }
    }
}
