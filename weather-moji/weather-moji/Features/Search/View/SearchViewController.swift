import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()
    private let weatherViewModel = WeatherViewModel()
    
    private let searchButton = UIButton(type: .system)
    
    // 검색어 입력 필드
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "지역명을 입력해주세요."
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.returnKeyType = .search
        textField.textColor = .darkGray
        textField.font = .systemFont(ofSize: 16)
        textField.layer.cornerRadius = 17
        textField.layer.borderWidth = 1 // 0으로 변경 예정
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    // 현재 위치 버튼
    private let locationButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "location")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.2
        button.layer.borderColor = UIColor.black.cgColor // 위치버튼 테두리
        button.clipsToBounds = true
        return button
    }()
    
    // 날씨 표시용 라벨들
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let tempFLabel = UILabel()
    private let windLabel = UILabel()
    private let humidityLabel = UILabel()
    
    // 하단 컨테이너 뷰
    private let bottomContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        configureSearchButton()
        bindWeatherViewModel()
    }
    
    // 돋보기 버튼 설정
    private func configureSearchButton() {
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .darkGray
        searchButton.frame = CGRect(x: 0, y: 0, width: 36, height: 24)
        searchTextField.rightView = searchButton
        searchTextField.rightViewMode = .always
    }
    
    // UI 설정
    private func setupUI() {
        view.backgroundColor = .white
        
        // 날씨 정보 스택뷰
        let weatherStack = UIStackView(arrangedSubviews: [
            cityLabel, tempLabel, tempFLabel, windLabel, humidityLabel
        ])
        weatherStack.axis = .vertical
        weatherStack.alignment = .leading
        weatherStack.spacing = 10
        
        view.addSubview(weatherStack)
        weatherStack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 하단 컨테이너 레이아웃
        view.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.equalTo(50)
        }
        
        // 수평 스택뷰 구성 (검색창 + 위치 버튼)
        let hStack = UIStackView(arrangedSubviews: [searchTextField, locationButton])
        hStack.axis = .horizontal
        hStack.alignment = .fill
        hStack.distribution = .fill
        hStack.spacing = 15
        
        bottomContainer.addSubview(hStack)
        hStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // 검색창 높이 고정
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        // 위치 버튼 크기 고정 (정사각형 + 검색창 높이에 맞춤)
        locationButton.snp.makeConstraints {
            $0.width.equalTo(44)
            $0.height.equalTo(searchTextField)
        }
        
        // 우선순위 조정 (검색창이 남은 공간 채움)
        searchTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        locationButton.setContentHuggingPriority(.required, for: .horizontal)
    }

    
    private func bindViewModel() {
        let input = SearchViewModel.Input(
            searchText: searchTextField.rx.text.orEmpty.asObservable(),
            searchTrigger: Observable.merge(
                searchButton.rx.tap.asObservable(),
                searchTextField.rx.controlEvent(.editingDidEndOnExit).asObservable()
            ),
            locationButtonTapped: locationButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.searchExecuted
            .subscribe(onNext: { [weak self] query in
                self?.weatherViewModel.loadWeather(for: query)
            })
            .disposed(by: disposeBag)

    }
    
    private func bindWeatherViewModel() {
        weatherViewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.cityLabel.text = "지역: \(self.weatherViewModel.cityName)"
            self.tempLabel.text = "온도(섭씨): \(self.weatherViewModel.temperatureC)"
            self.tempFLabel.text = "온도(화씨): \(self.weatherViewModel.temperatureF)"
            self.windLabel.text = "풍속: \(self.weatherViewModel.windSpeed)"
            self.humidityLabel.text = "습도: \(self.weatherViewModel.humidity)"
        }
    }
}
