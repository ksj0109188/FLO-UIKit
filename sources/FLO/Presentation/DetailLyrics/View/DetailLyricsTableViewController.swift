//
//  DetailLyricsViewController.swift
//  FLO
//
//  Created by 김성준 on 4/20/24.
//

import UIKit
import AVKit

class DetailLyricsTableViewController: UITableViewController {
    var viewModel: DetailLyricsViewModel! {
        didSet {
            viewModel.playerManger.observer { [weak self] time in
                self?.updateUI(time: time)
            }
        }
    }
    
    private var prevIndex = 0
    
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
    
    func create(viewModel: DetailLyricsViewModel) {
        self.viewModel = viewModel
    }
    
    private func updateUI(time: CMTime) {
        let targetIndex =  viewModel.getCurrentLyricsIndex(time: time, inputTimeType: .seconds)
//        let milliseconds = Int(CMTimeGetSeconds(time) * 1000)
//        let Lyrics = Song.dummy
//        var keys = Array(Lyrics.keys)
        
//        keys.sort { $0 < $1}
        
//        if keys.count > 0 {
//            let target = keys.filter { $0 <= milliseconds}.max() ?? 0
//            let targetIndex = keys.firstIndex(of: target) ?? 0 // 현재 재생중인 cell의 인덱스
            
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows, visibleIndexPaths.contains(IndexPath(row: targetIndex, section: 0)) {
            
            if let prevCell = tableView.cellForRow(at: IndexPath(row: prevIndex, section: 0)) as? DetailLyricsCell {
                prevCell.unHighlihg()
            }
            
            if let cell = tableView.cellForRow(at: IndexPath(row: targetIndex, section: 0)) as? DetailLyricsCell {
                
                prevIndex = targetIndex
                cell.highlight()
            }
        }
            
//        }
    }
    
}

extension DetailLyricsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songDTO.transformedLyrics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailLyricsCell.reuseIdentifier, for: indexPath) as? DetailLyricsCell else { return UITableViewCell() }
        
        let Lyrics = viewModel.songDTO.transformedLyrics
        var keys = Array(Lyrics.keys)
        
        keys.sort { $0 < $1}
        let key = keys[indexPath.row]
        cell.configure(lyrics: Lyrics[key] ?? "Empty")
        cell.unHighlihg()
        
        return cell
    }
    
    // MARK: delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lyrics = viewModel.songDTO.transformedLyrics
        var keys = Array(lyrics.keys)
        keys.sort { $0 < $1 }
        
        let key = keys[indexPath.row]
        let second = key / 1000
       
//        viewModel.playerManger.player.seek(to: CMTimeMake(value: Int64(), timescale: 1))
        viewModel.playerManger.moveToTimeLine(to: CMTimeMake(value: Int64(second), timescale: 1))
    }
    
}

@available(iOS 17.0, *)
#Preview {
    DetailLyricsTableViewController()
}
