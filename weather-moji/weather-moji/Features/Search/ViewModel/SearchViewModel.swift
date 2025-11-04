import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {

    // Input: View에서 들어오는 이벤트
    struct Input {
        let searchText: Observable<String>          // 검색창 입력 텍스트
        let searchTrigger: Observable<Void>         // 검색 버튼 또는 리턴키 탭
        let locationButtonTapped: Observable<Void>  // 위치 버튼 탭
    }
    
    // Output: View로 내보낼 결과
    struct Output {
        let searchExecuted: Observable<String>      // 검색 실행 이벤트 (검색어 포함)
        let locationTapped: Observable<Void>        // 위치 버튼 탭 이벤트
    }
    
    // 변환 메서드 (Input -> Output)
    func transform(_ input: Input) -> Output {
        // 검색 버튼 또는 리턴키 누를 때 최신 텍스트 가져오기
        let searchExecuted = input.searchTrigger
            .withLatestFrom(input.searchText)  // 최근 입력 텍스트와 결합
            .filter { !$0.isEmpty }            // 빈 문자열은 제외
        
        // Output으로 반환
        return Output(
            searchExecuted: searchExecuted,
            locationTapped: input.locationButtonTapped
        )
    }
}
