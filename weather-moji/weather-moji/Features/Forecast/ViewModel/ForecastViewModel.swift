import Foundation

final class ForecastViewModel {
    private let service = WeatherService()
    private(set) var forecasts: [Forecast] = []
    
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

