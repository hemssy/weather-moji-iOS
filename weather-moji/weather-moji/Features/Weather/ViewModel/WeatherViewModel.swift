import Foundation

class WeatherViewModel {
    private let service = WeatherService()
    
    var cityName: String = ""
    var temperatureC: String = ""
    var temperatureF: String = ""
    var windSpeed: String = ""
    var humidity: String = ""
    
    var onUpdate: (() -> Void)?
    
    func loadWeather(for city: String) {
        service.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.cityName = data.name
                    self?.temperatureC = String(format: "%.1f°C", data.main.temp)
                    self?.temperatureF = String(format: "%.1f°F", data.main.temp.cToF)
                    self?.windSpeed = String(format: "%.1f m/s", data.wind.speed)
                    self?.humidity = "\(data.main.humidity)%"
                    self?.onUpdate?()
                case .failure(let error):
                    print("날씨 데이터 불러오기 실패:", error.localizedDescription)
                }
            }
        }
    }
}

