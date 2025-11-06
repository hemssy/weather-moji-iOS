import Foundation

// 5일 예보 API 모델
struct ForecastResponse: Codable {
    let list: [Forecast]
}

// 각 예보 데이터 하나(3시간 단위)
struct Forecast: Codable {
    let dt: Int
    let main: ForecastMain
    let weather: [ForecastWeather]
    let dt_txt: String
}

// 온도 정보
struct ForecastMain: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int?
}

// 날씨 상태 정보
struct ForecastWeather: Codable {
    let main: String
    let description: String
    let icon: String
}

