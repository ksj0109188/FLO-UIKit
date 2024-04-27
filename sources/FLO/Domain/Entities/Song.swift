//
//  Song.swift
//  FLO
//
//  Created by 김성준 on 4/15/24.
//

import Foundation
import AVKit
import AVFoundation

struct Song: Decodable {
    let singer: String
    let album: String
    let title: String
    let duration: Int
    let image: String
    let file: String
    let lyrics: String
}

extension Song {
    var transformedLyrics: [Int:String] {
        var lyricsDict = [Int: String]()
        let lines = lyrics.components(separatedBy: "\n")
        for line in lines {
            let components = line.components(separatedBy: "]")
            if components.count > 1,
               let timeString = components.first?.trimmingCharacters(in: CharacterSet(charactersIn: "[")),
               let lyrics = components.last {
                if let milliseconds = Song.convertTimeToMilliseconds(timeString) {
                    lyricsDict[milliseconds] = lyrics
                }
            }
        }
        return lyricsDict
    }
    
    static func convertTimeToMilliseconds(_ timeString: String) -> Int? {
        let timeComponents = timeString.components(separatedBy: ":")
        if timeComponents.count == 3 {
            let minutes = Int(timeComponents[0]) ?? 0
            let seconds = Int(timeComponents[1]) ?? 0
            let milliseconds = Int(timeComponents[2]) ?? 0
            return minutes * 60000 + seconds * 1000 + milliseconds
        }
        return nil
    }
}

extension Song {
    static var dummy = Song(
        singer: "Dummy Singer",
        album: "Dummy Album",
        title: "Dummy Title",
        duration: 198,
        image: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/cover.jpg",
        file: "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-flo/music.mp3",
        lyrics: """
        [00:16:200]we wish you a merry christmas
        [00:18:300]we wish you a merry christmas
        [00:21:100]we wish you a merry christmas
        [00:23:600]and a happy new year
        [00:26:300]we wish you a merry christmas
        [00:28:700]we wish you a merry christmas
        [00:31:400]we wish you a merry christmas
        [00:33:600]and a happy new year
        [00:36:500]good tidings we bring
        [00:38:900]to you and your kin
        [00:41:500]good tidings for christmas
        [00:44:200]and a happy new year
        [00:46:600]Oh, bring us some figgy pudding
        [00:49:300]Oh, bring us some figgy pudding
        [00:52:200]Oh, bring us some figgy pudding
        [00:54:500]And bring it right here
        [00:57:000]Good tidings we bring
        [00:59:700]to you and your kin
        [01:02:100]Good tidings for Christmas
        [01:04:800]and a happy new year
        [01:07:400]we wish you a merry christmas
        [01:10:000]we wish you a merry christmas
        [01:12:500]we wish you a merry christmas
        [01:15:000]and a happy new year
        [01:17:700]We won't go until we get some
        [01:20:200]We won't go until we get some
        [01:22:800]We won't go until we get some
        [01:25:300]So bring some out here
        [01:29:800]연주
        [02:11:900]Good tidings we bring
        [02:14:000]to you and your kin
        [02:16:500]good tidings for christmas
        [02:19:400]and a happy new year
        [02:22:000]we wish you a merry christmas
        [02:24:400]we wish you a merry christmas
        [02:27:000]we wish you a merry christmas
        [02:29:600]and a happy new year
        [02:32:200]Good tidings we bring
        [02:34:500]to you and your kin
        [02:37:200]Good tidings for Christmas
        [02:40:000]and a happy new year
        [02:42:400]Oh, bring us some figgy pudding
        [02:45:000]Oh, bring us some figgy pudding
        [02:47:600]Oh, bring us some figgy pudding
        [02:50:200]And bring it right here
        [02:52:600]we wish you a merry christmas
        [02:55:300]we wish you a merry christmas
        [02:57:900]we wish you a merry christmas
        [03:00:500]and a happy new year
        """
    )
}

