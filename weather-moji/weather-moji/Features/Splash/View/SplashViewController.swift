import UIKit
import SnapKit

class SplashViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splashLogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexCode: "99C5EF")
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(logoImageView)

        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(200)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { 
            let mainVC = SearchViewController()
            let nav = UINavigationController(rootViewController: mainVC)
            nav.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.first?.rootViewController = nav
        }
    }
}

