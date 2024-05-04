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
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private lazy var detailLyricsSceneSidebarView: DetailLyricsTableSidebarView = {
        let view = DetailLyricsTableSidebarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    private var prevIndex = 0
    private lazy var sidebarWidth: CGFloat = {
        return view.bounds.width / 5
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
    
    func config(viewModel: DetailLyricsViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailLyricsSceneSidebarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailLyricsSceneSidebarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailLyricsSceneSidebarView.widthAnchor.constraint(equalToConstant: sidebarWidth),
            detailLyricsSceneSidebarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateUI(time: CMTime) {
        let targetIndex =  viewModel.getCurrentLyricsIndex(time: time, inputTimeType: .seconds)
        
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows, visibleIndexPaths.contains(IndexPath(row: targetIndex, section: 0)) {
            if let prevCell = tableView.cellForRow(at: IndexPath(row: prevIndex, section: 0)) as? DetailLyricsCell {
                prevCell.unHighlihg()
            }
            
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
        adjustCellWidth(cell: cell)
        
        let Lyrics = viewModel.songDTO.transformedLyrics
        let timeLine = viewModel.songDTO.timeLineLyrics
        
        cell.configure(lyrics: Lyrics[timeLine[indexPath.row]] ?? "", width: sidebarWidth)
        cell.unHighlihg()
        
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
    
    private func adjustCellWidth(cell: UITableViewCell) {
        let viewWidth = view.bounds.width
        
        NSLayoutConstraint.activate([
            cell.widthAnchor.constraint(equalToConstant: viewWidth - sidebarWidth - 5)
        ])
    }
}

extension DetailLyricsTableViewController : DetailLyricsTableViewDelegate {
    func isLyricsSelect(isLyricsSelect: Bool) {
        self.isLyricsSelect = isLyricsSelect
    }
}


