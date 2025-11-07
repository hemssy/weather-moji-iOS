//
//  ForecastCell.swift
//  weather-moji
//
//  Created by 김리하 on 11/7/25.
//

import UIKit
import SnapKit

final class ForecastCell: UITableViewCell {
    
    private let containerView = UIView()
    private let dayLabel = UILabel()
    private let weatherIcon = UIImageView()
    private let tempLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.backgroundColor = .clear
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(90)
        }
        
        [dayLabel, weatherIcon, tempLabel].forEach { containerView.addSubview($0) }
        
        dayLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        dayLabel.textColor = .white
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        weatherIcon.contentMode = .scaleAspectFit
        weatherIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        tempLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        tempLabel.textColor = .white
        tempLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with forecast: Forecast, index: Int) {
        let days = ["오늘", "내일", "모레", "3일 후", "4일 후"]
        dayLabel.text = days[index]
        
        tempLabel.text = "\(Int(forecast.main.temp))°C"
        weatherIcon.image = UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal)
    }
}


