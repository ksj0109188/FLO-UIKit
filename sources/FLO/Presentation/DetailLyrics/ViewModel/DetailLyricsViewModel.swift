//
//  DetailLyricsViewModel.swift
//  FLO
//
//  Created by 김성준 on 5/1/24.
//

import Foundation
import AVKit

///note: FlowCoordinator 정의한 화면 흐름을 실행
struct DetailLyricsViewModelActions {
    let dismissDetailLyricsView: () -> Void
}

///note: ViewController에서 ViewModel한테 입력 이벤트 전달
protocol DetailLyricsViewModelInput {
//    var isLyricsSelect: Bool {get set}
    func dismissDetailLyricsView()
}

///note: ViewModel에서 방출 할 수 있는 Output
protocol DetailLyricsViewModelOutput {
    var songDTO: SongDTO {get}
    var playerManager: PlayerManager {get}
}

typealias DetailLyricsViewModelInOutput = DetailLyricsViewModelInput & DetailLyricsViewModelOutput

final class DetailLyricsViewModel: DetailLyricsViewModelInOutput, PlayableViewModel {
    
    var songDTO: SongDTO
    var playerManager: PlayerManager
    private let actions: DetailLyricsViewModelActions
    
    init(songDTO: SongDTO, playerManger: PlayerManager, actions: DetailLyricsViewModelActions) {
        self.songDTO = songDTO
        self.playerManager = playerManger
        self.actions = actions
    }
    
    func getCurrentLyricsIndex(time: CMTime, inputTimeType: TimeType) -> Int {
        let milliseconds: Int
        
        switch inputTimeType {
            case .milSeconds:
                milliseconds = Int(CMTimeGetSeconds(time))
            case .seconds:
                milliseconds = Int(CMTimeGetSeconds(time) * 1000)
        }
        
        let timeLine = songDTO.timeLineLyrics
        let target = timeLine.filter { $0 <= milliseconds}.max() ?? 0
        let targetIndex = timeLine.firstIndex(of: target)
        
        return targetIndex ?? 0
    }
    
    func dismissDetailLyricsView() {
        actions.dismissDetailLyricsView()
    }
    
    
}
