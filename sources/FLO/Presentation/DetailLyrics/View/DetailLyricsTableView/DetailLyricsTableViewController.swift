//
//  DetailLyricsViewController.swift
//  FLO
//
//  Created by 김성준 on 4/20/24.
//

import UIKit
import AVKit

protocol DetailLyricsTableViewDelegate: AnyObject {
    func isLyricsSelect(isLyricsSelect: Bool)
}

class DetailLyricsTableViewController: UIViewController {
    weak var delegate: DetailLyricsSceneViewControllerDelegate?
    private var isLyricsSelect: Bool = false
    private var focusedLyricsIndex: Int = 0
    private var prevIndex = 0
    
    private lazy var sidebarWidth: CGFloat = {
        return view.bounds.width / 5
    }()
    
    var viewModel: DetailLyricsViewModel! {
        didSet {
            viewModel.playerManager.observer { [weak self] time in
                self?.updateUI(time: time)
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(DetailLyricsCell.self, forCellReuseIdentifier: DetailLyricsCell.reuseIdentifier)
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.indicatorStyle = .white
        
        return tableView
    }()
    
    private lazy var detailLyricsSceneSidebarView: DetailLyricsTableSidebarView = {
        let view = DetailLyricsTableSidebarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(detailLyricsSceneSidebarView)
    }
    
    func config(viewModel: DetailLyricsViewModel, time: CMTime) {
        self.viewModel = viewModel
        self.updateUI(time: time)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            detailLyricsSceneSidebarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailLyricsSceneSidebarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailLyricsSceneSidebarView.widthAnchor.constraint(equalToConstant: sidebarWidth),
            detailLyricsSceneSidebarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func updateUI(time: CMTime) {
        let targetIndex =  viewModel.getCurrentLyricsIndex(time: time, inputTimeType: .seconds)
        focusedLyricsIndex = targetIndex
        
        if let prevCell = tableView.cellForRow(at: IndexPath(row: prevIndex, section: 0)) as? DetailLyricsCell {
            prevCell.disHighlight()
        }
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows, visibleIndexPaths.contains(IndexPath(row: targetIndex, section: 0)) {
            if let cell = tableView.cellForRow(at: IndexPath(row: targetIndex, section: 0)) as? DetailLyricsCell {
                prevIndex = targetIndex
                
                cell.highlight()
            }
        }
    }
    
}

extension DetailLyricsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songDTO.transformedLyrics.count
    }
}

extension DetailLyricsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailLyricsCell.reuseIdentifier, for: indexPath) as? DetailLyricsCell else { return UITableViewCell() }
        let Lyrics = viewModel.songDTO.transformedLyrics
        let timeLine = viewModel.songDTO.timeLineLyrics
        
        cell.configure(lyrics: Lyrics[timeLine[indexPath.row]] ?? "", widthSize: sidebarWidth)
        
        if indexPath.row == focusedLyricsIndex {
            cell.highlight()
        } else {
            cell.disHighlight()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isLyricsSelect else {
            delegate?.dismiss()
            return
        }
        
        let timeLine = viewModel.songDTO.timeLineLyrics
        let time = timeLine[indexPath.row]
        let second = time / 1000 + 1
        
        viewModel.playerManager.moveToTimeLine(to: CMTimeMake(value: Int64(second), timescale: 1))
    }
    
}

extension DetailLyricsTableViewController : DetailLyricsTableViewDelegate {
    func isLyricsSelect(isLyricsSelect: Bool) {
        self.isLyricsSelect = isLyricsSelect
    }
}


