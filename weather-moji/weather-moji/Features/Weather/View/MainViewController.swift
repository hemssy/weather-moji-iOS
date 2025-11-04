import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private let viewModel = WeatherViewModel()
    
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let tempFLabel = UILabel()
    private let windLabel = UILabel()
    private let humidityLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        bindViewModel()
        
        // 지역 바꿔가면서 해보기.. 근데 영어로만 가능함
        viewModel.loadWeather(for: "Seoul")
    }
    
    private func setupUI() {

        let stack = UIStackView(arrangedSubviews: [
            cityLabel,
            tempLabel,
            tempFLabel,
            windLabel,
            humidityLabel
        ])

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        
        view.addSubview(stack)
        
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.cityLabel.text = "지역이름: \(self.viewModel.cityName)"
            self.tempLabel.text = "온도(섭씨): \(self.viewModel.temperatureC)"
            self.tempFLabel.text = "온도(화씨): \(self.viewModel.temperatureF)"
            self.windLabel.text = "풍속: \(self.viewModel.windSpeed)"
            self.humidityLabel.text = "습도: \(self.viewModel.humidity)"
        }
    }
}

