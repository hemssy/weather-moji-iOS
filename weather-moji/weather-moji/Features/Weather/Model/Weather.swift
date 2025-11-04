struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}

// 섭씨(C) -> 화씨(F) 변환
extension Double {
    var cToF: Double { (self * 9/5) + 32 }
}

