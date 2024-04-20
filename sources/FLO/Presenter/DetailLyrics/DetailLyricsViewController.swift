//
//  DetailLyricsViewController.swift
//  FLO
//
//  Created by 김성준 on 4/20/24.
//

import UIKit
import AVKit

class DetailLyricsViewController: UITableViewController {
    let viewModelData = Song.dummy
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
        tableView.register(LyricsCell.self, forCellReuseIdentifier: LyricsCell.reuseIdentifier)
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
            
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows, visibleIndexPaths.contains(IndexPath(row: targetIndex, section: 0)) {
                
                if targetIndex > 0, let prevCell = tableView.cellForRow(at: IndexPath(row: targetIndex - 1, section: 0)) as? LyricsCell {
                    prevCell.unHighlihg()
                    tableView.reloadRows(at: [IndexPath(row: targetIndex - 1, section: 0)], with: .none)
                }
                
                if let cell = tableView.cellForRow(at: IndexPath(row: targetIndex, section: 0)) as? LyricsCell {
                    // 셀의 UI를 업데이트
                    cell.highlight()
                    tableView.reloadRows(at: [IndexPath(row: targetIndex, section: 0)], with: .none)
                }
            }
            
        
            
        }
        
    }
    
}

extension DetailLyricsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelData.transformedLyrics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LyricsCell.reuseIdentifier, for: indexPath) as? LyricsCell else { return UITableViewCell() }
        
        let Lyrics = Song.dummy.transformedLyrics
        var keys = Array(Lyrics.keys)
        
        keys.sort { $0 < $1}
        let key = keys[indexPath.row]
        cell.configure(timeLine: key, lyrics: Lyrics[key] ?? "Empty")
        
        return cell
    }
    
    // MARK: delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

@available(iOS 17.0, *)
#Preview {
    DetailLyricsViewController()
}
