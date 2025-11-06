import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()
    private let weatherViewModel = WeatherViewModel()
    private let locationManager = LocationManagerService()
    
    private let navigationBarTitle = UINavigationBar()
    private let tempToggleView = TempToggleView()
    
    private let searchButton = UIButton(type: .system)
    
    private let backgroundColor = BackgroundColorView(colors: [
        UIColor(hexCode: "5497E4"),
        UIColor(hexCode: "2F547E")
    ])
    
    // 스크롤 뷰로 뷰 전체 감싸기
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    // 당겨서 새로고침
    private let refreshControl = UIRefreshControl()
    
    private let contentView = UIView()
    
    // 최상단 타이틀 라벨
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 날씨 모지?"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    // 지역 라벨
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    // 날씨 이미지
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sun")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // 섭씨 라벨
    private let tempClabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()
    
    // 화씨 라벨
    private let tempFlabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()
    
    // 풍속 라벨
    private let windLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    // 습도 라벨
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    // 풍속, 습도 스택
    private lazy var weatherHStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [windLabel, humidityLabel])
        hStack.axis = .horizontal
        hStack.spacing = 80
        return hStack
    }()
    
    // 날씨 설명 라벨
    private let explanLabel: UILabel = {
        let label = UILabel()
        label.text = "날씨 설명을 하는 라벨입니다~"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // 검색어 입력 필드
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "지역명을 입력해주세요."
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 17
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor

        // 돋보기 아이콘 추가
        let iconImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconImageView.tintColor = .darkGray
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 4, y: 0, width: 18, height: 18)

        // 컨테이너 폭을 늘려서 오른쪽으로 살짝 옮김
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 30))
        iconContainerView.addSubview(iconImageView)
        iconImageView.center = iconContainerView.center

        textField.leftView = iconContainerView
        textField.leftViewMode = .always

        return textField
    }()


    private let searchIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
            imageView.tintColor = .darkGray
            imageView.contentMode = .scaleAspectFit
        return imageView
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
        button.layer.borderColor = UIColor.white.cgColor // 위치버튼 테두리
        button.clipsToBounds = true
        return button
    }()
    
    
    // 하단 컨테이너 뷰
    private let bottomContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel.loadWeather(for: "Seoul")
        setBackgroundConstraints()
        setupNavigationTitle()
        setupUI()
        bindViewModel()
        configureSearchButton()
        pullToRefresh()
        locationManager.checkRequestAuthorization()
    }
    
    // 배경 설정
    private func setBackgroundConstraints() {
        view.addSubview(backgroundColor)
        backgroundColor.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // navigationTitle 이미지 설정
    private func setupNavigationTitle() {
        let logoImageView = UIImageView(image: UIImage(named: "titleLogo"))
        logoImageView.contentMode = .scaleAspectFit
        
        let container = UIView()
        container.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(40)
        }
        navigationItem.titleView = container
    }
    
    // 돋보기 버튼 설정
    private func configureSearchButton() {
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .darkGray
        
        
        searchButton.frame = CGRect(x: 0, y: 0, width: 36, height: 24)
        
    }
    
    // UI 설정
    private func setupUI() {
        view.backgroundColor = .white

        // 날씨 정보를 모두 vStack으로 묶기
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, cityLabel, weatherImage, tempToggleView, tempClabel, tempFlabel, weatherHStack, explanLabel])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 30
        
        // mainStack을 contentView에
        contentView.addSubview(mainStack)
        
        // contentView를 scrollView에 추가
        scrollView.addSubview(contentView)
        
        // scrollView를 view에 추가
        view.addSubview(scrollView)
    
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)

        }
        
        mainStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(100)
        }
        
        weatherImage.snp.makeConstraints {
            $0.width.height.equalTo(150)
        }
        
        tempToggleView.snp.makeConstraints {
            $0.width.equalTo(250)
            $0.height.equalTo(80)
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
            $0.trailing.equalTo(locationButton.snp.leading).offset(-20)
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
    
    // 당겨서 새로고침 설정
    private func pullToRefresh() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        refreshControl.tintColor = .white
    }

    // 당겨서 새로고침 동작 처리
    @objc private func handleRefresh() {
        // 현재 지역 날씨 데이터로 초기화
        let cureentCityWheather = weatherViewModel.cityName
        weatherViewModel.loadWeather(for: cureentCityWheather)
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
        
        // 날씨 데이터
        weatherViewModel.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.cityLabel.text = self.weatherViewModel.cityName
            self.tempClabel.text = "\(self.weatherViewModel.temperatureC)"
            self.tempFlabel.text = "\(self.weatherViewModel.temperatureF)"
            self.windLabel.setSymbolText("wind", text: "\(self.weatherViewModel.windSpeed)", color: .white)
            self.humidityLabel.setSymbolText("drop", text: "\(self.weatherViewModel.humidity)", color: .white)
            
            self.explanLabel.text = self.weatherViewModel.weatherDescription
            self.weatherImage.image = UIImage(named: self.weatherViewModel.weatherIconName)

            if self.tempToggleView.selectedIndex == 0 {
                self.tempClabel.isHidden = false
                self.tempFlabel.isHidden = true
            } else {
                self.tempClabel.isHidden = true
                self.tempFlabel.isHidden = false
            }
            // 새로고침 종료(날씨 데이터 로드 완료 시)
            self.refreshControl.endRefreshing()
        }
        
        // 토글 이벤트 연결
        tempToggleView.onValueChanged = { [weak self] selectedIndex in
            guard let self = self else { return }

            if selectedIndex == 0 {
                self.tempClabel.isHidden = false
                self.tempFlabel.isHidden = true
            } else {
                self.tempClabel.isHidden = true
                self.tempFlabel.isHidden = false
            }

        }

    }
    
}


// Label에 이미지와 같이 작성할 수 있게
extension UILabel {
    func setSymbolText(_ systemName: String, text: String, color: UIColor = .label) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: systemName)?
            .withTintColor(color, renderingMode: .alwaysOriginal)
        
        // 아이콘 크기 맞추기
        let symbolSize: CGFloat = self.font.lineHeight
        attachment.bounds = CGRect(x: 0, y: (self.font.capHeight - symbolSize) / 2, width: symbolSize, height: symbolSize)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: " " + text, attributes: [.foregroundColor: color, .font: self.font ?? UIFont.systemFont(ofSize: 14)])
        
        let final = NSMutableAttributedString()
        final.append(attachmentString)
        final.append(textString)
        
        self.attributedText = final

    }
}
