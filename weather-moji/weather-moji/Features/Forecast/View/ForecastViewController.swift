import UIKit
import SnapKit

final class ForecastViewController: UIViewController {
    
    private let viewModel = ForecastViewModel()
    private let stackView = UIStackView()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationBarCustom()
        setupUI()
        setupTableView()
        bindViewModel()
        viewModel.loadForecast()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .singleLine
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
            self?.tableView.reloadData()
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
extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let forecast = viewModel.forecasts[indexPath.row]
        
        cell.textLabel?.text = "\(forecast.dt_txt) | \(forecast.main.temp)°C"
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
}

