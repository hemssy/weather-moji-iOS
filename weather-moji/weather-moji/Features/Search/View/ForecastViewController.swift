import UIKit

class ForecastViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
    }
    
    private func navigationBarCustom() {
        navigationController?.navigationBar.tintColor = .white
        
        // 로고 이미지 추가
        let logoImageView = UIImageView(image: UIImage(named: "titleLogo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        navigationItem.titleView = logoImageView
    }
}
