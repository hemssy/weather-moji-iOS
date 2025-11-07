import UIKit
import SnapKit

final class ForecastViewController: UIViewController, UITableViewDelegate {
    
    private let viewModel = ForecastViewModel()
    private let stackView = UIStackView()
    private let tableView = UITableView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "서울 날씨 모지?"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        navigationBarCustom()
        setupUI()
        setupTableView()
        bindViewModel()
        viewModel.loadForecast()
        showTitleLabelAnimation()

    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = 80
        
        tableView.register(ForecastCell.self, forCellReuseIdentifier: "ForecastCell")
        
        tableView.contentInset = UIEdgeInsets(top: 120, left: 0, bottom: 0, right: 0)
    }
    
    private func setupUI() {
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
        }
        
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
            self.tableView.reloadData()
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
    
    private func showTitleLabelAnimation() {
        titleLabel.alpha = 0
        UIView.animate(withDuration: 1.5) {
            self.titleLabel.alpha = 1
        }
    }

}

extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ForecastCell",
                    for: indexPath
                ) as? ForecastCell else {
                    return UITableViewCell()
                }

        let forecast = viewModel.forecasts[indexPath.row]
        let mainWeather = forecast.weather.first?.main ?? ""
        let icon = viewModel.iconName(for: mainWeather)
        cell.configure(with: forecast, index: indexPath.row, iconName: icon)

        
        return cell
    }
}

extension ForecastViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}
