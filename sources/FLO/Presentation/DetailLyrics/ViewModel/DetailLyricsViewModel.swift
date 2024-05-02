//
//  DetailLyricsViewModel.swift
//  FLO
//
//  Created by 김성준 on 5/1/24.
//

import Foundation
import AVKit

///note: ViewController에서 ViewModel한테 입력 이벤트 전달
protocol DetailLyricsViewModelInput {
    
}

///note: ViewModel에서 방출 할 수 있는 Output
protocol DetailLyricsViewModelOutput {
    var songDTO: SongDTO {get}
    var playerManger: PlayerManager {get}
}

typealias DetailLyricsViewModelInOutput = DetailLyricsViewModelInput & DetailLyricsViewModelOutput

final class DetailLyricsViewModel: DetailLyricsViewModelInOutput {
    var songDTO: SongDTO
    var playerManger: PlayerManager
    
    init(songDTO: SongDTO, playerManger: PlayerManager) {
        self.songDTO = songDTO
        self.playerManger = playerManger
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
    
    
}
