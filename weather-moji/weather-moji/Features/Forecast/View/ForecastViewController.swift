import UIKit
import SnapKit

final class ForecastViewController: UIViewController {
    
    private let viewModel = ForecastViewModel()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationBarCustom()
        setupUI()
        bindViewModel()
        viewModel.loadForecast()
    }
    
    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            for forecast in self.viewModel.forecasts {
                let label = UILabel()
                label.text = "\(forecast.dt_txt) , \(forecast.main.temp)°C"
                label.textAlignment = .center
                self.stackView.addArrangedSubview(label)
            }
        }
    }
    
    private func navigationBarCustom() {
        navigationController?.navigationBar.tintColor = .white

        let logoImageView = UIImageView(image: UIImage(named: "titleLogo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        navigationItem.titleView = logoImageView
    }
}

