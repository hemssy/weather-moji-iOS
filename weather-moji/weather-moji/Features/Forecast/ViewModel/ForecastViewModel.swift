import Foundation
import UIKit

final class ForecastViewModel {
    private let service = WeatherService()
    private(set) var forecasts: [Forecast] = []
    var backgroundColors: [UIColor] = []
    
    var onUpdate: (() -> Void)?
    
    func loadForecast() {
        service.fetchForecast { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // 12:00 시각만 필터링해서 5일치 데이터 저장
                    self?.forecasts = response.list.filter { $0.dt_txt.contains("12:00:00") }
                    self?.onUpdate?()
                    
                case .failure(let error):
                    print("예보 불러오기 실패")
                }
            }
        }
    }
}
// 아이콘 매핑하기
extension ForecastViewModel {
    func iconName(for main: String) -> String {
        switch main {
        case "Clear": return "sun"
        case "Clouds": return "cloud"
        case "Rain": return "rain"
        case "Snow": return "snow"
        case "Thunderstorm": return "storm"
        default: return "default"
        }
    }
}

// 배경색 매핑하기
extension ForecastViewModel {
    func backgroundColors(for main: String) -> [UIColor] {
        switch main {
        case "Clear":
            return [UIColor(hexCode: "5497E4"), UIColor(hexCode: "2F547E")]
        case "Clouds":
            return [UIColor(hexCode: "46586D"), UIColor(hexCode: "6883A3")]
        case "Rain":
            return [UIColor(hexCode: "3B4147"), UIColor(hexCode: "75808C")]
        case "Snow":
            return [UIColor(hexCode: "6385AD"), UIColor(hexCode: "92ADC8")]
        case "Thunderstorm":
            return [UIColor(hexCode: "71777E"), UIColor(hexCode: "9EA6B0")]
        default:
            return [UIColor(hexCode: "5497E4"), UIColor(hexCode: "2F547E")]
        }
    }
}