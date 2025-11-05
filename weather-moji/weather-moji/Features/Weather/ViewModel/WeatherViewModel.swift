import Foundation

class WeatherViewModel {
    private let service = WeatherService()
    
    var cityName: String = ""
    var temperatureC: String = ""
    var temperatureF: String = ""
    var windSpeed: String = ""
    var humidity: String = ""
    var weatherDescription: String = ""
    var weatherIconName: String = ""
    
    var onUpdate: (() -> Void)?
    
    func loadWeather(for city: String) {
        service.fetchWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.cityName = data.name
                    self.temperatureC = String(format: "%.1f°C", data.main.temp)
                    self.temperatureF = String(format: "%.1f°F", data.main.temp.cToF)
                    self.windSpeed = String(format: "%.1f m/s", data.wind.speed)
                    self.humidity = "\(data.main.humidity)%"
                    
                    let mainWeather = data.weather.first?.main ?? ""
                    self.weatherDescription = self.customDescription(for: mainWeather)
                    
                    self.weatherIconName = self.iconName(for: mainWeather)
                    
                    self.onUpdate?()
                case .failure(let error):
                    print("날씨 데이터 불러오기 실패:", error.localizedDescription)
                }
            }
        }
    }
    
    private func customDescription(for main: String) -> String {
        switch main {
        case "Clear":
            return "부드러운 햇살이 포근하게 감싸는 맑은 날씨입니다."
        case "Clouds":
            return "회색 하늘이 이어지고 있어요. 쌀쌀할 수 있어요."
        case "Rain":
            return "비 오는 하루, 우산 챙기세요."
        case "Snow":
            return "눈이 와요. 따뜻하게 입고 미끄럼 주의하세요."
        case "Thunderstorm":
            return "강한 비와 번개, 천둥이 동반된 날씨입니다."
        default:
            return "날씨모지와 함께 좋은 하루 보내세요."
        }
    }
    
    private func iconName(for main: String) -> String {
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

