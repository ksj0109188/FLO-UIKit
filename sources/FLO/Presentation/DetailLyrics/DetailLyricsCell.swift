//
//  LyricsCell.swift
//  FLO
//
//  Created by 김성준 on 4/20/24.
//

import UIKit

class DetailLyricsCell: UITableViewCell {
    static let reuseIdentifier = String(describing: DetailLyricsCell.self)

    private lazy var lyricsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    
    func configure(lyrics: String) {
        lyricsLabel.text = lyrics
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews(lyricsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            lyricsLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            lyricsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lyricsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lyricsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func highlight() {
        self.lyricsLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.contentView.backgroundColor = UIColor.yellow
    }
    
    func unHighlihg() {
        self.lyricsLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.backgroundColor = .none
    }

}
