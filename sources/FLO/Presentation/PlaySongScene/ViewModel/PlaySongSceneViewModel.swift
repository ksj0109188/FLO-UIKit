//
//  ViewModel.swift
//  FLO
//
//  Created by 김성준 on 4/19/24.
//

import Foundation
import AVKit
import Combine

///note: FlowCoordinator 정의한 화면 흐름을 실행
struct PlaySongSceneViewModelActions {
    let showDetailLyrics: (SongDTO, PlayerManager) -> Void
}

///note: ViewController에서 ViewModel한테 입력 이벤트 전달
protocol PlaySongSceneViewModelInput {
    func showDetailLyrics() -> Void
}

///note: ViewModel에서 방출 할 수 있는 Output
protocol PlaySongSceneViewModelOutput {
    var songDTO: SongDTO? {get set}
    var songSubject: PassthroughSubject<SongDTO, Never> { get set }
    func syncLyrics(time: CMTime, inputTimeType: TimeType) -> [(String, HighlighType)]
}

typealias PlaySongSceneViewModelInOutput = PlaySongSceneViewModelInput & PlaySongSceneViewModelOutput

final class PlaySongSceneViewModel: PlaySongSceneViewModelInOutput, PlayableViewModel {
    private let fetchSongUseCase: FetchSongUseCase
    private let actions: PlaySongSceneViewModelActions
    var playerManager: PlayerManager
    var songDTO: SongDTO?
    var songSubject = PassthroughSubject<SongDTO, Never>()
    var subscription = Set<AnyCancellable>()
    
    init(fetchSongUseCase: FetchSongUseCase, playerManager: PlayerManager, actions: PlaySongSceneViewModelActions) {
        self.fetchSongUseCase = fetchSongUseCase
        self.playerManager = playerManager
        self.actions = actions
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
                if let fileURL = URL(string: $0.file) {
                    self?.setPlayerURL(url: fileURL)
                }
                self?.songDTO = $0
                self?.songSubject.send($0)
            })
            .store(in: &subscription)
    }
    
    func setPlayerURL(url: URL) {
        self.playerManager.configure(url: url)
    }
    
    ///note:  메인화면 노래재생시 가사 싱크를 맞추기위한 메소드
    /// - Parameter time:  CMTime
    /// - Parameter InputTimeType:  milseconds로 변환 후 처리하기 위한 입력값으로 입력되는 CMTime값 기준 milSeconds, seconds 타입도 전달 필요
    /// - Returns : [(String, HighlighType)] 튜플 형태의 배열로 String은 가사, HighlighType은 현재 진행중인 가사를 표시하기 위한 용도
    func syncLyrics(time: CMTime, inputTimeType: TimeType) -> [(String, HighlighType)] {
        let milliseconds: Int
        var lyrics: [(String, HighlighType)] = []
        
        switch inputTimeType {
            case .milSeconds:
                milliseconds = Int(CMTimeGetSeconds(time))
            case .seconds:
                milliseconds = Int(CMTimeGetSeconds(time) * 1000)
        }

        if let songDTO = songDTO {
            let transformedLyrics = songDTO.transformedLyrics
            let timeLine = songDTO.timeLineLyrics
            let target = timeLine.filter { $0 <= milliseconds}.max() ?? 0
            let targetIndex = timeLine.firstIndex(of: target)
            // 노래 시작전
            if targetIndex == nil {
                lyrics.append((transformedLyrics[timeLine[0]] ?? "", .nonHighLight))
                lyrics.append((transformedLyrics[timeLine[1]] ?? "", .nonHighLight))
            // 노래 시작
            } else if let targetIndex = targetIndex, targetIndex + 1 <= timeLine.count - 1{
                lyrics.append((transformedLyrics[timeLine[targetIndex]] ?? "", .HighLight ))
                lyrics.append((transformedLyrics[timeLine[targetIndex + 1]] ?? "", .nonHighLight ))
            }
            // 노래 마지막 부분
            else if let targetIndex = targetIndex, targetIndex == timeLine.count - 1 {
                lyrics.append((transformedLyrics[timeLine[targetIndex - 1]] ?? "", .nonHighLight ))
                lyrics.append((transformedLyrics[timeLine[targetIndex]] ?? "", .HighLight ))
            }
        }
        
        return lyrics
    }
    
    func showDetailLyrics() {
        if let songDTO = self.songDTO {
            actions.showDetailLyrics(songDTO, playerManager)
        }
    }
    
    
}
