import Foundation

class WeatherService {
    private let apiKey = "2dafcfcea7942ab35fd40ac0d151fe89"

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&lang=kr&units=metric"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchForecast(completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
        // 서울 고정 (위도/경도)
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=37.5665&lon=126.9780&appid=\(apiKey)&units=metric&lang=kr"
        guard let url = URL(string: urlString) else {
            print("잘못된 URL이다.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

