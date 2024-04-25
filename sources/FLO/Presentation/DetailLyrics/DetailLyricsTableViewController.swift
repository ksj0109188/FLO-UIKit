//
//  DetailLyricsViewController.swift
//  FLO
//
//  Created by 김성준 on 4/20/24.
//

import UIKit
import AVKit

//TODO: playerManger delegate pattern 사용 필요
class DetailLyricsTableViewController: UITableViewController {
    let viewModelData = Song.dummy
    var prevIndex = 0
    
    var playerManger: PlayerManager? {
        didSet {
            playerManger?.observer { [weak self] time in
                self?.updateUI(time: time)
            }
        }
    }
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("􀆄", for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        tableView.separatorStyle = .none
        tableView.register(DetailLyricsCell.self, forCellReuseIdentifier: DetailLyricsCell.reuseIdentifier)
        view.addSubviews(dismissButton)
    }
    
    private func updateUI(time: CMTime) {
        let milliseconds = Int(CMTimeGetSeconds(time) * 1000)
        let Lyrics = Song.dummy.transformedLyrics
        var keys = Array(Lyrics.keys)
        
        keys.sort { $0 < $1}
        
        if keys.count > 0 {
            let target = keys.filter { $0 <= milliseconds}.max() ?? 0
            let targetIndex = keys.firstIndex(of: target) ?? 0 // 현재 재생중인 cell의 인덱스
            print("prevIndex", prevIndex)
            print("targetIndex", targetIndex)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows, visibleIndexPaths.contains(IndexPath(row: targetIndex, section: 0)) {
                
                if let prevCell = tableView.cellForRow(at: IndexPath(row: prevIndex, section: 0)) as? DetailLyricsCell {
                    prevCell.unHighlihg()
                }
                
                if let cell = tableView.cellForRow(at: IndexPath(row: targetIndex, section: 0)) as? DetailLyricsCell {
                    // 셀의 UI를 업데이트
                    prevIndex = targetIndex
                    cell.highlight()
                }
            }
            
        }
    }
    
}

extension DetailLyricsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelData.transformedLyrics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailLyricsCell.reuseIdentifier, for: indexPath) as? DetailLyricsCell else { return UITableViewCell() }
        
        let Lyrics = viewModelData.transformedLyrics
        var keys = Array(Lyrics.keys)
        
        keys.sort { $0 < $1}
        let key = keys[indexPath.row]
        cell.configure(lyrics: Lyrics[key] ?? "Empty")
        cell.unHighlihg()
        
        return cell
    }
    
    // MARK: delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lyrics = viewModelData.transformedLyrics
        var keys = Array(lyrics.keys)
        keys.sort { $0 < $1 }
        
        let key = keys[indexPath.row]
        let second = key / 1000
//        print(key)
//        print(second)
       
        playerManger?.player.seek(to: CMTimeMake(value: Int64(second), timescale: 1))
    }
    
}

@available(iOS 17.0, *)
#Preview {
    DetailLyricsTableViewController()
}
