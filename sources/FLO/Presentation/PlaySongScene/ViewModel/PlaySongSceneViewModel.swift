//
//  ViewModel.swift
//  FLO
//
//  Created by 김성준 on 4/19/24.
//

import Foundation
import Combine

///note: FlowCoordinator 정의한 화면 흐름을 실행
//struct Actions {
//    func makeDetailLyricsTableViewController()
//}

///note: ViewController에서 ViewModel한테 입력 이벤트 전달
protocol PlaySongSceneViewModelInput {
    
}

///note: ViewModel에서 방출 할 수 있는 Output
protocol PlaySongSceneViewModelOutput {
    var songSubject : PassthroughSubject<Song, Never> { get set }
}

typealias PlaySongSceneViewModelInOutput = PlaySongSceneViewModelInput & PlaySongSceneViewModelOutput

final class PlaySongSceneViewModel: PlaySongSceneViewModelInOutput {
    let playerManger = PlayerManager()
    private let fetchSongUseCase: FetchSongUseCase
    private var song: Song?
    var songSubject = PassthroughSubject<Song, Never>()
    
    var subscription = Set<AnyCancellable>()
    
    init(fetchSongUseCase: FetchSongUseCase) {
        self.fetchSongUseCase = fetchSongUseCase
        loadData()
    }
    
    private func loadData() {
        fetchSongUseCase.fetchData()
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let failure):
                        debugPrint(failure.localizedDescription)
                }
            }, receiveValue: { [weak self] in
                self?.song = $0
                self?.songSubject.send($0)
            })
            .store(in: &subscription)
    }
    
//    func observe() -> AnyPublisher<Song, Never> {
//        song.publisher.eraseToAnyPublisher()
//    }
    
}
