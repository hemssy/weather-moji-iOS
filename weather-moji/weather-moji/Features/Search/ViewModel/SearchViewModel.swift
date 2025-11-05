import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {

    struct Input {
        let searchText: Observable<String>          // 검색창 입력 텍스트
        let searchTrigger: Observable<Void>         // 검색 버튼 or 리턴키 탭
        let locationButtonTapped: Observable<Void>  // 위치 버튼 탭
    }

    struct Output {
        let searchExecuted: Observable<String>      // 검색 실행 이벤트 (검색어 포함)
        let locationTapped: Observable<Void>        // 위치 버튼 탭 이벤트
    }

    func transform(_ input: Input) -> Output {
        // 검색 버튼을 눌렀을 때 입력된 텍스트를 방출
        let searchExecutedByUser = input.searchTrigger
            .withLatestFrom(input.searchText)
            .filter { !$0.isEmpty }

        // 현재 위치 버튼을 눌렀을 때 “서울” 고정 
        let searchExecutedByLocation = input.locationButtonTapped
            .map { "Seoul" }

        // 두 이벤트를 하나로 합침
        let searchExecuted = Observable.merge(searchExecutedByUser, searchExecutedByLocation)

        // Output으로 반환
        return Output(
            searchExecuted: searchExecuted,
            locationTapped: input.locationButtonTapped
        )
    }
}
