import UIKit
import SnapKit

final class TempToggleView: UIView {
    private let segmentedControl: UISegmentedControl = {
        let tempControl = UISegmentedControl(items: ["섭씨 (°C)", "화씨 (°F)"])
        tempControl.selectedSegmentIndex = 0
        tempControl.backgroundColor = .white
        tempControl.selectedSegmentTintColor = .systemBlue
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        
        tempControl.setTitleTextAttributes(normalAttributes, for: .normal)
        tempControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        return tempControl
    }()
    
    var selectedIndex: Int {
        return segmentedControl.selectedSegmentIndex
    }
    
    var onValueChanged: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        segmentedControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    @objc private func valueChanged() {
        onValueChanged?(segmentedControl.selectedSegmentIndex)
    }
}
