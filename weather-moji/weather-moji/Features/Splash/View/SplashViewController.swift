import UIKit

class SplashViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splashLogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0x99/255, green: 0xC5/255, blue: 0xEF/255, alpha: 1.0) // #99C5EF 하늘색
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 220),
            logoImageView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { // 0.8초 보여주기
            let mainVC = ViewController()
            let nav = UINavigationController(rootViewController: mainVC)
            nav.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.first?.rootViewController = nav
        }
    }
}

