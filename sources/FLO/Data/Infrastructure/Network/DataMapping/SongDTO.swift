//
//  SongDTO.swift
//  FLO
//
//  Created by 김성준 on 4/27/24.
//

import Foundation

struct SongDTO: Codable {
    let singer: String
    let album: String
    let title: String
    let duration: Int
    let image: String
    let file: String
    let lyrics: String
    let transformedLyrics: [Int: String]
    ///note: milseconds로 관리
    let timeLineLyrics: [Int]
    
    enum CodingKeys: String, CodingKey {
         case singer, album, title, duration, image, file, lyrics
     }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.singer = try container.decode(String.self, forKey: .singer)
        self.album = try container.decode(String.self, forKey: .album)
        self.title = try container.decode(String.self, forKey: .title)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.image = try container.decode(String.self, forKey: .image)
        self.file = try container.decode(String.self, forKey: .file)
        self.lyrics = try container.decode(String.self, forKey: .lyrics)
        self.transformedLyrics = SongDTO.parseLyrics(self.lyrics)
        self.timeLineLyrics = SongDTO.sortTransformedLyrics(transformedLyrics)
    }
}

extension SongDTO {
    private static func parseLyrics(_ lyrics: String) -> [Int: String] {
        var lyricsDict = [Int: String]()
        let lines = lyrics.components(separatedBy: "\n")
        for line in lines {
            let components = line.components(separatedBy: "]")
            if components.count > 1,
               let timeString = components.first?.trimmingCharacters(in: CharacterSet(charactersIn: "[")),
               let lyrics = components.last {
                if let milliseconds = SongDTO.convertTimeToMilliseconds(timeString) {
                    lyricsDict[milliseconds] = lyrics
                }
            }
        }
        
        return lyricsDict
    }
    
    private static func convertTimeToMilliseconds(_ timeString: String) -> Int? {
        let timeComponents = timeString.components(separatedBy: ":")
        if timeComponents.count == 3 {
            let minutes = Int(timeComponents[0]) ?? 0
            let seconds = Int(timeComponents[1]) ?? 0
            let milliseconds = Int(timeComponents[2]) ?? 0
            return minutes * 60000 + seconds * 1000 + milliseconds
        }
        return nil
    }
    
    private static func sortTransformedLyrics(_ transformedLyrics : [Int: String]) -> [Int] {
        var keys = Array(transformedLyrics.keys)
        keys.sort { $0 < $1 }
        
        return keys
    }
}
