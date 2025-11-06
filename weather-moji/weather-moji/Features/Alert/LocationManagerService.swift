import UIKit
import CoreLocation

class LocationManagerService: NSObject {
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
    }
    
    // 권한 상태 체크 및 요청
    func checkRequestAuthorization() {
        switch locationManager.authorizationStatus {
        
        // 아직 권한 요청이 안되었을 때
        case .notDetermined:
            print("위치 권한 띄우기")
            locationManager.requestAlwaysAuthorization()
            
        // 이미 허용된 상태
        case .authorizedWhenInUse, .authorizedAlways:
            print("허용됨")
                    
        // 허용 안 함
        case .denied, .restricted:
            print("허용 안함")
            
        default:
            break
        }
    }
}
